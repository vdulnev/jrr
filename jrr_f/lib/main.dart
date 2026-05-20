import 'dart:io' show Platform;
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'app.dart';
import 'core/db/app_database.dart';
import 'core/di/providers.dart';
import 'core/logging/file_log_observer.dart';
import 'core/network/mcws_client.dart';
import 'core/network/mcws_xml_parser.dart';
import 'core/network/ssl_trust.dart';
import 'features/connection/data/repositories/connection_repository_impl.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/library/data/repositories/library_repository_impl.dart';
import 'features/offline/data/repositories/downloads_repository_impl.dart';
import 'features/player/data/models/local_audio_quality.dart';
import 'features/player/data/repositories/recently_played_repository.dart';
import 'features/player/services/android_auto_player_service.dart';
import 'features/player/services/jrr_audio_handler.dart';
import 'features/player/services/local_player_service.dart';
import 'features/zones/services/android_auto_session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock phones (shortest side < 600dp) to portrait. Tablets/desktop keep
  // all orientations. The check uses the platform view so it runs before
  // any widget tree exists.
  final view = WidgetsBinding.instance.platformDispatcher.views.first;
  final shortestSide = (view.physicalSize / view.devicePixelRatio).shortestSide;
  if (shortestSide < 600) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Install before any HttpClient is constructed so saved-server SSL hosts
  // can be added to the trust list as the session is restored.
  JRiverHttpOverrides.install();
  // Truncate-and-open the log file before Talker is constructed so every
  // log from this session lands in the file.
  await FileLogObserver.init();

  final talker = Talker(
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(enableColors: !Platform.isIOS),
    ),
    observer: FileLogObserver(),
  );
  final prefs = await SharedPreferences.getInstance();

  // Pre-build the long-lived singletons that the audio handlers depend on,
  // so the same instances are reused by the runtime ProviderScope below
  // (no duplicate ConnectionRepository, no diverging ValueListenable).
  final db = AppDatabase();
  const secureStorage = FlutterSecureStorage();
  final parser = McwsXmlParser();
  final connectionRepo = ConnectionRepositoryImpl(
    db: db,
    secureStorage: secureStorage,
    parser: parser,
    talker: talker,
  );
  final downloadsRepo = DownloadsRepositoryImpl(db: db, talker: talker);
  final recentlyPlayedRepo = RecentlyPlayedRepository(prefs);
  // LibraryRepository / FavoritesRepository are also needed by the AA
  // handler. They're constructed via providers below so the same instances
  // back both call paths.

  McwsClient resolveMcwsClient() {
    final client = connectionRepo.clientListenable.value;
    if (client == null) {
      throw StateError('McwsClient is not available — no active session');
    }
    return client;
  }

  // Initialize audio_service. The handler manages multiple sub-players
  // (LocalPlayerService for phone, AndroidAutoPlayerService for the car).
  final localAudioPlayer = AudioPlayer();
  final autoAudioPlayer = AudioPlayer();

  // The AA audio handler also needs library/favorites repos. Constructing
  // them here lets the same instances back the Riverpod overrides below
  // without spinning up a separate bootstrap ProviderContainer.
  final libraryRepo = LibraryRepositoryImpl(client: resolveMcwsClient);
  final favoritesRepo = FavoritesRepositoryImpl(db: db);

  final localHandler = LocalPlayerService(
    player: localAudioPlayer,
    talker: talker,
    downloadsRepo: downloadsRepo,
    connectionRepo: connectionRepo,
    recentlyPlayedRepo: recentlyPlayedRepo,
    mcwsClientResolver: resolveMcwsClient,
    qualityResolver: () =>
        LocalAudioQuality.fromName(prefs.getString('local_audio_quality')),
  );

  final autoHandler = AndroidAutoPlayerService(
    player: autoAudioPlayer,
    talker: talker,
    downloadsRepo: downloadsRepo,
    libraryRepo: libraryRepo,
    favoritesRepo: favoritesRepo,
    connectionRepo: connectionRepo,
    mcwsClientResolver: resolveMcwsClient,
    hasActiveSession: () => connectionRepo.clientListenable.value != null,
    qualityResolver: () =>
        LocalAudioQuality.fromName(prefs.getString('local_audio_quality')),
  );

  final mainHandler = await AudioService.init(
    builder: () =>
        JrrAudioHandler(localPlayer: localHandler, autoPlayer: autoHandler),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.jriver.remote.audio',
      androidNotificationChannelName: 'JRiver Remote playback',
      androidNotificationIcon: 'drawable/ic_audio_service_notification',
      androidNotificationOngoing: true,
    ),
  );

  await localHandler.init();
  await autoHandler.init();

  // AndroidAutoSessionService is constructed after the audio handlers so
  // its resolvers can return them directly — no late-binding fallback
  // needed once we're past AudioService.init.
  final autoSession = AndroidAutoSessionService(
    talker: talker,
    handlerResolver: () => mainHandler,
    autoPlayerResolver: () => autoHandler,
  );

  // Flutter framework errors (widget build exceptions, layout overflows, etc.)
  // Use details.toStringDeep() so the diagnostic property tree is captured —
  // for layout errors that includes the offending RenderFlex, its parents,
  // and constraint details. Without this we only get the headline message.
  FlutterError.onError = (FlutterErrorDetails details) {
    final diagnostics = details.toDiagnosticsNode().toStringDeep(
      minLevel: DiagnosticLevel.debug,
    );
    talker.error(
      'Flutter error: ${details.exceptionAsString()}\n$diagnostics',
      details.exception,
      details.stack,
    );
  };

  // Errors thrown outside the Flutter framework (async gaps, platform channels)
  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    // just_audio reports load cancellations (e.g. when a second setAudioSources
    // call supersedes an in-flight one) as PlayerInterruptedException. The
    // service-layer try/catch handles them, but they also surface here through
    // just_audio's internal pipeline. Treat as expected and log at info.
    if (error is PlayerInterruptedException) {
      talker.info('just_audio load interrupted: ${error.message}');
      return true;
    }
    talker.error('Uncaught platform error', error, stack);
    return true; // mark as handled
  };

  final container = ProviderContainer(
    overrides: [
      talkerProvider.overrideWithValue(talker),
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(db),
      flutterSecureStorageProvider.overrideWithValue(secureStorage),
      mcwsXmlParserProvider.overrideWithValue(parser),
      connectionRepositoryProvider.overrideWithValue(connectionRepo),
      downloadsRepositoryProvider.overrideWithValue(downloadsRepo),
      recentlyPlayedRepositoryProvider.overrideWithValue(recentlyPlayedRepo),
      libraryRepositoryProvider.overrideWithValue(libraryRepo),
      favoritesRepositoryProvider.overrideWithValue(favoritesRepo),
      localPlayerInstanceProvider.overrideWithValue(localHandler),
      androidAutoPlayerInstanceProvider.overrideWithValue(autoHandler),
      jrrAudioHandlerProvider.overrideWithValue(mainHandler),
      audioHandlerProvider.overrideWithValue(mainHandler),
      androidAutoSessionServiceProvider.overrideWithValue(autoSession),
    ],
    observers: [TalkerRiverpodObserver(talker: talker)],
  );

  // Fire DownloadService.start() now so its retry timer is running.
  container.read(downloadServiceProvider);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}
