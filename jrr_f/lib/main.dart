import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger_observer.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/di/providers.dart';
import 'core/logging/file_log_observer.dart';
import 'core/network/ssl_trust.dart';
import 'features/player/data/models/local_audio_quality.dart';
import 'features/player/services/local_player_service.dart';
import 'features/player/services/android_auto_player_service.dart';
import 'features/player/services/jrr_audio_handler.dart';

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
  await configureDependencies();

  final talker = getIt<Talker>();
  final prefs = getIt<SharedPreferences>();

  // Initialize audio_service. The handler manages multiple sub-players
  // (LocalPlayerService for phone, AndroidAutoPlayerService for the car).
  final localAudioPlayer = AudioPlayer();
  final autoAudioPlayer = AudioPlayer();

  final localHandler = LocalPlayerService(
    player: localAudioPlayer,
    talker: talker,
    qualityResolver: () => LocalAudioQuality.fromName(
      getIt<SharedPreferences>().getString('local_audio_quality'),
    ),
  );

  final autoHandler = AndroidAutoPlayerService(
    player: autoAudioPlayer,
    talker: talker,
    qualityResolver: () => LocalAudioQuality.fromName(
      getIt<SharedPreferences>().getString('local_audio_quality'),
    ),
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

  getIt.registerSingleton<LocalPlayerService>(localHandler);
  getIt.registerSingleton<AndroidAutoPlayerService>(autoHandler);
  getIt.registerSingleton<JrrAudioHandler>(mainHandler);

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

  runApp(
    ProviderScope(
      // Hand pre-initialized async values to Riverpod so providers don't
      // have to delegate to getIt to resolve them. getIt still holds the
      // same instances during the in-progress migration; call sites move
      // to ref.read in subsequent steps.
      overrides: [
        talkerProvider.overrideWithValue(talker),
        sharedPreferencesProvider.overrideWithValue(prefs),
        localPlayerServiceProvider.overrideWithValue(localHandler),
        androidAutoPlayerServiceProvider.overrideWithValue(autoHandler),
        jrrAudioHandlerProvider.overrideWithValue(mainHandler),
        audioHandlerProvider.overrideWithValue(mainHandler),
      ],
      observers: [TalkerRiverpodObserver(talker: talker)],
      child: const App(),
    ),
  );
}
