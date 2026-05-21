import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/providers/server_manager_view_model.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/download_jobs_provider.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

DownloadedTrack dt(int key, {int size = 1000}) => DownloadedTrack(
  fileKey: key,
  track: Track(fileKey: key),
  localPath: '/p',
  albumGroupId: 'g',
  albumArtist: 'A',
  album: 'Al',
  dateReadable: '',
  discNumber: 1,
  totalDiscs: 1,
  trackNumber: 1,
  fileSizeBytes: size,
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
  late StreamController<List<DownloadedTrack>> dlCtrl;
  late StreamController<List<DownloadJob>> jobsCtrl;
  late ProviderContainer container;

  Future<void> open({
    SessionState session = const SessionState.unauthenticated(),
    List<DownloadedTrack> downloaded = const [],
    List<DownloadJob> jobs = const [],
  }) async {
    repo = MockDownloadsRepo();
    dlCtrl = StreamController<List<DownloadedTrack>>();
    jobsCtrl = StreamController<List<DownloadJob>>();
    when(() => repo.watchDownloadedTracks()).thenAnswer((_) => dlCtrl.stream);
    when(() => repo.watchJobs()).thenAnswer((_) => jobsCtrl.stream);
    when(() => repo.clearAll()).thenAnswer((_) async {});
    when(() => repo.enqueue(any())).thenAnswer((_) async {});
    when(() => repo.removeJob(any())).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        downloadsRepositoryProvider.overrideWithValue(repo),
        sessionProvider.overrideWith(() => _StaticSession(session)),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    addTearDown(container.listen(downloadJobsProvider, (_, _) {}).close);
    addTearDown(
      container.listen(serverManagerViewModelProvider, (_, _) {}).close,
    );
    addTearDown(() async {
      await dlCtrl.close();
      await jobsCtrl.close();
    });

    dlCtrl.add(downloaded);
    jobsCtrl.add(jobs);
    for (var i = 0; i < 40; i++) {
      if (container.read(downloadedTracksProvider).hasValue &&
          container.read(downloadJobsProvider).hasValue) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  setUpAll(() {
    registerFallbackValue(const Track(fileKey: 0));
  });

  test(
    'unauthenticated session yields null serverInfo and zero stats',
    () async {
      await open();
      final state = container.read(serverManagerViewModelProvider);
      expect(state.serverInfo, isNull);
      expect(state.isAuthenticated, isFalse);
      expect(state.downloadedTracksCount, 0);
      expect(state.downloadedTotalBytes, 0);
      expect(state.failedJobs, isEmpty);
    },
  );

  test('authenticated session exposes the server info', () async {
    const info = ServerInfo(
      id: 'srv',
      name: 'Home',
      version: '32',
      platform: 'win',
      address: 'http://h:52199',
    );
    await open(session: const SessionState.authenticated(serverInfo: info));
    final state = container.read(serverManagerViewModelProvider);
    expect(state.serverInfo, info);
    expect(state.isAuthenticated, isTrue);
    expect(state.isSyntheticOffline, isFalse);
  });

  test('isSyntheticOffline is true for the offline placeholder', () async {
    await open(
      session: const SessionState.authenticated(serverInfo: ServerInfo.offline),
    );
    final state = container.read(serverManagerViewModelProvider);
    expect(state.isSyntheticOffline, isTrue);
  });

  test('downloaded count and bytes reflect the underlying stream', () async {
    await open(downloaded: [dt(1, size: 100), dt(2, size: 200)]);
    final state = container.read(serverManagerViewModelProvider);
    expect(state.downloadedTracksCount, 2);
    expect(state.downloadedTotalBytes, 300);
  });

  test('failedJobs lists only DownloadState.failed jobs', () async {
    await open(
      jobs: [
        job(1, DownloadState.failed),
        job(2, DownloadState.queued),
        job(3, DownloadState.failed),
      ],
    );
    final state = container.read(serverManagerViewModelProvider);
    expect(state.failedJobs.map((j) => j.fileKey), [1, 3]);
  });

  test('clearAllDownloads delegates to the repository', () async {
    await open();
    await container
        .read(serverManagerViewModelProvider.notifier)
        .clearAllDownloads();
    verify(() => repo.clearAll()).called(1);
  });

  test('retryDownload enqueues the given track', () async {
    await open();
    container
        .read(serverManagerViewModelProvider.notifier)
        .retryDownload(const Track(fileKey: 99));
    verify(() => repo.enqueue(any(that: isA<Track>()))).called(1);
  });

  test('removeFailedJob delegates to the repository', () async {
    await open();
    await container
        .read(serverManagerViewModelProvider.notifier)
        .removeFailedJob(7);
    verify(() => repo.removeJob(7)).called(1);
  });
}

class _StaticSession extends Session {
  _StaticSession(this._state);
  final SessionState _state;
  @override
  SessionState build() => _state;
}
