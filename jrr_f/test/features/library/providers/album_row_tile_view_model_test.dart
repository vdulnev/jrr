import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/providers/album_row_tile_view_model.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/download_jobs_provider.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

const _album = Album(
  name: 'Album',
  albumArtist: 'X',
  folderPath: '/a/Album/',
  parentFolderPath: '/a/',
  albumGroupId: 'album|/a/',
);

DownloadedTrack downloaded(int key) => DownloadedTrack(
  fileKey: key,
  track: Track(fileKey: key),
  localPath: '/x',
  albumGroupId: 'album|/a/',
  albumArtist: 'X',
  album: 'Album',
  dateReadable: '',
  discNumber: 1,
  totalDiscs: 1,
  trackNumber: key,
  fileSizeBytes: 1,
  downloadedAt: DateTime.utc(2026),
);

DownloadJob job(int key, DownloadState state) => DownloadJob(
  fileKey: key,
  // album='Album', filePath produces folderPath='/A/' → albumGroupId
  // matches _album.albumGroupId ('album|/A/').
  track: Track(fileKey: key, album: 'Album', filePath: '/a/$key.flac'),
  state: state,
  enqueuedAt: DateTime.utc(2026),
);

void main() {
  late MockDownloadsRepo repo;
  late StreamController<List<DownloadedTrack>> downloadedCtrl;
  late StreamController<List<DownloadJob>> jobsCtrl;
  late ProviderContainer container;

  Future<void> open({bool isOffline = false}) async {
    repo = MockDownloadsRepo();
    downloadedCtrl = StreamController<List<DownloadedTrack>>();
    jobsCtrl = StreamController<List<DownloadJob>>();
    when(
      () => repo.watchDownloadedTracks(),
    ).thenAnswer((_) => downloadedCtrl.stream);
    when(() => repo.watchJobs()).thenAnswer((_) => jobsCtrl.stream);
    container = ProviderContainer(
      overrides: [
        downloadsRepositoryProvider.overrideWithValue(repo),
        isOfflineActiveProvider.overrideWith((ref) => isOffline),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    addTearDown(container.listen(downloadJobsProvider, (_, _) {}).close);
    addTearDown(() async {
      await downloadedCtrl.close();
      await jobsCtrl.close();
    });
  }

  /// Pump until [predicate] is satisfied, or fail after 200 ms.
  Future<void> pumpUntil(bool Function() predicate) async {
    final deadline = DateTime.now().add(const Duration(milliseconds: 200));
    while (!predicate()) {
      if (DateTime.now().isAfter(deadline)) return;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('online + nothing downloaded → showDownload only', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add(const []);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.showDownload, isTrue);
    expect(s.showCancel, isFalse);
    expect(s.showDelete, isFalse);
    expect(s.hidden, isFalse);
  });

  test('online + active job → showCancel', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add([job(1, DownloadState.queued)]);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.showCancel, isTrue);
    expect(s.showDownload, isFalse);
  });

  test('online + downloaded track → showDelete', () async {
    await open();
    downloadedCtrl.add([downloaded(1)]);
    jobsCtrl.add(const []);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.showDelete, isTrue);
  });

  test('online + failed (no active) → showRetry', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add([job(1, DownloadState.failed)]);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.showRetry, isTrue);
  });

  test('offline + nothing downloaded → hidden', () async {
    await open(isOffline: true);
    downloadedCtrl.add(const []);
    jobsCtrl.add(const []);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.hidden, isTrue);
    expect(s.showDownload, isFalse);
  });

  test('offline + downloaded track → not hidden', () async {
    await open(isOffline: true);
    downloadedCtrl.add([downloaded(1)]);
    jobsCtrl.add(const []);
    await pumpUntil(
      () =>
          container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue,
    );
    final s = container.read(albumRowTileViewModelProvider(_album));
    expect(s.hidden, isFalse);
    expect(s.showDelete, isTrue);
  });
}
