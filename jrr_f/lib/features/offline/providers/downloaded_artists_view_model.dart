import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../../library/data/models/tracks.dart';
import '../../player/providers/player_provider.dart';
import 'downloaded_artists_view_state.dart';
import 'downloaded_tracks_provider.dart';

part 'downloaded_artists_view_model.g.dart';

@riverpod
class DownloadedArtistsViewModel extends _$DownloadedArtistsViewModel {
  @override
  DownloadedArtistsViewState build() {
    final async = ref.watch(downloadedArtistsProvider);
    return DownloadedArtistsViewState(artists: async.value, error: async.error);
  }

  void refresh() => ref.invalidate(downloadedArtistsProvider);

  Future<Tracks?> _tracksForArtist(String artist) async {
    final downloaded = await ref.read(downloadedTracksProvider.future);
    final artistTracks = downloaded
        .where(
          (t) =>
              (t.albumArtist.isEmpty ? 'Unknown Artist' : t.albumArtist) ==
              artist,
        )
        .map((t) => t.track)
        .toList();
    if (artistTracks.isEmpty) return null;

    artistTracks.sort((a, b) {
      final albumCompare = a.album.compareTo(b.album);
      if (albumCompare != 0) return albumCompare;
      final discCompare = a.discNumber.compareTo(b.discNumber);
      if (discCompare != 0) return discCompare;
      return a.trackNumber.compareTo(b.trackNumber);
    });
    return Tracks(tracks: artistTracks);
  }

  Future<void> playArtist(String artist) async {
    final tracks = await _tracksForArtist(artist);
    if (tracks == null) return;
    await ref.read(playerProvider.notifier).playNow(tracks);
  }

  Future<void> playNextArtist(String artist) async {
    final tracks = await _tracksForArtist(artist);
    if (tracks == null) return;
    await ref.read(playerProvider.notifier).playNext(tracks);
  }

  Future<void> addArtistToQueue(String artist) async {
    final tracks = await _tracksForArtist(artist);
    if (tracks == null) return;
    await ref.read(playerProvider.notifier).addToQueue(tracks);
  }

  /// Returns the number of tracks queued for deletion (used by the caller
  /// to confirm with the user before [deleteArtist] is invoked).
  Future<int> trackCountForArtist(String artist) async {
    final tracks = await _tracksForArtist(artist);
    return tracks?.tracks.length ?? 0;
  }

  Future<void> deleteArtist(String artist) async {
    final tracks = await _tracksForArtist(artist);
    if (tracks == null) return;
    await ref
        .read(downloadsRepositoryProvider)
        .deleteAll(tracks.tracks.map((t) => t.fileKey).toList());
  }
}
