import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/download_jobs_provider.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/shared/widgets/tracks_popup_menu_view_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

DownloadedTrack dt(int key) => DownloadedTrack(
  fileKey: key,
  track: Track(fileKey: key),
  localPath: '/x',
  albumGroupId: 'g',
  albumArtist: 'a',
  album: 'A',
  dateReadable: '',
  discNumber: 1,
  totalDiscs: 1,
  trackNumber: 1,
  fileSizeBytes: 1,
  downloadedAt: DateTime.utc(2026),
);

DownloadJob job(int key, DownloadState state) => DownloadJob(
  fileKey: key,
  track: Track(fileKey: key),
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
        talkerProvider.overrideWithValue(Talker()),
      ],
    );
    addTearDown(container.dispose);
    // Keep the StreamProviders alive.
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    addTearDown(container.listen(downloadJobsProvider, (_, _) {}).close);
    addTearDown(() async {
      await downloadedCtrl.close();
      await jobsCtrl.close();
    });
  }

  final tracks = Tracks.fromList(const [Track(fileKey: 1), Track(fileKey: 2)]);

  Future<void> pump() => Future<void>.delayed(Duration.zero);

  test('online + nothing downloaded → showDownload only', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add(const []);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.isOffline, isFalse);
    expect(s.hidden, isFalse);
    expect(s.showDownload, isTrue);
    expect(s.showCancel, isFalse);
    expect(s.showDelete, isFalse);
    expect(s.showRetry, isFalse);
  });

  test('online + active queued job → showCancel, no download', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add([job(1, DownloadState.queued)]);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.showDownload, isFalse);
    expect(s.showCancel, isTrue);
    expect(s.showRetry, isFalse);
  });

  test(
    'online + one downloaded + one missing → showDownload + showDelete',
    () async {
      await open();
      downloadedCtrl.add([dt(1)]);
      jobsCtrl.add(const []);
      await pump();
      final s = container.read(tracksPopupMenuViewModelProvider(tracks));
      expect(s.showDownload, isTrue);
      expect(s.showDelete, isTrue);
      expect(s.showCancel, isFalse);
    },
  );

  test('online + all downloaded → showDelete only', () async {
    await open();
    downloadedCtrl.add([dt(1), dt(2)]);
    jobsCtrl.add(const []);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.showDownload, isFalse);
    expect(s.showDelete, isTrue);
  });

  test('online + failed (no active) → showRetry', () async {
    await open();
    downloadedCtrl.add(const []);
    jobsCtrl.add([job(1, DownloadState.failed)]);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.showRetry, isTrue);
    expect(s.showDownload, isTrue);
  });

  test('offline + nothing downloaded → hidden', () async {
    await open(isOffline: true);
    downloadedCtrl.add(const []);
    jobsCtrl.add(const []);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.isOffline, isTrue);
    expect(s.hidden, isTrue);
    expect(s.showDownload, isFalse);
    expect(s.showCancel, isFalse);
    expect(s.showRetry, isFalse);
  });

  test('offline + some downloaded → not hidden, only delete', () async {
    await open(isOffline: true);
    downloadedCtrl.add([dt(1)]);
    jobsCtrl.add(const []);
    await pump();
    final s = container.read(tracksPopupMenuViewModelProvider(tracks));
    expect(s.hidden, isFalse);
    expect(s.showDelete, isTrue);
    expect(s.showDownload, isFalse);
  });
}
