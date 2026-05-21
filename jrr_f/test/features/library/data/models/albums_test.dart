import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/data/models/albums.dart';

const _a = Album(
  name: 'A',
  albumArtist: 'AA',
  folderPath: '/p/A/',
  parentFolderPath: '/p/',
  albumGroupId: 'a|/p/',
);

const _b = Album(
  name: 'B',
  albumArtist: 'BB',
  folderPath: '/p/B/',
  parentFolderPath: '/p/',
  albumGroupId: 'b|/p/',
);

void main() {
  group('Albums', () {
    test('empty constant has zero length', () {
      expect(Albums.empty.length, 0);
      expect(Albums.empty.isEmpty, isTrue);
      expect(Albums.empty.isNotEmpty, isFalse);
      expect(Albums.empty.firstOrNull, isNull);
    });

    test('fromList wraps a list', () {
      final albums = Albums.fromList(const [_a, _b]);
      expect(albums.length, 2);
      expect(albums.isEmpty, isFalse);
      expect(albums.isNotEmpty, isTrue);
      expect(albums[0], _a);
      expect(albums[1], _b);
      expect(albums.firstOrNull, _a);
    });

    test('default constructor uses empty albums list', () {
      const albums = Albums();
      expect(albums.albums, isEmpty);
    });
  });
}
