import 'package:drift/drift.dart' show InsertMode, Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('schemaVersion is 7', () {
    expect(db.schemaVersion, 7);
  });

  group('SavedServers DAO', () {
    test('insert and select round-trip with defaults', () async {
      await db
          .into(db.savedServers)
          .insert(
            SavedServersCompanion.insert(
              host: 'srv',
              username: 'u',
              passwordKey: 'k',
            ),
          );
      final rows = await db.select(db.savedServers).get();
      expect(rows, hasLength(1));
      expect(rows.single.host, 'srv');
      expect(rows.single.port, 52199);
      expect(rows.single.useSsl, isFalse);
      expect(rows.single.sslPort, 52200);
      expect(rows.single.authToken, isNull);
    });
  });

  group('Favorites DAO', () {
    test('insertOrReplace by primary key works', () async {
      await db
          .into(db.favorites)
          .insert(
            FavoritesCompanion.insert(
              type: 'browse_item',
              identifier: '1',
              displayName: 'A',
              addedAt: 100,
            ),
          );
      await db
          .into(db.favorites)
          .insert(
            FavoritesCompanion.insert(
              type: 'browse_item',
              identifier: '2',
              displayName: 'B',
              addedAt: 200,
            ),
          );
      final rows = await db.select(db.favorites).get();
      expect(rows, hasLength(2));
    });
  });

  group('LocalQueueTracks DAO', () {
    test('zoneId defaults to "local"', () async {
      await db
          .into(db.localQueueTracks)
          .insert(
            LocalQueueTracksCompanion.insert(
              fileKey: 1,
              trackJson: '{}',
              position: 0,
            ),
          );
      final row = await db.select(db.localQueueTracks).getSingle();
      expect(row.zoneId, 'local');
      expect(row.fileKey, 1);
    });
  });

  group('LocalQueueState DAO', () {
    test('uses zoneId as the primary key (insertOnConflictUpdate)', () async {
      await db
          .into(db.localQueueState)
          .insertOnConflictUpdate(
            LocalQueueStateCompanion.insert(
              zoneId: 'local',
              currentIndex: const Value(3),
            ),
          );
      await db
          .into(db.localQueueState)
          .insertOnConflictUpdate(
            LocalQueueStateCompanion.insert(
              zoneId: 'local',
              currentIndex: const Value(7),
            ),
          );
      final rows = await db.select(db.localQueueState).get();
      expect(rows, hasLength(1));
      expect(rows.single.currentIndex, 7);
    });
  });

  group('DownloadedTracks DAO', () {
    test('unique constraint on fileKey rejects duplicates', () async {
      Future<void> insert(int key) => db
          .into(db.downloadedTracks)
          .insert(
            DownloadedTracksCompanion.insert(
              fileKey: key,
              trackJson: '{}',
              localPath: '/p',
              albumGroupId: 'g',
              albumArtist: 'a',
              album: 'al',
              dateReadable: '',
              discNumber: 1,
              totalDiscs: 1,
              trackNumber: 1,
              fileSizeBytes: 1,
              downloadedAt: 0,
            ),
          );

      await insert(1);
      expect(insert(1), throwsA(isA<Exception>()));
    });
  });

  group('DownloadJobs DAO', () {
    test('unique fileKey + insertOrReplace updates the existing row', () async {
      Future<void> insert(int key, String state) => db
          .into(db.downloadJobs)
          .insert(
            DownloadJobsCompanion.insert(
              fileKey: key,
              trackJson: '{}',
              state: state,
              bytesDone: 0,
              bytesTotal: -1,
              enqueuedAt: 0,
            ),
            mode: InsertMode.insertOrReplace,
          );

      await insert(1, 'queued');
      await insert(1, 'running');
      final rows = await db.select(db.downloadJobs).get();
      expect(rows, hasLength(1));
      expect(rows.single.state, 'running');
    });
  });
}
