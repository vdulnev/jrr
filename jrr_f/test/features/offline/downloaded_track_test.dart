import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/library/data/models/track.dart';

void main() {
  group('DownloadedTrack equality', () {
    test('DownloadedTrack equality is case-insensitive for artist and album', () {
      final track = const Track(fileKey: 1, name: 'Song');
      final dt1 = DownloadedTrack(
        fileKey: 1,
        track: track,
        localPath: '/local/path',
        albumGroupId: 'group',
        albumArtist: 'Artist',
        album: 'Album',
        dateReadable: '2020',
        discNumber: 1,
        totalDiscs: 1,
        trackNumber: 1,
        fileSizeBytes: 1000,
        downloadedAt: DateTime(2020),
      );
      final dt2 = DownloadedTrack(
        fileKey: 1,
        track: track,
        localPath: '/local/path',
        albumGroupId: 'group',
        albumArtist: 'artist',
        album: 'album',
        dateReadable: '2020',
        discNumber: 1,
        totalDiscs: 1,
        trackNumber: 1,
        fileSizeBytes: 1000,
        downloadedAt: DateTime(2020),
      );

      expect(dt1 == dt2, isTrue);
      expect(dt1.hashCode == dt2.hashCode, isTrue);
    });
  });
}
