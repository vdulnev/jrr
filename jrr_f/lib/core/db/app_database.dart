import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Persisted server configurations.
/// Credentials are stored via flutter_secure_storage; [passwordKey] is
/// the lookup key used to retrieve the actual password from the OS keychain.
class SavedServers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get host => text()();
  IntColumn get port => integer().withDefault(const Constant(52199))();
  TextColumn get username => text()();

  /// Key used to look up the password in flutter_secure_storage.
  TextColumn get passwordKey => text()();

  /// Cached friendly name from the last successful Alive call.
  TextColumn get friendlyName => text().nullable()();

  /// Last successful connection timestamp (unix ms). Used for auto-selection.
  IntColumn get lastUsedAt => integer().nullable()();

  /// Cached auth token from the last successful authentication.
  TextColumn get authToken => text().nullable()();
}

/// Favorite items from the browse screen.
/// Can only be browse items (folders/nodes).
class Favorites extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Type: always 'browse_item'
  TextColumn get type => text()();

  /// Browse item node id (String)
  TextColumn get identifier => text()();

  /// Display name for the browse item
  TextColumn get displayName => text()();

  /// Timestamp when the favorite was added (unix ms)
  IntColumn get addedAt => integer()();
}

/// Tracks in the local zone queue.
class LocalQueueTracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fileKey => integer()();
  TextColumn get trackJson => text()(); // Serialized Track object
  IntColumn get position => integer()(); // Position in the queue
}

@DriftDatabase(tables: [SavedServers, Favorites, LocalQueueTracks])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          await m.createTable(favorites);
        }
        if (from < 3 && to >= 3) {
          await m.createTable(localQueueTracks);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'jrr');
  }
}
