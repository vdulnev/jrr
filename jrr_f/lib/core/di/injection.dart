import 'dart:io' show Platform;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import '../db/app_database.dart';
import '../network/mcws_xml_parser.dart';
import '../../features/connection/data/repositories/connection_repository.dart';
import '../../features/connection/data/repositories/connection_repository_impl.dart';
import '../../features/favorites/data/repositories/favorites_repository.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/library/data/repositories/library_repository.dart';
import '../../features/library/data/repositories/library_repository_impl.dart';
import '../../features/player/data/repositories/player_repository.dart';
import '../../features/player/data/repositories/player_repository_impl.dart';
import '../../features/queue/data/repositories/queue_repository.dart';
import '../../features/queue/data/repositories/queue_repository_impl.dart';
import '../../features/zones/data/repositories/zone_repository.dart';
import '../../features/zones/data/repositories/zone_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Talker — single instance, shared by all loggers
  getIt.registerSingleton<Talker>(
    Talker(
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(enableColors: !Platform.isIOS),
      ),
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
  getIt.registerSingleton<LibraryRepository>(LibraryRepositoryImpl());

  // Favorites repository — manages favorite items from browse screen
  getIt.registerSingleton<FavoritesRepository>(FavoritesRepositoryImpl());
}
