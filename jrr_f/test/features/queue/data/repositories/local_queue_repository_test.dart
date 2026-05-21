import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/queue/data/repositories/local_queue_repository_impl.dart';
import 'package:talker/talker.dart';

void main() {
  late AppDatabase db;
  late LocalQueueRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = LocalQueueRepositoryImpl(db: db, talker: Talker());
  });

  tearDown(() async {
    await db.close();
  });

  const t1 = Track(fileKey: 1, name: 'one');
  const t2 = Track(fileKey: 2, name: 'two');
  const t3 = Track(fileKey: 3, name: 'three');

  group('getTracks / setTracks', () {
    test('getTracks returns empty for unknown zone', () async {
      final result = await repo.getTracks('local');
      expect(
        result.getOrElse((_) => Tracks.fromList(const [t1])).isEmpty,
        isTrue,
      );
    });

    test('setTracks then getTracks round-trips the queue', () async {
      await repo.setTracks('local', Tracks.fromList(const [t1, t2, t3]));
      final result = await repo.getTracks('local');
      final tracks = result.getOrElse((_) => Tracks.empty);
      expect(tracks.length, 3);
      expect(tracks.tracks.map((t) => t.fileKey), [1, 2, 3]);
    });

    test('setTracks is per-zone and replaces existing rows', () async {
      await repo.setTracks('zoneA', Tracks.fromList(const [t1, t2]));
      await repo.setTracks('zoneB', Tracks.fromList(const [t3]));
      await repo.setTracks('zoneA', Tracks.fromList(const [t3]));

      final a = (await repo.getTracks('zoneA')).getOrElse((_) => Tracks.empty);
      final b = (await repo.getTracks('zoneB')).getOrElse((_) => Tracks.empty);
      expect(a.tracks.map((t) => t.fileKey), [3]);
      expect(b.tracks.map((t) => t.fileKey), [3]);
    });
  });

  group('getCurrentIndex / setCurrentIndex', () {
    test('getCurrentIndex defaults to -1 for unknown zone', () async {
      final result = await repo.getCurrentIndex('zoneX');
      expect(result.getOrElse((_) => 99), -1);
    });

    test('setCurrentIndex persists and overwrites prior value', () async {
      await repo.setCurrentIndex('zoneA', 4);
      expect((await repo.getCurrentIndex('zoneA')).getOrElse((_) => -1), 4);
      await repo.setCurrentIndex('zoneA', 9);
      expect((await repo.getCurrentIndex('zoneA')).getOrElse((_) => -1), 9);
    });

    test('setCurrentIndex is scoped per zone', () async {
      await repo.setCurrentIndex('zoneA', 1);
      await repo.setCurrentIndex('zoneB', 2);
      expect((await repo.getCurrentIndex('zoneA')).getOrElse((_) => -1), 1);
      expect((await repo.getCurrentIndex('zoneB')).getOrElse((_) => -1), 2);
    });
  });

  group('error mapping', () {
    test('getTracks returns Left when stored trackJson is corrupt', () async {
      // Insert a row with invalid JSON to force jsonDecode to throw.
      await db
          .into(db.localQueueTracks)
          .insert(
            LocalQueueTracksCompanion.insert(
              zoneId: const Value('local'),
              fileKey: 1,
              trackJson: 'not-json',
              position: 0,
            ),
          );
      final result = await repo.getTracks('local');
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<UnknownException>()),
        (_) => fail('expected left'),
      );
    });
  });
}
