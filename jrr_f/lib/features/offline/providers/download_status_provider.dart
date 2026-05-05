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
