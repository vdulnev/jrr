import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/download_jobs_provider.dart';
import 'package:jrr_f/features/offline/providers/download_status_provider.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

DownloadJob job(
  int key, {
  String albumGroupId = 'g',
  DownloadState state = DownloadState.queued,
  int bytesDone = 0,
  int bytesTotal = -1,
}) =>
    DownloadJob(
      fileKey: key,
      track: Track(fileKey: key, album: 'A'),
      state: state,
      bytesDone: bytesDone,
      bytesTotal: bytesTotal,
      enqueuedAt: DateTime.utc(2026),
    ).copyWith(
      track: Track(fileKey: key, album: 'A').copyWith(),
    );

DownloadedTrack dt(int key, {String albumGroupId = 'g'}) => DownloadedTrack(
  fileKey: key,
  track: Track(fileKey: key),
  localPath: '/x',
  albumGroupId: albumGroupId,
  albumArtist: 'a',
  album: 'A',
  dateReadable: '',
  discNumber: 1,
  totalDiscs: 1,
  trackNumber: 1,
  fileSizeBytes: 1,
  downloadedAt: DateTime.utc(2026),
);

void main() {
  late MockDownloadsRepo repo;
  late StreamController<List<DownloadJob>> jobsCtrl;
  late StreamController<List<DownloadedTrack>> downloadedCtrl;
  late ProviderContainer container;

  setUp(() {
    repo = MockDownloadsRepo();
    jobsCtrl = StreamController<List<DownloadJob>>();
    downloadedCtrl = StreamController<List<DownloadedTrack>>();
    when(() => repo.watchJobs()).thenAnswer((_) => jobsCtrl.stream);
    when(
      () => repo.watchDownloadedTracks(),
    ).thenAnswer((_) => downloadedCtrl.stream);

    container = ProviderContainer(
      overrides: [downloadsRepositoryProvider.overrideWithValue(repo)],
    );
    // Subscribe to keep the underlying StreamProvider subscriptions alive
    // before any value is pushed onto the controllers.
    addTearDown(container.listen(downloadJobsProvider, (_, _) {}).close);
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    addTearDown(() async {
      await jobsCtrl.close();
      await downloadedCtrl.close();
      container.dispose();
    });
  });

  group('downloadStatus', () {
    test('returns notDownloaded when no rows match', () {
      expect(
        container.read(downloadStatusProvider(99)),
        DownloadState.notDownloaded,
      );
    });

    test(
      'returns downloaded when the fileKey is in downloadedTracks',
      () async {
        downloadedCtrl.add([dt(7)]);
        await Future<void>.delayed(Duration.zero);
        expect(
          container.read(downloadStatusProvider(7)),
          DownloadState.downloaded,
        );
      },
    );

    test('falls back to the job state when only a job exists', () async {
      jobsCtrl.add([job(7, state: DownloadState.running)]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(downloadStatusProvider(7)), DownloadState.running);
    });
  });

  group('downloadProgress', () {
    test('returns 0 when no job exists', () {
      expect(container.read(downloadProgressProvider(99)), 0);
    });

    test('returns 0 when bytesTotal is non-positive', () async {
      jobsCtrl.add([job(7, bytesDone: 5, bytesTotal: 0)]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(downloadProgressProvider(7)), 0);
    });

    test('computes bytesDone / bytesTotal', () async {
      jobsCtrl.add([job(7, bytesDone: 25, bytesTotal: 100)]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(downloadProgressProvider(7)), 0.25);
    });
  });

  group('albumDownloadStatus', () {
    DownloadJob albumJob(int key, DownloadState s) {
      final track = Track(fileKey: key, album: 'Album').copyWith();
      return DownloadJob(
        fileKey: key,
        track: track,
        state: s,
        enqueuedAt: DateTime.utc(2026),
      );
    }

    setUp(() {
      // Stage an album by setting track.albumGroupId via copyWith chain —
      // albumGroupId is a getter; here we'll rely on Track defaults so that
      // job(key).track.albumGroupId is the same value `|`.
    });

    test('returns notDownloaded when no jobs touch the album', () async {
      jobsCtrl.add(const []);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(albumDownloadStatusProvider('something|')),
        DownloadState.notDownloaded,
      );
    });

    test('prefers running, then queued, then failed', () async {
      // Track.albumGroupId for a track with empty album/folderPath collapses
      // to '|' — use that as the lookup key.
      const groupId = 'album|';
      jobsCtrl.add([
        albumJob(1, DownloadState.failed),
        albumJob(2, DownloadState.queued),
        albumJob(3, DownloadState.running),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(albumDownloadStatusProvider(groupId)),
        DownloadState.running,
      );

      jobsCtrl.add([
        albumJob(1, DownloadState.failed),
        albumJob(2, DownloadState.queued),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(albumDownloadStatusProvider(groupId)),
        DownloadState.queued,
      );

      jobsCtrl.add([albumJob(1, DownloadState.failed)]);
      await Future<void>.delayed(Duration.zero);
      expect(
        container.read(albumDownloadStatusProvider(groupId)),
        DownloadState.failed,
      );
    });
  });

  group('albumDownloadProgress', () {
    DownloadJob albumJob(
      int key,
      DownloadState state, {
      int bytesDone = 0,
      int bytesTotal = -1,
    }) => DownloadJob(
      fileKey: key,
      track: Track(fileKey: key, album: 'Album'),
      state: state,
      bytesDone: bytesDone,
      bytesTotal: bytesTotal,
      enqueuedAt: DateTime.utc(2026),
    );

    test('returns 0 when no jobs match', () {
      expect(container.read(albumDownloadProgressProvider('g')), 0);
    });

    test('uses byte ratio when byte totals are known', () async {
      const groupId = 'album|';
      jobsCtrl.add([
        albumJob(1, DownloadState.running, bytesDone: 100, bytesTotal: 200),
        albumJob(2, DownloadState.queued, bytesDone: 0, bytesTotal: 200),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(albumDownloadProgressProvider(groupId)), 100 / 400);
    });

    test('falls back to track-count progress when sizes are unknown', () async {
      const groupId = 'album|';
      jobsCtrl.add([
        albumJob(1, DownloadState.downloaded),
        albumJob(2, DownloadState.queued),
      ]);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(albumDownloadProgressProvider(groupId)), 0.5);
    });
  });
}
