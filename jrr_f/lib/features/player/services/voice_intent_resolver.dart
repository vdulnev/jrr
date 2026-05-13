import '../../library/data/models/track.dart';
import '../../offline/data/models/downloaded_track.dart';

/// Android `MediaStore` extras keys carried in `playFromSearch`'s extras
/// map. Auto sets these when the user invokes voice search and Google
/// Assistant has parsed a structured query like "play album X" or
/// "play music by Y".
///
/// Constants intentionally inlined (not pulled from a platform binding)
/// so the resolver stays a pure Dart unit and can be tested without a
/// Flutter binding.
const String kExtraMediaFocus = 'android.intent.extra.focus';
const String kExtraArtist = 'android.intent.extra.artist';
const String kExtraAlbum = 'android.intent.extra.album';
const String kExtraTitle = 'android.intent.extra.title';
const String kExtraGenre = 'android.intent.extra.genre';

const String kFocusArtist = 'vnd.android.cursor.item/artist';
const String kFocusAlbum = 'vnd.android.cursor.item/album';
const String kFocusAudio = 'vnd.android.cursor.item/audio';
const String kFocusGenre = 'vnd.android.cursor.item/genre';

class VoiceIntent {
  final List<Track> tracks;
  final bool shuffle;

  const VoiceIntent({required this.tracks, required this.shuffle});

  static const empty = VoiceIntent(tracks: [], shuffle: false);
}

/// Resolves a voice-search invocation into a concrete play instruction.
///
/// Inputs:
/// - [query]: the raw, possibly free-form transcript from the head unit.
///   A leading `shuffle ` is treated as a shuffle intent and stripped.
/// - [extras]: Auto's structured extras map (may be null). Honored
///   whenever a [kExtraMediaFocus] is present.
/// - [downloaded]: the user's downloaded tracks. v1 is downloads-only;
///   the resolver never reaches the live MCWS library.
///
/// Selection rules (first match wins):
/// 1. `focus = artist` and `artist` extra present → all tracks by that artist.
/// 2. `focus = album` and `album` extra present → tracks of that album.
///    Artist extra, when also present, narrows the album to its artist
///    (handles the "Greatest Hits" ambiguity).
/// 3. `focus = audio` and `title` extra present → tracks matching the title.
/// 4. `focus = genre` and `genre` extra present → tracks in that genre.
/// 5. Non-empty query after stripping `shuffle `: substring search
///    across name / artist / album.
/// 6. Empty query (e.g. "play music"): the entire library, with shuffle
///    forced on regardless of the prefix.
VoiceIntent resolveVoiceIntent({
  required String query,
  required Map<String, dynamic>? extras,
  required List<DownloadedTrack> downloaded,
}) {
  var working = query.trim();
  var shuffle = false;

  final lowered = working.toLowerCase();
  if (lowered.startsWith('shuffle ')) {
    shuffle = true;
    working = working.substring('shuffle '.length).trim();
  } else if (lowered == 'shuffle') {
    shuffle = true;
    working = '';
  }

  final focus = extras?[kExtraMediaFocus] as String?;
  final artist = (extras?[kExtraArtist] as String?)?.trim();
  final album = (extras?[kExtraAlbum] as String?)?.trim();
  final title = (extras?[kExtraTitle] as String?)?.trim();
  final genre = (extras?[kExtraGenre] as String?)?.trim();

  Iterable<DownloadedTrack> matches;

  if (focus == kFocusArtist && artist != null && artist.isNotEmpty) {
    matches = downloaded.where((t) => _artistOf(t).equalsIgnoreCase(artist));
  } else if (focus == kFocusAlbum && album != null && album.isNotEmpty) {
    matches = downloaded.where(
      (t) =>
          t.album.equalsIgnoreCase(album) &&
          (artist == null ||
              artist.isEmpty ||
              _artistOf(t).equalsIgnoreCase(artist)),
    );
  } else if (focus == kFocusAudio && title != null && title.isNotEmpty) {
    matches = downloaded.where(
      (t) => t.track.name.toLowerCase().contains(title.toLowerCase()),
    );
  } else if (focus == kFocusGenre && genre != null && genre.isNotEmpty) {
    matches = downloaded.where(
      (t) => t.track.genre.toLowerCase().contains(genre.toLowerCase()),
    );
  } else if (working.isEmpty) {
    // "Just play music" — shuffle the whole downloaded library.
    matches = downloaded;
    shuffle = true;
  } else {
    final q = working.toLowerCase();
    matches = downloaded.where(
      (d) =>
          d.track.name.toLowerCase().contains(q) ||
          d.track.artist.toLowerCase().contains(q) ||
          d.track.album.toLowerCase().contains(q),
    );
  }

  final tracks = matches.map((d) => d.track).toList(growable: false);
  return VoiceIntent(tracks: tracks, shuffle: shuffle);
}

String _artistOf(DownloadedTrack t) {
  if (t.albumArtist.isNotEmpty) return t.albumArtist;
  if (t.track.albumArtist.isNotEmpty) return t.track.albumArtist;
  return t.track.artist;
}

extension on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}
