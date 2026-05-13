import 'dart:io';

import 'package:audio_service/audio_service.dart';

import '../../library/data/models/track.dart';
import '../../offline/data/models/downloaded_track.dart';

/// Converts JRR domain models into `audio_service` [MediaItem]s for the
/// Android Auto browse tree.
///
/// v1 is downloads-only (see §7 of `docs/android-auto-plan.md`), so the
/// only artwork URIs we surface are `file://` paths to locally-cached
/// album art. The MCWS-token-in-URL path for streaming artwork is
/// deferred — it requires re-emitting `MediaItem`s on session refresh,
/// which we don't have plumbing for yet.
class MediaItemMapper {
  const MediaItemMapper();

  /// Track from the downloaded-tracks table. We carry the cached artwork
  /// path inside the [DownloadedTrack] row.
  MediaItem fromDownloadedTrack(DownloadedTrack dt) {
    return MediaItem(
      id: 'track:${dt.fileKey}',
      title: dt.track.name.isEmpty ? 'Unknown' : dt.track.name,
      artist: dt.track.artist.isEmpty ? null : dt.track.artist,
      album: dt.track.album.isEmpty ? null : dt.track.album,
      duration: Duration(milliseconds: (dt.track.duration * 1000).round()),
      artUri: _artUri(dt.artworkPath),
      playable: true,
    );
  }

  /// Plain [Track] — used when we already resolved the track separately
  /// (e.g. from a Tracks queue) and only need the head-unit-facing item.
  /// Artwork URI is omitted unless [artworkPath] is provided.
  MediaItem fromTrack(Track track, {String? artworkPath}) {
    return MediaItem(
      id: 'track:${track.fileKey}',
      title: track.name.isEmpty ? 'Unknown' : track.name,
      artist: track.artist.isEmpty ? null : track.artist,
      album: track.album.isEmpty ? null : track.album,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
      artUri: _artUri(artworkPath),
      playable: true,
    );
  }

  /// Non-playable browse node (a category root, an artist, an album).
  MediaItem browseNode({
    required String id,
    required String title,
    String? subtitle,
    String? artworkPath,
  }) {
    return MediaItem(
      id: id,
      title: title,
      album: subtitle,
      artUri: _artUri(artworkPath),
      playable: false,
    );
  }

  Uri? _artUri(String? path) {
    if (path == null || path.isEmpty) return null;
    // Defensive: artworkPath rows can occasionally point at files that
    // have been deleted out-of-band. Auto will silently fall back to a
    // generic icon, but we avoid emitting URIs that we know won't
    // resolve.
    if (!File(path).existsSync()) return null;
    return Uri.file(path);
  }
}
