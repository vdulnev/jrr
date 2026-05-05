import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../data/models/downloaded_track.dart';
import '../data/repositories/downloads_repository.dart';

import '../../library/data/models/album.dart';
import '../../library/data/models/tracks.dart';

part 'downloaded_tracks_provider.g.dart';

@riverpod
class DownloadedTracks extends _$DownloadedTracks {
  @override
  Stream<List<DownloadedTrack>> build() {
    return getIt<DownloadsRepository>().watchDownloadedTracks();
  }
}

@riverpod
Future<List<String>> downloadedArtists(Ref ref) async {
  final tracks = await ref.watch(downloadedTracksProvider.future);
  final artists =
      tracks
          .map((t) => t.albumArtist.isEmpty ? 'Unknown Artist' : t.albumArtist)
          .toSet()
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  return artists;
}

@riverpod
Future<List<Album>> downloadedAlbums(Ref ref, String artist) async {
  final tracks = await ref.watch(downloadedTracksProvider.future);
  final artistTracks = tracks.where(
    (t) => (t.albumArtist.isEmpty ? 'Unknown Artist' : t.albumArtist) == artist,
  );

  final albumGroups = <String, Album>{};
  for (final t in artistTracks) {
    if (!albumGroups.containsKey(t.albumGroupId)) {
      albumGroups[t.albumGroupId] = Album.fromTrack(t.track);
    }
  }

  final albums = albumGroups.values.toList();
  // Sort year-descending, then album name ascending
  albums.sort((a, b) {
    final dateCompare = b.date.compareTo(a.date);
    if (dateCompare != 0) return dateCompare;
    return a.name.compareTo(b.name);
  });

  return albums;
}

@riverpod
Future<Tracks> downloadedAlbumTracks(Ref ref, String albumGroupId) async {
  final tracks = await ref.watch(downloadedTracksProvider.future);
  final albumTracks =
      tracks
          .where((t) => t.albumGroupId == albumGroupId)
          .map((t) => t.track)
          .toList();

  // Sort by disc then track
  albumTracks.sort((a, b) {
    final discCompare = a.discNumber.compareTo(b.discNumber);
    if (discCompare != 0) return discCompare;
    return a.trackNumber.compareTo(b.trackNumber);
  });

  return Tracks(tracks: albumTracks);
}
