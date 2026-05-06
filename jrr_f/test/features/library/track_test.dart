import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';

void main() {
  group('Track path helpers', () {
    test('folderPath extracts directory with trailing separator', () {
      expect(
        const Track(
          fileKey: 1,
          filePath: r'C:\Music\Artist\Album\Song.flac',
        ).folderPath,
        r'C:\Music\Artist\Album\',
      );
      expect(
        const Track(
          fileKey: 1,
          filePath: '/home/user/music/song.mp3',
        ).folderPath,
        '/home/user/music/',
      );
      expect(const Track(fileKey: 1, filePath: 'song.mp3').folderPath, '');
    });

    test('parentFolderPath returns parent directory', () {
      expect(
        const Track(
          fileKey: 1,
          filePath: r'C:\Music\Artist\Album\Song.flac',
        ).parentFolderPath,
        r'C:\Music\Artist\',
      );
      expect(
        const Track(
          fileKey: 1,
          filePath: '/home/user/music/song.mp3',
        ).parentFolderPath,
        '/home/user/',
      );
      expect(
        const Track(fileKey: 1, filePath: '/song.mp3').parentFolderPath,
        '/',
      );
      expect(
        const Track(fileKey: 1, filePath: r'C:\song.mp3').parentFolderPath,
        r'C:\',
      );
      expect(
        const Track(fileKey: 1, filePath: 'song.mp3').parentFolderPath,
        '',
      );
    });
  });

  group('Track equality', () {
    test('Track equality is case-insensitive for specified fields', () {
      const t1 = Track(
        fileKey: 1,
        name: 'Song',
        artist: 'Artist',
        album: 'Album',
        genre: 'Rock',
        fileType: 'FLAC',
      );
      const t2 = Track(
        fileKey: 1,
        name: 'song',
        artist: 'ARTIST',
        album: 'album',
        genre: 'rock',
        fileType: 'flac',
      );

      expect(t1 == t2, isTrue);
      expect(t1.hashCode == t2.hashCode, isTrue);
    });

    test('Track equality is case-sensitive for other fields', () {
      const t1 = Track(
        fileKey: 1,
        name: 'Song',
        albumArtist: 'Artist',
      );
      const t2 = Track(
        fileKey: 1,
        name: 'Song',
        albumArtist: 'artist',
      );

      expect(t1 == t2, isFalse);
      expect(t1.hashCode == t2.hashCode, isFalse);
    });
  });
}
