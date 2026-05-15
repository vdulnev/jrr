import '../../../library/data/models/track.dart';
import '../models/download_job.dart';
import '../models/download_state.dart';
import '../models/downloaded_track.dart';

abstract class DownloadsRepository {
  /// Enqueues a single track for download.
  Future<void> enqueue(Track track);

  /// Enqueues multiple tracks for download.
  Future<void> enqueueAll(List<Track> tracks);

  /// Cancels a queued or running download.
  Future<void> cancel(int fileKey);

  /// Cancels multiple queued or running downloads.
  Future<void> cancelAll(List<int> fileKeys);

  /// Deletes a downloaded track and its associated file.
  Future<void> delete(int fileKey);

  /// Deletes multiple downloaded tracks and their associated files.
  Future<void> deleteAll(List<int> fileKeys);

  /// Cancels all jobs and deletes all downloaded files.
  Future<void> clearAll();

  /// Removes a job row from history (used to clear failed/cancelled entries).
  Future<void> removeJob(int fileKey);

  /// Gets all current download jobs (queued, running, failed, cancelled).
  Future<List<DownloadJob>> getJobs();

  /// Returns the successfully downloaded tracks.
  Future<List<DownloadedTrack>> getDownloadedTracks();

  /// Returns the local file path for a downloaded track synchronously from cache.
  String? localPathFor(int fileKey);

  /// Returns the cached local artwork path for a downloaded track, or `null`
  /// if not downloaded or has no artwork.
  String? artworkPathFor(int fileKey);

  /// Returns the local file path for a downloaded track, or null if not downloaded.

  Future<String?> getLocalPath(int fileKey);

  /// Returns the current download state for a track.
  Future<DownloadState> getDownloadState(int fileKey);

  /// Watches all download jobs for changes.
  Stream<List<DownloadJob>> watchJobs();

  /// Watches all downloaded tracks for changes.
  Stream<List<DownloadedTrack>> watchDownloadedTracks();

  /// Internal: Moves a completed job to the downloaded tracks table.
  /// Used by DownloadService.
  Future<void> markCompleted({
    required int fileKey,
    required String localPath,
    String? artworkPath,
    required int fileSizeBytes,
  });

  /// Internal: Updates the progress or state of a job.
  /// Used by DownloadService.
  Future<void> updateJob({
    required int fileKey,
    DownloadState? state,
    int? bytesDone,
    int? bytesTotal,
    String? error,
    DateTime? startedAt,
  });

  /// Internal: Gets the next queued job to process.
  Future<DownloadJob?> getNextQueuedJob();
}
