import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../../offline/data/models/download_state.dart';
import '../../offline/providers/download_jobs_provider.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/album.dart';
import '../data/models/tracks.dart';
import 'album_row_tile_view_state.dart';
import 'library_providers.dart';

part 'album_row_tile_view_model.g.dart';

@riverpod
class AlbumRowTileViewModel extends _$AlbumRowTileViewModel {
  @override
  AlbumRowTileViewState build(Album album) {
    final isOffline = ref.watch(isOfflineActiveProvider);
    final downloadedTracks = ref.watch(downloadedTracksProvider).value ?? [];
    final downloadJobs = ref.watch(downloadJobsProvider).value ?? [];

    final downloadedInAlbum = downloadedTracks
        .where((t) => t.albumGroupId == album.albumGroupId)
        .toList();
    final jobsInAlbum = downloadJobs
        .where((j) => j.track.albumGroupId == album.albumGroupId)
        .toList();
    final activeJobs = jobsInAlbum.where(
      (j) =>
          j.state == DownloadState.queued || j.state == DownloadState.running,
    );
    final failedJobs = jobsInAlbum.where(
      (j) => j.state == DownloadState.failed,
    );

    return AlbumRowTileViewState(
      isOffline: isOffline,
      showDownload: !isOffline && activeJobs.isEmpty,
      showCancel: !isOffline && activeJobs.isNotEmpty,
      showDelete: downloadedInAlbum.isNotEmpty,
      showRetry: !isOffline && failedJobs.isNotEmpty && activeJobs.isEmpty,
      hidden: isOffline && downloadedInAlbum.isEmpty,
    );
  }

  Future<List<int>> _albumTrackKeys(Album album) async {
    final isOffline = ref.read(isOfflineActiveProvider);
    final tracks = isOffline
        ? await ref.read(
            downloadedAlbumTracksProvider(album.albumGroupId).future,
          )
        : await ref.read(albumTracksProvider(album).future);
    return tracks.tracks.map((t) => t.fileKey).toList();
  }

  Future<void> playAlbum(Album album) async {
    final tracks = await _resolveTracks(album);
    await ref.read(playerProvider.notifier).playNow(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> playAlbumNext(Album album) async {
    final tracks = await _resolveTracks(album);
    await ref.read(playerProvider.notifier).playNext(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> addAlbumToQueue(Album album) async {
    final tracks = await _resolveTracks(album);
    await ref.read(playerProvider.notifier).addToQueue(tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> downloadAlbum(Album album) async {
    final tracks = await _resolveTracks(album);
    ref.read(downloadsRepositoryProvider).enqueueAll(tracks.tracks);
    await ref.read(playerProvider.notifier).refresh();
  }

  Future<void> cancelAlbumDownload(Album album) async {
    final keys = await _albumTrackKeys(album);
    await ref.read(downloadsRepositoryProvider).cancelAll(keys);
  }

  /// Returns the number of tracks that would be deleted; the widget uses
  /// this to confirm before calling [deleteAlbumDownload].
  Future<int> downloadedTrackCount(Album album) async {
    final keys = await _albumTrackKeys(album);
    return keys.length;
  }

  Future<void> deleteAlbumDownload(Album album) async {
    final keys = await _albumTrackKeys(album);
    await ref.read(downloadsRepositoryProvider).deleteAll(keys);
  }

  Future<Tracks> _resolveTracks(Album album) async {
    final isOffline = ref.read(isOfflineActiveProvider);
    return isOffline
        ? await ref.read(
            downloadedAlbumTracksProvider(album.albumGroupId).future,
          )
        : await ref.read(albumTracksProvider(album).future);
  }
}
