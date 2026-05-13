import 'dart:io' show Platform;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import '../db/app_database.dart';
import '../logging/file_log_observer.dart';
import '../network/mcws_xml_parser.dart';
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
import '../../features/queue/data/repositories/local_queue_repository.dart';
import '../../features/queue/data/repositories/local_queue_repository_impl.dart';
import '../../features/queue/data/repositories/queue_repository.dart';
import '../../features/queue/data/repositories/queue_repository_impl.dart';
import '../../features/zones/data/repositories/zone_repository.dart';
import '../../features/zones/data/repositories/zone_repository_impl.dart';
import '../../features/zones/services/android_auto_session_service.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Talker — single instance, shared by all loggers. The FileLogObserver
  // mirrors every log line to the on-disk session log so the user can
  // export it from the Server Manager screen.
  getIt.registerSingleton<Talker>(
    Talker(
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(enableColors: !Platform.isIOS),
      ),
      observer: FileLogObserver(),
    ),
  );

  // Persistent storage
  getIt.registerSingleton<AppDatabase>(AppDatabase());
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  // SharedPreferences for ephemeral UI flags
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // MCWS XML parser — stateless, safe as singleton
  getIt.registerSingleton<McwsXmlParser>(McwsXmlParser());

  // Connection repository — manages active session and server persistence
  getIt.registerSingleton<ConnectionRepository>(
    ConnectionRepositoryImpl(
      db: getIt<AppDatabase>(),
      secureStorage: getIt<FlutterSecureStorage>(),
      parser: getIt<McwsXmlParser>(),
      talker: getIt<Talker>(),
    ),
  );

  // Player, zone, queue, and library repositories — resolve McwsClient at call-time
  getIt.registerSingleton<PlayerRepository>(PlayerRepositoryImpl());
  getIt.registerSingleton<ZoneRepository>(ZoneRepositoryImpl());
  getIt.registerSingleton<QueueRepository>(QueueRepositoryImpl());
  getIt.registerSingleton<LocalQueueRepository>(
    LocalQueueRepositoryImpl(getIt<AppDatabase>()),
  );
  getIt.registerSingleton<LibraryRepository>(LibraryRepositoryImpl());

  // Offline / Downloads
  getIt.registerSingleton<DownloadsRepository>(
    DownloadsRepositoryImpl(db: getIt<AppDatabase>(), talker: getIt<Talker>()),
  );
  final downloadService = DownloadService(
    repository: getIt<DownloadsRepository>(),
    connectionRepository: getIt<ConnectionRepository>(),
    talker: getIt<Talker>(),
  );
  downloadService.start();
  getIt.registerSingleton<DownloadService>(downloadService);

  // Note: AudioPlayer + LocalPlayerService are constructed in main.dart via
  // AudioService.init so that audio_service is initialized before the widget
  // tree builds (required for the system media notification, lock-screen
  // controls, and Android Auto). Both are registered into getIt from there.

  // Android Auto session detection — flipped to "connected" the first time
  // Auto calls into the audio handler's browse API and back to "disconnected"
  // after a debounced inactivity timeout. Lives outside main.dart so
  // LocalPlayerService can resolve it during its getChildren override.
  getIt.registerSingleton<AndroidAutoSessionService>(
    AndroidAutoSessionService(),
  );

  // Favorites repository — manages favorite items from browse screen
  getIt.registerSingleton<FavoritesRepository>(FavoritesRepositoryImpl());
}
