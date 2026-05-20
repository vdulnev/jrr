import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../../library/data/models/track.dart';
import '../../offline/data/models/download_state.dart';
import '../../offline/providers/download_jobs_provider.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import 'server_manager_view_state.dart';
import 'session_provider.dart';
import 'session_state.dart';

part 'server_manager_view_model.g.dart';

@riverpod
class ServerManagerViewModel extends _$ServerManagerViewModel {
  @override
  ServerManagerViewState build() {
    final session = ref.watch(sessionProvider);
    final tracks = ref.watch(downloadedTracksProvider).value ?? const [];
    final jobs = ref.watch(downloadJobsProvider).value ?? const [];
    final failed = jobs.where((j) => j.state == DownloadState.failed).toList();

    return ServerManagerViewState(
      serverInfo: switch (session) {
        Authenticated(:final serverInfo) => serverInfo,
        _ => null,
      },
      downloadedTracksCount: tracks.length,
      downloadedTotalBytes: tracks.fold<int>(
        0,
        (sum, t) => sum + t.fileSizeBytes,
      ),
      failedJobs: failed,
    );
  }

  Future<void> logout() => ref.read(sessionProvider.notifier).logout();

  Future<void> clearAllDownloads() =>
      ref.read(downloadsRepositoryProvider).clearAll();

  void retryDownload(Track track) =>
      ref.read(downloadsRepositoryProvider).enqueue(track);

  Future<void> removeFailedJob(int fileKey) =>
      ref.read(downloadsRepositoryProvider).removeJob(fileKey);
}
