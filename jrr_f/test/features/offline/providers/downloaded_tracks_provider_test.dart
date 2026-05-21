import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

DownloadedTrack dt({
  required int fileKey,
  required String albumArtist,
  required String albumGroupId,
  String date = '',
  int disc = 1,
  int trackNumber = 1,
  String albumName = 'Album',
}) => DownloadedTrack(
  fileKey: fileKey,
  track: Track(
    fileKey: fileKey,
    album: albumName,
    albumArtist: albumArtist,
    discNumber: disc,
    trackNumber: trackNumber,
    totalDiscs: 1,
    dateReadable: date,
  ),
  localPath: '/p/$fileKey.flac',
  albumGroupId: albumGroupId,
  albumArtist: albumArtist,
  album: albumName,
  dateReadable: date,
  discNumber: disc,
  totalDiscs: 1,
  trackNumber: trackNumber,
  fileSizeBytes: 1,
  downloadedAt: DateTime.utc(2026),
);

void main() {
  late MockDownloadsRepo repo;
  late StreamController<List<DownloadedTrack>> controller;
  late ProviderContainer container;

  setUp(() {
    repo = MockDownloadsRepo();
    controller = StreamController<List<DownloadedTrack>>();
    when(
      () => repo.watchDownloadedTracks(),
    ).thenAnswer((_) => controller.stream);
    container = ProviderContainer(
      overrides: [downloadsRepositoryProvider.overrideWithValue(repo)],
    );
    // Subscribe to keep the underlying StreamProvider alive so values
    // pushed onto the controller are delivered before disposal.
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    addTearDown(() async {
      await controller.close();
      container.dispose();
    });
  });

  test('downloadedTracks emits the latest watcher value', () async {
    final sub = container.listen(downloadedTracksProvider, (_, _) {});
    addTearDown(sub.close);

    controller.add([dt(fileKey: 1, albumArtist: 'A', albumGroupId: 'a|/')]);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(downloadedTracksProvider).value!.single.fileKey, 1);
  });

  test('downloadedArtists returns unique sorted artist names', () async {
    controller.add([
      dt(fileKey: 1, albumArtist: 'beta', albumGroupId: 'g1'),
      dt(fileKey: 2, albumArtist: 'Alpha', albumGroupId: 'g2'),
      dt(fileKey: 3, albumArtist: 'beta', albumGroupId: 'g1'),
      dt(fileKey: 4, albumArtist: '', albumGroupId: 'g3'),
    ]);

    final artists = await container.read(downloadedArtistsProvider.future);
    expect(artists, ['Alpha', 'beta', 'Unknown Artist']);
  });

  test(
    'downloadedAlbums filters by artist (case-insensitive) and groups',
    () async {
      controller.add([
        dt(
          fileKey: 1,
          albumArtist: 'Foo',
          albumGroupId: 'foo|a',
          date: '2020',
          albumName: 'A',
        ),
        dt(
          fileKey: 2,
          albumArtist: 'foo',
          albumGroupId: 'foo|a',
          date: '2020',
          trackNumber: 2,
          albumName: 'A',
        ),
        dt(
          fileKey: 3,
          albumArtist: 'foo',
          albumGroupId: 'foo|b',
          date: '2021',
          albumName: 'B',
        ),
        dt(
          fileKey: 4,
          albumArtist: 'Bar',
          albumGroupId: 'bar|a',
          date: '2019',
          albumName: 'X',
        ),
      ]);

      final albums = await container.read(
        downloadedAlbumsProvider('foo').future,
      );
      expect(albums, hasLength(2));
      // Sorted by year desc then name asc
      expect(albums.first.name, 'B');
      expect(albums.last.name, 'A');
    },
  );

  test('downloadedAlbumTracks sorts by disc then track number', () async {
    controller.add([
      dt(
        fileKey: 1,
        albumArtist: 'X',
        albumGroupId: 'g',
        disc: 2,
        trackNumber: 1,
      ),
      dt(
        fileKey: 2,
        albumArtist: 'X',
        albumGroupId: 'g',
        disc: 1,
        trackNumber: 3,
      ),
      dt(
        fileKey: 3,
        albumArtist: 'X',
        albumGroupId: 'g',
        disc: 1,
        trackNumber: 1,
      ),
      dt(
        fileKey: 4,
        albumArtist: 'X',
        albumGroupId: 'other',
        disc: 1,
        trackNumber: 1,
      ),
    ]);

    final tracks = await container.read(
      downloadedAlbumTracksProvider('g').future,
    );
    expect(tracks.tracks.map((t) => t.fileKey), [3, 2, 1]);
  });
}
