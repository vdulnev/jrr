import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/di/providers.dart';
import '../../features/library/data/models/tracks.dart';
import '../../features/offline/data/models/download_state.dart';
import '../../features/offline/providers/download_jobs_provider.dart';
import '../../features/offline/providers/downloaded_tracks_provider.dart';
import '../../features/player/providers/player_provider.dart';
import '../../features/zones/providers/active_zone_provider.dart';
import 'tracks_popup_menu_view_state.dart';

part 'tracks_popup_menu_view_model.g.dart';

@riverpod
class TracksPopupMenuViewModel extends _$TracksPopupMenuViewModel {
  @override
  TracksPopupMenuViewState build(Tracks tracks) {
    final isOffline = ref.watch(isOfflineActiveProvider);
    final downloaded = ref.watch(downloadedTracksProvider).value ?? [];
    final jobs = ref.watch(downloadJobsProvider).value ?? [];

    final keys = tracks.tracks.map((t) => t.fileKey).toSet();
    final downloadedKeys = downloaded
        .where((t) => keys.contains(t.fileKey))
        .map((t) => t.fileKey)
        .toSet();
    final jobsForTracks = jobs.where((j) => keys.contains(j.fileKey));
    final activeJobs = jobsForTracks.where(
      (j) =>
          j.state == DownloadState.queued || j.state == DownloadState.running,
    );
    final failedJobs = jobsForTracks.where(
      (j) => j.state == DownloadState.failed,
    );

    return TracksPopupMenuViewState(
      isOffline: isOffline,
      hidden: isOffline && downloadedKeys.isEmpty,
      showDownload:
          !isOffline &&
          downloadedKeys.length < tracks.length &&
          activeJobs.isEmpty,
      showCancel: !isOffline && activeJobs.isNotEmpty,
      showDelete: downloadedKeys.isNotEmpty,
      showRetry: !isOffline && failedJobs.isNotEmpty && activeJobs.isEmpty,
    );
  }

  Future<void> playNow(Tracks tracks) async {
    await ref.read(playerProvider.notifier).playNow(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> playNext(Tracks tracks) async {
    await ref.read(playerProvider.notifier).playNext(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> addToQueue(Tracks tracks) async {
    await ref.read(playerProvider.notifier).addToQueue(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> downloadTracks(Tracks tracks) async {
    ref.read(downloadsRepositoryProvider).enqueueAll(tracks.tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> cancelDownloads(Tracks tracks) async {
    final keys = tracks.tracks.map((t) => t.fileKey).toList();
    await ref.read(downloadsRepositoryProvider).cancelAll(keys);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> deleteDownloads(Tracks tracks) async {
    final keys = tracks.tracks.map((t) => t.fileKey).toList();
    await ref.read(downloadsRepositoryProvider).deleteAll(keys);
    await ref.read(playerProvider.notifier).refresh();
  }
}
