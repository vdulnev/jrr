import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/player/services/voice_intent_resolver.dart';

DownloadedTrack _dt({
  required int fileKey,
  String name = '',
  String artist = '',
  String albumArtist = '',
  String album = '',
  String genre = '',
}) {
  final track = Track(
    fileKey: fileKey,
    name: name,
    artist: artist,
    albumArtist: albumArtist,
    album: album,
    genre: genre,
  );
  return DownloadedTrack(
    fileKey: fileKey,
    track: track,
    localPath: '/tmp/$fileKey.flac',
    albumGroupId: '${album.toLowerCase()}|',
    albumArtist: albumArtist.isEmpty ? artist : albumArtist,
    album: album,
    dateReadable: '',
    discNumber: 0,
    totalDiscs: 1,
    trackNumber: 0,
    fileSizeBytes: 0,
    downloadedAt: DateTime(2020, 1, 1),
  );
}

void main() {
  final library = <DownloadedTrack>[
    _dt(
      fileKey: 1,
      name: 'Hey Jude',
      artist: 'The Beatles',
      albumArtist: 'The Beatles',
      album: 'Past Masters',
    ),
    _dt(
      fileKey: 2,
      name: 'Let It Be',
      artist: 'The Beatles',
      albumArtist: 'The Beatles',
      album: 'Let It Be',
      genre: 'Rock',
    ),
    _dt(
      fileKey: 3,
      name: 'Imagine',
      artist: 'John Lennon',
      albumArtist: 'John Lennon',
      album: 'Imagine',
      genre: 'Rock',
    ),
    _dt(
      fileKey: 4,
      name: 'Greatest Hit',
      artist: 'Queen',
      albumArtist: 'Queen',
      album: 'Greatest Hits',
    ),
    _dt(
      fileKey: 5,
      name: 'Greatest Hit Vol 2',
      artist: 'Eagles',
      albumArtist: 'Eagles',
      album: 'Greatest Hits',
    ),
    _dt(
      fileKey: 6,
      name: 'Jazz Tune',
      artist: 'Miles Davis',
      albumArtist: 'Miles Davis',
      album: 'Kind of Blue',
      genre: 'Jazz',
    ),
  ];

  test('focused artist search returns all that artist\'s tracks', () {
    final intent = resolveVoiceIntent(
      query: '',
      extras: const {
        kExtraMediaFocus: kFocusArtist,
        kExtraArtist: 'The Beatles',
      },
      downloaded: library,
    );
    expect(intent.tracks.map((t) => t.fileKey).toList(), [1, 2]);
    expect(intent.shuffle, isFalse);
  });

  test('focused album search returns that album\'s tracks', () {
    final intent = resolveVoiceIntent(
      query: '',
      extras: const {kExtraMediaFocus: kFocusAlbum, kExtraAlbum: 'Let It Be'},
      downloaded: library,
    );
    expect(intent.tracks.single.fileKey, 2);
  });

  test('focused album narrows by artist when both extras are present', () {
    final intent = resolveVoiceIntent(
      query: '',
      extras: const {
        kExtraMediaFocus: kFocusAlbum,
        kExtraAlbum: 'Greatest Hits',
        kExtraArtist: 'Queen',
      },
      downloaded: library,
    );
    expect(intent.tracks.single.fileKey, 4);
  });

  test('focused genre search matches the genre extra', () {
    final intent = resolveVoiceIntent(
      query: '',
      extras: const {kExtraMediaFocus: kFocusGenre, kExtraGenre: 'Jazz'},
      downloaded: library,
    );
    expect(intent.tracks.single.fileKey, 6);
  });

  test('"shuffle <artist>" strips the prefix and flags shuffle', () {
    final intent = resolveVoiceIntent(
      query: 'shuffle the beatles',
      extras: null,
      downloaded: library,
    );
    expect(intent.shuffle, isTrue);
    expect(intent.tracks.map((t) => t.fileKey).toSet(), {1, 2});
  });

  test('bare "shuffle" plays the whole library on shuffle', () {
    final intent = resolveVoiceIntent(
      query: 'shuffle',
      extras: null,
      downloaded: library,
    );
    expect(intent.shuffle, isTrue);
    expect(intent.tracks.length, library.length);
  });

  test('free-form substring search hits across name/artist/album', () {
    final intent = resolveVoiceIntent(
      query: 'imagine',
      extras: null,
      downloaded: library,
    );
    expect(intent.tracks.single.fileKey, 3);
    expect(intent.shuffle, isFalse);
  });

  test('empty query with no extras shuffles entire library', () {
    final intent = resolveVoiceIntent(
      query: '',
      extras: null,
      downloaded: library,
    );
    expect(intent.shuffle, isTrue);
    expect(intent.tracks.length, library.length);
  });

  test('no matches returns empty intent', () {
    final intent = resolveVoiceIntent(
      query: 'something that does not exist',
      extras: null,
      downloaded: library,
    );
    expect(intent.tracks, isEmpty);
  });

  test('focus without a matching extra falls through to query search', () {
    // Auto sometimes sets focus but omits the corresponding extra. We
    // should fall back to substring search on the raw query.
    final intent = resolveVoiceIntent(
      query: 'beatles',
      extras: const {kExtraMediaFocus: kFocusArtist},
      downloaded: library,
    );
    expect(intent.tracks.map((t) => t.fileKey).toSet(), {1, 2});
  });
}
