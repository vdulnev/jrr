import 'dart:io';

import 'package:audio_service/audio_service.dart';

import '../../library/data/models/track.dart';
import '../../offline/data/models/downloaded_track.dart';

/// Converts JRR domain models into `audio_service` [MediaItem]s for the
/// Android Auto browse tree.
///
/// v1 is downloads-only (see §7 of `docs/android-auto-plan.md`), so the
/// only artwork URIs we surface are `content://` paths to locally-cached
/// album art, served by the FileProvider declared in AndroidManifest.xml.
/// The MCWS-token-in-URL path for streaming artwork is deferred — it
/// requires re-emitting `MediaItem`s on session refresh, which we don't
/// have plumbing for yet.
class MediaItemMapper {
  const MediaItemMapper();

  /// Authority of the FileProvider declared in AndroidManifest.xml.
  /// Kept in sync with `${applicationId}.fileprovider` and the
  /// `<root-path name="root" .../>` element in res/xml/file_paths.xml.
  static const String _fileProviderAuthority = 'com.jrr.jrr_f.fileprovider';

  /// Builds a FileProvider content:// URI for a local artwork file, or
  /// `null` if [path] is empty / missing. Public so the AA player can
  /// share the same authority/encoding when emitting now-playing items.
  ///
  /// Android Auto runs in a different process from this app and so
  /// can't read `file://` URIs into app-private storage; AA silently
  /// falls back to a generic icon. The content URI scheme, paired with
  /// the FileProvider's `grantUriPermissions=true`, lets the
  /// MediaBrowserService binder pass per-URI read access through.
  static Uri? artUriForPath(String? path) {
    if (path == null || path.isEmpty) return null;
    if (!File(path).existsSync()) return null;
    return Uri(
      scheme: 'content',
      host: _fileProviderAuthority,
      pathSegments: ['root', ...path.split('/').where((s) => s.isNotEmpty)],
    );
  }

  /// Track from the downloaded-tracks table. We carry the cached artwork
  /// path inside the [DownloadedTrack] row.
  ///
  /// When [parentPath] is supplied, the emitted media id encodes the
  /// browse context (e.g. `cat:albums/album:<b64>/track:42`) so that
  /// `playFromMediaId` can reconstruct the surrounding queue from the
  /// parent rather than playing the single track in isolation. Pass
  /// `null` when the item is being emitted for the system queue (the
  /// just_audio sequence) where the id is informational only.
  MediaItem fromDownloadedTrack(DownloadedTrack dt, {String? parentPath}) {
    final trackId = 'track:${dt.fileKey}';
    final id = parentPath == null ? trackId : '$parentPath/$trackId';
    return MediaItem(
      id: id,
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
    Uri? artUri,
  }) {
    return MediaItem(
      id: id,
      title: title,
      album: subtitle,
      artUri: artUri ?? _artUri(artworkPath),
      playable: false,
    );
  }

  /// Playable virtual action — e.g. "Play all" / "Shuffle all" at the
  /// top of a list. Carries a synthetic id like `<parent>/play:all` or
  /// `<parent>/shuffle:all` that `playFromMediaId` recognises and uses
  /// to build a queue from the parent's full child set.
  MediaItem playAction({
    required String id,
    required String title,
    String? subtitle,
    String? artworkPath,
    Uri? artUri,
  }) {
    return MediaItem(
      id: id,
      title: title,
      album: subtitle,
      artUri: artUri ?? _artUri(artworkPath),
      playable: true,
    );
  }

  Uri? _artUri(String? path) => artUriForPath(path);
}
