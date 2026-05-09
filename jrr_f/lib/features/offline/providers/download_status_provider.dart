import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/models/download_state.dart';
import 'download_jobs_provider.dart';
import 'downloaded_tracks_provider.dart';

part 'download_status_provider.g.dart';

@riverpod
DownloadState downloadStatus(Ref ref, int fileKey) {
  final downloaded = ref.watch(downloadedTracksProvider).value ?? [];
  if (downloaded.any((t) => t.fileKey == fileKey)) {
    return DownloadState.downloaded;
  }

  final jobs = ref.watch(downloadJobsProvider).value ?? [];
  final job = jobs.where((j) => j.fileKey == fileKey).firstOrNull;

  return job?.state ?? DownloadState.notDownloaded;
}

@riverpod
double downloadProgress(Ref ref, int fileKey) {
  final jobs = ref.watch(downloadJobsProvider).value ?? [];
  final job = jobs.where((j) => j.fileKey == fileKey).firstOrNull;

  if (job == null || job.bytesTotal <= 0) return 0;
  return job.bytesDone / job.bytesTotal;
}

@riverpod
DownloadState albumDownloadStatus(Ref ref, String albumGroupId) {
  final jobs = ref.watch(downloadJobsProvider).value ?? [];
  final albumJobs = jobs.where((j) => j.track.albumGroupId == albumGroupId);

  if (albumJobs.isEmpty) return DownloadState.notDownloaded;

  if (albumJobs.any((j) => j.state == DownloadState.running)) {
    return DownloadState.running;
  }

  if (albumJobs.any((j) => j.state == DownloadState.queued)) {
    return DownloadState.queued;
  }

  if (albumJobs.any((j) => j.state == DownloadState.failed)) {
    return DownloadState.failed;
  }

  return DownloadState.notDownloaded;
}

@riverpod
double albumDownloadProgress(Ref ref, String albumGroupId) {
  final jobs = ref.watch(downloadJobsProvider).value ?? [];
  final albumJobs = jobs
      .where((j) => j.track.albumGroupId == albumGroupId)
      .toList();

  if (albumJobs.isEmpty) return 0;

  int totalBytesDone = 0;
  int totalBytesTotal = 0;

  for (final job in albumJobs) {
    if (job.bytesTotal > 0) {
      totalBytesDone += job.bytesDone;
      totalBytesTotal += job.bytesTotal;
    }
  }

  if (totalBytesTotal <= 0) {
    // If we don't know sizes, just use track count progress
    final completedTracks = albumJobs
        .where((j) => j.state == DownloadState.downloaded)
        .length;
    return completedTracks / albumJobs.length;
  }

  // If some tracks have unknown size, we might want to blend them,
  // but let's keep it simple for now and use known sizes if available.
  return totalBytesDone / totalBytesTotal;
}
