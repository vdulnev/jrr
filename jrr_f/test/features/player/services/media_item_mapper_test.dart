import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/player/services/media_item_mapper.dart';

void main() {
  const mapper = MediaItemMapper();
  late Directory tempDir;
  late File artFile;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('mim-');
    artFile = File('${tempDir.path}/cover.jpg');
    await artFile.writeAsString('img');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('artUriForPath', () {
    test('returns null for null or empty paths', () {
      expect(MediaItemMapper.artUriForPath(null), isNull);
      expect(MediaItemMapper.artUriForPath(''), isNull);
    });

    test('returns null when file does not exist', () {
      expect(MediaItemMapper.artUriForPath('/no/such/file.jpg'), isNull);
    });

    test('builds a FileProvider content URI for an existing file', () {
      final uri = MediaItemMapper.artUriForPath(artFile.path)!;
      expect(uri.scheme, 'content');
      expect(uri.host, 'com.jrr.jrr_f.fileprovider');
      expect(uri.pathSegments.first, 'root');
      expect(uri.pathSegments.last, 'cover.jpg');
    });
  });

  group('fromDownloadedTrack', () {
    DownloadedTrack downloaded({String? artworkPath, String name = 'Hello'}) =>
        DownloadedTrack(
          fileKey: 7,
          track: Track(
            fileKey: 7,
            name: name,
            artist: 'A',
            album: 'B',
            duration: 2.5,
          ),
          localPath: '/x.flac',
          artworkPath: artworkPath,
          albumGroupId: 'g',
          albumArtist: 'A',
          album: 'B',
          dateReadable: '',
          discNumber: 0,
          totalDiscs: 0,
          trackNumber: 0,
          fileSizeBytes: 0,
          downloadedAt: DateTime.utc(2026, 1, 1),
        );

    test('uses track:<fileKey> as the id when no parentPath given', () {
      final item = mapper.fromDownloadedTrack(downloaded());
      expect(item.id, 'track:7');
      expect(item.playable, isTrue);
      expect(item.title, 'Hello');
      expect(item.duration, const Duration(milliseconds: 2500));
    });

    test('prefixes id with parentPath when provided', () {
      final item = mapper.fromDownloadedTrack(
        downloaded(),
        parentPath: 'cat:albums/album:abc',
      );
      expect(item.id, 'cat:albums/album:abc/track:7');
    });

    test('falls back to "Unknown" when track name is empty', () {
      final item = mapper.fromDownloadedTrack(downloaded(name: ''));
      expect(item.title, 'Unknown');
    });

    test('sets artUri when artworkPath exists on disk', () {
      final item = mapper.fromDownloadedTrack(
        downloaded(artworkPath: artFile.path),
      );
      expect(item.artUri, isNotNull);
      expect(item.artUri!.scheme, 'content');
    });

    test('artUri is null when artworkPath does not exist', () {
      final item = mapper.fromDownloadedTrack(
        downloaded(artworkPath: '/missing.jpg'),
      );
      expect(item.artUri, isNull);
    });
  });

  group('fromTrack', () {
    test('emits the same shape with the supplied artwork path', () {
      const t = Track(fileKey: 9, name: 'Song', duration: 3);
      final item = mapper.fromTrack(t, artworkPath: artFile.path);
      expect(item.id, 'track:9');
      expect(item.playable, isTrue);
      expect(item.duration, const Duration(seconds: 3));
      expect(item.artUri, isNotNull);
    });

    test('artist and album nulled when empty strings', () {
      const t = Track(fileKey: 9, name: 'Song');
      final item = mapper.fromTrack(t);
      expect(item.artist, isNull);
      expect(item.album, isNull);
    });

    test('falls back to "Unknown" when track name is empty', () {
      const t = Track(fileKey: 9, name: '');
      final item = mapper.fromTrack(t);
      expect(item.title, 'Unknown');
    });
  });

  group('browseNode', () {
    test('builds a non-playable node with subtitle as album', () {
      final item = mapper.browseNode(
        id: 'cat:albums',
        title: 'Albums',
        subtitle: '42 albums',
      );
      expect(item.id, 'cat:albums');
      expect(item.playable, isFalse);
      expect(item.album, '42 albums');
    });

    test('prefers explicit artUri over artworkPath', () {
      final explicit = Uri.parse('content://foo/bar');
      final item = mapper.browseNode(
        id: 'x',
        title: 'X',
        artUri: explicit,
        artworkPath: artFile.path,
      );
      expect(item.artUri, explicit);
    });
  });

  group('playAction', () {
    test('builds a playable action with the supplied id', () {
      final item = mapper.playAction(
        id: 'cat:albums/play:all',
        title: 'Play all',
      );
      expect(item.id, 'cat:albums/play:all');
      expect(item.playable, isTrue);
    });
  });
}
