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

  /// Connect over HTTPS instead of HTTP. JRiver MC's HTTPS uses a self-signed
  /// certificate, so the network layer must be configured to accept it.
  BoolColumn get useSsl => boolean().withDefault(const Constant(false))();

  /// HTTPS port (default JRiver MC SSL port is 52200). Used only when
  /// [useSsl] is true.
  IntColumn get sslPort => integer().withDefault(const Constant(52200))();
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
  TextColumn get zoneId => text().withDefault(const Constant('local'))();
  IntColumn get fileKey => integer()();
  TextColumn get trackJson => text()(); // Serialized Track object
  IntColumn get position => integer()(); // Position in the queue
}

/// Metadata for the local zone queue.
class LocalQueueState extends Table {
  TextColumn get zoneId => text()();
  IntColumn get currentIndex => integer().withDefault(const Constant(-1))();

  @override
  Set<Column> get primaryKey => {zoneId};
}

/// Fully downloaded tracks for offline playback.
@DataClassName('DownloadedTrackRow')
class DownloadedTracks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fileKey => integer().unique()();
  TextColumn get trackJson => text()(); // Serialized Track object
  TextColumn get localPath => text()();
  TextColumn get artworkPath => text().nullable()();
  TextColumn get albumGroupId => text()();
  TextColumn get albumArtist => text()();
  TextColumn get album => text()();
  TextColumn get dateReadable => text()();
  IntColumn get discNumber => integer()();
  IntColumn get totalDiscs => integer()();
  IntColumn get trackNumber => integer()();
  IntColumn get fileSizeBytes => integer()();
  IntColumn get downloadedAt => integer()(); // unix ms
}

/// Queue and status of in-progress or failed downloads.
@DataClassName('DownloadJobRow')
class DownloadJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fileKey => integer().unique()();
  TextColumn get trackJson => text()(); // Serialized Track object
  TextColumn get state => text()(); // queued, running, failed, cancelled
  TextColumn get error => text().nullable()();
  IntColumn get bytesDone => integer()();
  IntColumn get bytesTotal => integer()();
  IntColumn get enqueuedAt => integer()(); // unix ms
  IntColumn get startedAt => integer().nullable()(); // unix ms
}

@DriftDatabase(
  tables: [
    SavedServers,
    Favorites,
    LocalQueueTracks,
    LocalQueueState,
    DownloadedTracks,
    DownloadJobs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2 && to >= 2) {
          await m.createTable(favorites);
        }
        if (from < 3 && to >= 3) {
          await m.createTable(localQueueTracks);
        }
        if (from < 4 && to >= 4) {
          await m.createTable(localQueueState);
        }
        if (from < 5 && to >= 5) {
          await m.createTable(downloadedTracks);
          await m.createTable(downloadJobs);
        }
        if (from < 6 && to >= 6) {
          // Add zoneId to localQueueTracks
          await m.addColumn(localQueueTracks, localQueueTracks.zoneId);

          // Recreate localQueueState because of primary key change
          await m.deleteTable('local_queue_state');
          await m.createTable(localQueueState);
        }
        if (from < 7 && to >= 7) {
          await m.addColumn(savedServers, savedServers.useSsl);
          await m.addColumn(savedServers, savedServers.sslPort);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'jrr');
  }
}
