import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:talker/talker.dart';

class MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  late AppDatabase db;
  late DownloadsRepositoryImpl repo;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = DownloadsRepositoryImpl(db: db, talker: Talker());
    tempDir = await Directory.systemTemp.createTemp('dl-more-');
    final mockPath = MockPathProvider();
    PathProviderPlatform.instance = mockPath;
    when(
      () => mockPath.getApplicationDocumentsPath(),
    ).thenAnswer((_) async => tempDir.path);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  const t1 = Track(fileKey: 1, name: 'one', album: 'Album', albumArtist: 'X');
  const t2 = Track(fileKey: 2, name: 'two', album: 'Album', albumArtist: 'X');

  group('enqueueAll', () {
    test('inserts a queued job per track via a single batch', () async {
      await repo.enqueueAll(const [t1, t2]);
      final jobs = await repo.getJobs();
      expect(jobs, hasLength(2));
      expect(jobs.map((j) => j.fileKey).toSet(), {1, 2});
      expect(jobs.every((j) => j.state == DownloadState.queued), isTrue);
    });
  });

  group('cancel / cancelAll', () {
    test('cancel flips state to cancelled', () async {
      await repo.enqueue(t1);
      await repo.cancel(1);
      final jobs = await repo.getJobs();
      expect(jobs.single.state, DownloadState.cancelled);
    });

    test('cancelAll flips multiple jobs', () async {
      await repo.enqueueAll(const [t1, t2]);
      await repo.cancelAll([1, 2]);
      final jobs = await repo.getJobs();
      expect(jobs.every((j) => j.state == DownloadState.cancelled), isTrue);
    });
  });

  group('removeJob', () {
    test('drops the row entirely', () async {
      await repo.enqueue(t1);
      expect((await repo.getJobs()).single.fileKey, 1);
      await repo.removeJob(1);
      expect(await repo.getJobs(), isEmpty);
    });
  });

  group('updateJob', () {
    test('applies only the fields that were supplied', () async {
      await repo.enqueue(t1);
      final started = DateTime.now();
      await repo.updateJob(
        fileKey: 1,
        state: DownloadState.running,
        bytesDone: 512,
        bytesTotal: 1024,
        startedAt: started,
      );
      final job = (await repo.getJobs()).single;
      expect(job.state, DownloadState.running);
      expect(job.bytesDone, 512);
      expect(job.bytesTotal, 1024);
      expect(job.startedAt, isNotNull);

      // Calling with only `error` keeps the other fields intact.
      await repo.updateJob(fileKey: 1, error: 'oops');
      final after = (await repo.getJobs()).single;
      expect(after.state, DownloadState.running);
      expect(after.error, 'oops');
      expect(after.bytesDone, 512);
    });
  });

  group('getNextQueuedJob', () {
    test('returns the oldest queued job, ignoring running/failed', () async {
      await repo.enqueue(t1);
      await Future<void>.delayed(const Duration(milliseconds: 2));
      await repo.enqueue(t2);
      await repo.updateJob(fileKey: 1, state: DownloadState.running);

      final next = await repo.getNextQueuedJob();
      expect(next?.fileKey, 2);
    });

    test('returns null when no queued jobs remain', () async {
      await repo.enqueue(t1);
      await repo.updateJob(fileKey: 1, state: DownloadState.failed);
      expect(await repo.getNextQueuedJob(), isNull);
    });
  });

  group('getDownloadState', () {
    test('returns notDownloaded when neither table has the fileKey', () async {
      expect(await repo.getDownloadState(99), DownloadState.notDownloaded);
    });

    test('returns the job state when only a job row exists', () async {
      await repo.enqueue(t1);
      expect(await repo.getDownloadState(1), DownloadState.queued);
      await repo.updateJob(fileKey: 1, state: DownloadState.failed);
      expect(await repo.getDownloadState(1), DownloadState.failed);
    });

    test('returns downloaded when the track is in downloadedTracks', () async {
      await repo.enqueue(t1);
      await repo.markCompleted(
        fileKey: 1,
        localPath: '/tmp/x.flac',
        fileSizeBytes: 10,
      );
      expect(await repo.getDownloadState(1), DownloadState.downloaded);
    });
  });

  group('getLocalPath / cache helpers', () {
    test(
      'getLocalPath returns the stored path for a downloaded fileKey',
      () async {
        await repo.enqueue(t1);
        await repo.markCompleted(
          fileKey: 1,
          localPath: '/x/y.flac',
          fileSizeBytes: 1,
        );
        expect(await repo.getLocalPath(1), '/x/y.flac');
        expect(await repo.getLocalPath(99), isNull);
      },
    );

    test(
      'localPathFor & artworkPathFor stay in sync via the watcher',
      () async {
        await repo.enqueue(t1);
        await repo.markCompleted(
          fileKey: 1,
          localPath: '/x/y.flac',
          artworkPath: '/x/art.jpg',
          fileSizeBytes: 1,
        );

        // The cache is populated reactively via watchDownloadedTracks; allow
        // the stream subscription to deliver the first emission.
        await _untilTrue(() => repo.localPathFor(1) == '/x/y.flac');
        expect(repo.localPathFor(1), '/x/y.flac');
        expect(repo.artworkPathFor(1), '/x/art.jpg');
      },
    );
  });

  group('watchJobs / watchDownloadedTracks', () {
    test('watchJobs emits when a new job is enqueued', () async {
      final stream = repo.watchJobs();
      final emissions = <int>[];
      final sub = stream.listen((jobs) => emissions.add(jobs.length));

      await repo.enqueue(t1);
      await _untilTrue(() => emissions.contains(1));
      await sub.cancel();
      expect(emissions, contains(1));
    });

    test(
      'watchDownloadedTracks emits when a track is marked complete',
      () async {
        final stream = repo.watchDownloadedTracks();
        final emissions = <int>[];
        final sub = stream.listen((rows) => emissions.add(rows.length));

        await repo.enqueue(t1);
        await repo.markCompleted(
          fileKey: 1,
          localPath: '/x.flac',
          fileSizeBytes: 1,
        );
        await _untilTrue(() => emissions.contains(1));
        await sub.cancel();
        expect(emissions, contains(1));
      },
    );
  });

  group('deleteAll — artwork cleanup', () {
    test('deletes shared artwork when the album empties', () async {
      final art = File('${tempDir.path}/cover.jpg')..writeAsStringSync('img');
      await repo.enqueue(t1);
      await repo.markCompleted(
        fileKey: 1,
        localPath: '${tempDir.path}/t1.flac',
        artworkPath: art.path,
        fileSizeBytes: 1,
      );
      await repo.enqueue(t2);
      await repo.markCompleted(
        fileKey: 2,
        localPath: '${tempDir.path}/t2.flac',
        artworkPath: art.path,
        fileSizeBytes: 1,
      );

      // Deleting only one track leaves the album's artwork on disk.
      await repo.deleteAll([1]);
      expect(await art.exists(), isTrue);

      // Deleting the last track in the album removes the artwork too.
      await repo.deleteAll([2]);
      expect(await art.exists(), isFalse);
    });

    test('is a no-op when none of the fileKeys are downloaded', () async {
      await repo.deleteAll([1, 2, 3]);
      expect(await repo.getDownloadedTracks(), isEmpty);
    });
  });

  group('clearAll', () {
    test(
      'cancels running jobs, drops both tables, and deletes the folder',
      () async {
        // Job in queued/running state.
        await repo.enqueue(t1);
        await repo.updateJob(fileKey: 1, state: DownloadState.running);
        // Downloaded track.
        await repo.enqueue(t2);
        await repo.markCompleted(
          fileKey: 2,
          localPath: '${tempDir.path}/t2.flac',
          fileSizeBytes: 1,
        );
        // Make the downloads folder so clearAll's recursive delete has work
        // to do.
        final downloads = Directory('${tempDir.path}/downloads')..createSync();
        File('${downloads.path}/junk.bin').writeAsStringSync('x');

        await repo.clearAll();

        expect(await repo.getJobs(), isEmpty);
        expect(await repo.getDownloadedTracks(), isEmpty);
        expect(await downloads.exists(), isFalse);
      },
    );
  });
}

/// Poll [predicate] every 5 ms until it returns true, or fail after [timeout].
Future<void> _untilTrue(
  bool Function() predicate, {
  Duration timeout = const Duration(seconds: 2),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (!predicate()) {
    if (DateTime.now().isAfter(deadline)) {
      fail('predicate never became true within $timeout');
    }
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}
