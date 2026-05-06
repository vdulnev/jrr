import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/album.dart';

void main() {
  group('Album equality', () {
    test('Album equality is case-insensitive for specified fields', () {
      const a1 = Album(
        name: 'Greatest Hits',
        albumArtist: 'The Band',
        folderPath: '/Music/The Band/Greatest Hits/',
        parentFolderPath: '/Music/The Band/',
        date: '2020',
      );
      const a2 = Album(
        name: 'greatest hits',
        albumArtist: 'the band',
        folderPath: '/music/the band/greatest hits/',
        parentFolderPath: '/music/the band/',
        date: '2020',
      );

      expect(a1 == a2, isTrue);
      expect(a1.hashCode == a2.hashCode, isTrue);
    });

    test('Album equality is case-sensitive for other fields', () {
      const a1 = Album(
        name: 'Greatest Hits',
        albumArtist: 'The Band',
        folderPath: '/Music/The Band/Greatest Hits/',
        parentFolderPath: '/Music/The Band/',
        date: 'May 2020',
      );
      const a2 = Album(
        name: 'Greatest Hits',
        albumArtist: 'The Band',
        folderPath: '/Music/The Band/Greatest Hits/',
        parentFolderPath: '/Music/The Band/',
        date: 'may 2020',
      );

      expect(a1 == a2, isFalse);
      expect(a1.hashCode == a2.hashCode, isFalse);
    });
  });
}
