import 'package:audio_service/audio_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../features/connection/data/repositories/connection_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository.dart';
import '../../features/library/data/repositories/library_repository.dart';
import '../../features/offline/data/repositories/downloads_repository.dart';
import '../../features/offline/services/download_service.dart';
import '../../features/player/data/repositories/player_repository.dart';
import '../../features/player/data/repositories/recently_played_repository.dart';
import '../../features/player/services/android_auto_player_service.dart';
import '../../features/player/services/jrr_audio_handler.dart';
import '../../features/player/services/local_player_service.dart';
import '../../features/queue/data/repositories/local_queue_repository.dart';
import '../../features/queue/data/repositories/queue_repository.dart';
import '../../features/zones/data/repositories/zone_repository.dart';
import '../../features/zones/services/android_auto_session_service.dart';
import '../db/app_database.dart';
import '../network/mcws_client.dart';
import '../network/mcws_xml_parser.dart';
import 'injection.dart';

part 'providers.g.dart';

// Step 1 of the get_it → Riverpod migration. Every type currently registered
// in `getIt` is mirrored here as a keepAlive provider whose body delegates to
// `getIt<T>()`, so behaviour is identical while call sites are migrated.
// Once every caller reads through these providers, the bodies will be
// replaced with real construction and `injection.dart` deleted.

@Riverpod(keepAlive: true)
Talker talker(Ref ref) => getIt<Talker>();

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => getIt<AppDatabase>();

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) =>
    getIt<FlutterSecureStorage>();

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => getIt<SharedPreferences>();

@Riverpod(keepAlive: true)
McwsXmlParser mcwsXmlParser(Ref ref) => getIt<McwsXmlParser>();

@Riverpod(keepAlive: true)
McwsClient mcwsClient(Ref ref) => getIt<McwsClient>();

@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) =>
    getIt<ConnectionRepository>();

@Riverpod(keepAlive: true)
PlayerRepository playerRepository(Ref ref) => getIt<PlayerRepository>();

@Riverpod(keepAlive: true)
ZoneRepository zoneRepository(Ref ref) => getIt<ZoneRepository>();

@Riverpod(keepAlive: true)
QueueRepository queueRepository(Ref ref) => getIt<QueueRepository>();

@Riverpod(keepAlive: true)
LocalQueueRepository localQueueRepository(Ref ref) =>
    getIt<LocalQueueRepository>();

@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) => getIt<LibraryRepository>();

@Riverpod(keepAlive: true)
FavoritesRepository favoritesRepository(Ref ref) =>
    getIt<FavoritesRepository>();

@Riverpod(keepAlive: true)
DownloadsRepository downloadsRepository(Ref ref) =>
    getIt<DownloadsRepository>();

@Riverpod(keepAlive: true)
DownloadService downloadService(Ref ref) => getIt<DownloadService>();

@Riverpod(keepAlive: true)
AndroidAutoSessionService androidAutoSessionService(Ref ref) =>
    getIt<AndroidAutoSessionService>();

@Riverpod(keepAlive: true)
RecentlyPlayedRepository recentlyPlayedRepository(Ref ref) =>
    getIt<RecentlyPlayedRepository>();

// The local_player_provider feature already exposes a derived
// `localPlayerServiceProvider` that picks between these two concrete
// instances per-zone. The providers below provide raw access to each
// pre-built singleton (overridden in main.dart) without clashing with that
// derived provider.
@Riverpod(keepAlive: true)
LocalPlayerService localPlayerInstance(Ref ref) => getIt<LocalPlayerService>();

@Riverpod(keepAlive: true)
AndroidAutoPlayerService androidAutoPlayerInstance(Ref ref) =>
    getIt<AndroidAutoPlayerService>();

@Riverpod(keepAlive: true)
JrrAudioHandler jrrAudioHandler(Ref ref) => getIt<JrrAudioHandler>();

// Re-export `AudioHandler` interface separately in case callers depend on
// the abstract type rather than the concrete JrrAudioHandler.
@Riverpod(keepAlive: true)
AudioHandler audioHandler(Ref ref) => getIt<JrrAudioHandler>();
