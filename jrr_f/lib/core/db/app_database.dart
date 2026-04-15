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

@DriftDatabase(tables: [SavedServers])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'jrr');
  }
}
