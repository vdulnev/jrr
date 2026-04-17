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
}
