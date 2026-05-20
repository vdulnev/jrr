import 'package:audio_service/audio_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../features/connection/data/repositories/connection_repository.dart';
import '../../features/connection/data/repositories/connection_repository_impl.dart';
import '../../features/favorites/data/repositories/favorites_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/library/data/repositories/library_repository.dart';
import '../../features/library/data/repositories/library_repository_impl.dart';
import '../../features/offline/data/repositories/downloads_repository.dart';
import '../../features/offline/data/repositories/downloads_repository_impl.dart';
import '../../features/offline/services/download_service.dart';
import '../../features/player/data/repositories/player_repository.dart';
import '../../features/player/data/repositories/player_repository_impl.dart';
import '../../features/player/data/repositories/recently_played_repository.dart';
import '../../features/player/services/android_auto_player_service.dart';
import '../../features/player/services/jrr_audio_handler.dart';
import '../../features/player/services/local_player_service.dart';
import '../../features/queue/data/repositories/local_queue_repository.dart';
import '../../features/queue/data/repositories/local_queue_repository_impl.dart';
import '../../features/queue/data/repositories/queue_repository.dart';
import '../../features/queue/data/repositories/queue_repository_impl.dart';
import '../../features/zones/data/repositories/zone_repository.dart';
import '../../features/zones/data/repositories/zone_repository_impl.dart';
import '../../features/zones/services/android_auto_session_service.dart';
import '../db/app_database.dart';
import '../network/mcws_client.dart';
import '../network/mcws_xml_parser.dart';

part 'providers.g.dart';

// Providers that require pre-`runApp` async initialization or wiring
// (Talker, SharedPreferences, the audio handlers, AndroidAutoSessionService)
// are stub-bodied here and overridden in main.dart via ProviderScope.
// Everything else is constructed directly through ref.watch chains.

@Riverpod(keepAlive: true)
Talker talker(Ref ref) =>
    throw UnimplementedError('talkerProvider must be overridden in main.dart');

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in main.dart',
);

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) =>
    const FlutterSecureStorage();

@Riverpod(keepAlive: true)
McwsXmlParser mcwsXmlParser(Ref ref) => McwsXmlParser();

/// Reactive accessor to the active session's [McwsClient]. Invalidates
/// itself whenever the connection repository swaps the client (connect,
/// restore, clearSession), so repos that read this lazily always see the
/// latest instance. Throws when no session is bound — callers should gate
/// MCWS calls on the active zone not being a virtual one.
@Riverpod(keepAlive: true)
McwsClient mcwsClient(Ref ref) {
  final listenable = ref.read(connectionRepositoryProvider).clientListenable;
  void listener() => ref.invalidateSelf();
  listenable.addListener(listener);
  ref.onDispose(() => listenable.removeListener(listener));
  final client = listenable.value;
  if (client == null) {
    throw StateError('McwsClient is not available — no active session');
  }
  return client;
}

@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) => ConnectionRepositoryImpl(
  db: ref.watch(appDatabaseProvider),
  secureStorage: ref.watch(flutterSecureStorageProvider),
  parser: ref.watch(mcwsXmlParserProvider),
  talker: ref.watch(talkerProvider),
);

@Riverpod(keepAlive: true)
PlayerRepository playerRepository(Ref ref) =>
    PlayerRepositoryImpl(client: () => ref.read(mcwsClientProvider));

@Riverpod(keepAlive: true)
ZoneRepository zoneRepository(Ref ref) => ZoneRepositoryImpl(
  client: () => ref.read(mcwsClientProvider),
  connectionRepository: ref.read(connectionRepositoryProvider),
  prefs: ref.read(sharedPreferencesProvider),
  autoSession: ref.read(androidAutoSessionServiceProvider),
);

@Riverpod(keepAlive: true)
QueueRepository queueRepository(Ref ref) =>
    QueueRepositoryImpl(client: () => ref.read(mcwsClientProvider));

@Riverpod(keepAlive: true)
LocalQueueRepository localQueueRepository(Ref ref) => LocalQueueRepositoryImpl(
  db: ref.read(appDatabaseProvider),
  talker: ref.read(talkerProvider),
);

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) =>
    LibraryRepositoryImpl(client: () => ref.read(mcwsClientProvider));

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) =>
    FavoritesRepositoryImpl(db: ref.read(appDatabaseProvider));

@Riverpod(keepAlive: true)
DownloadsRepository downloadsRepository(Ref ref) => DownloadsRepositoryImpl(
  db: ref.read(appDatabaseProvider),
  talker: ref.read(talkerProvider),
);

@Riverpod(keepAlive: true)
DownloadService downloadService(Ref ref) {
  final service = DownloadService(
    repository: ref.read(downloadsRepositoryProvider),
    connectionRepository: ref.read(connectionRepositoryProvider),
    talker: ref.read(talkerProvider),
  );
  service.start();
  return service;
}

@Riverpod(keepAlive: true)
RecentlyPlayedRepository recentlyPlayedRepository(Ref ref) =>
    RecentlyPlayedRepository(ref.read(sharedPreferencesProvider));

@Riverpod(keepAlive: true)
AndroidAutoSessionService androidAutoSessionService(Ref ref) =>
    throw UnimplementedError(
      'androidAutoSessionServiceProvider must be overridden in main.dart',
    );

// The local_player_provider feature already exposes a derived
// `localPlayerServiceProvider` that picks between these two concrete
// instances per-zone. The providers below provide raw access to each
// pre-built singleton (overridden in main.dart) without clashing with that
// derived provider.
@Riverpod(keepAlive: true)
LocalPlayerService localPlayerInstance(Ref ref) => throw UnimplementedError(
  'localPlayerInstanceProvider must be overridden in main.dart',
);

@Riverpod(keepAlive: true)
AndroidAutoPlayerService androidAutoPlayerInstance(Ref ref) =>
    throw UnimplementedError(
      'androidAutoPlayerInstanceProvider must be overridden in main.dart',
    );

@Riverpod(keepAlive: true)
JrrAudioHandler jrrAudioHandler(Ref ref) => throw UnimplementedError(
  'jrrAudioHandlerProvider must be overridden in main.dart',
);

// Re-export `AudioHandler` interface separately in case callers depend on
// the abstract type rather than the concrete JrrAudioHandler.
@Riverpod(keepAlive: true)
AudioHandler audioHandler(Ref ref) => throw UnimplementedError(
  'audioHandlerProvider must be overridden in main.dart',
);
