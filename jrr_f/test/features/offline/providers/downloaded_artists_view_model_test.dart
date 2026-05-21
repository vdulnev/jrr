import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/downloaded_track.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/downloaded_artists_view_model.dart';
import 'package:jrr_f/features/offline/providers/downloaded_tracks_provider.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup/test_player.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

DownloadedTrack dt({
  required int fileKey,
  required String albumArtist,
  String albumName = 'Album',
  int track = 1,
  int disc = 1,
}) => DownloadedTrack(
  fileKey: fileKey,
  track: Track(
    fileKey: fileKey,
    album: albumName,
    albumArtist: albumArtist,
    discNumber: disc,
    trackNumber: track,
  ),
  localPath: '/p/$fileKey',
  albumGroupId: '${albumName.toLowerCase()}|',
  albumArtist: albumArtist,
  album: albumName,
  dateReadable: '',
  discNumber: disc,
  totalDiscs: 1,
  trackNumber: track,
  fileSizeBytes: 1,
  downloadedAt: DateTime.utc(2026),
);

void main() {
  late MockDownloadsRepo repo;
  late StreamController<List<DownloadedTrack>> ctrl;
  late ProviderContainer container;

  Future<void> open(List<DownloadedTrack> initial) async {
    repo = MockDownloadsRepo();
    ctrl = StreamController<List<DownloadedTrack>>();
    when(() => repo.watchDownloadedTracks()).thenAnswer((_) => ctrl.stream);
    when(() => repo.deleteAll(any())).thenAnswer((_) async {});
    container = ProviderContainer(
      overrides: [
        downloadsRepositoryProvider.overrideWithValue(repo),
        playerProvider.overrideWith(() => TestPlayer()),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(container.listen(downloadedTracksProvider, (_, _) {}).close);
    // Keep the view-model itself alive so its watched derived providers
    // (downloadedArtistsProvider) stay subscribed across this setup.
    addTearDown(
      container.listen(downloadedArtistsViewModelProvider, (_, _) {}).close,
    );
    addTearDown(() async => ctrl.close());
    ctrl.add(initial);
    // Wait for downloadedArtistsProvider (which awaits the stream's first
    // emission) to settle.
    for (var i = 0; i < 40; i++) {
      if (container.read(downloadedArtistsViewModelProvider).artists != null) {
        break;
      }
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  test('exposes the sorted artist list', () async {
    await open([
      dt(fileKey: 1, albumArtist: 'beta'),
      dt(fileKey: 2, albumArtist: 'Alpha'),
    ]);
    final state = container.read(downloadedArtistsViewModelProvider);
    expect(state.artists, ['Alpha', 'beta']);
    expect(state.hasError, isFalse);
    expect(state.isLoading, isFalse);
  });

  test('playArtist forwards the resolved tracks to the player', () async {
    await open([
      dt(fileKey: 1, albumArtist: 'A', albumName: 'X', track: 2),
      dt(fileKey: 2, albumArtist: 'A', albumName: 'X', track: 1),
      dt(fileKey: 3, albumArtist: 'B'),
    ]);
    await container
        .read(downloadedArtistsViewModelProvider.notifier)
        .playArtist('A');
    final player = container.read(playerProvider.notifier) as TestPlayer;
    expect(player.calls, contains(startsWith('playNow:')));
  });

  test('trackCountForArtist returns the count of matching tracks', () async {
    await open([
      dt(fileKey: 1, albumArtist: 'A'),
      dt(fileKey: 2, albumArtist: 'A'),
      dt(fileKey: 3, albumArtist: 'B'),
    ]);
    final count = await container
        .read(downloadedArtistsViewModelProvider.notifier)
        .trackCountForArtist('A');
    expect(count, 2);
  });

  test('trackCountForArtist returns 0 for unknown artist', () async {
    await open([dt(fileKey: 1, albumArtist: 'A')]);
    final count = await container
        .read(downloadedArtistsViewModelProvider.notifier)
        .trackCountForArtist('NotHere');
    expect(count, 0);
  });

  test('deleteArtist forwards the matching fileKeys to deleteAll', () async {
    await open([
      dt(fileKey: 1, albumArtist: 'A'),
      dt(fileKey: 2, albumArtist: 'A'),
      dt(fileKey: 3, albumArtist: 'B'),
    ]);
    await container
        .read(downloadedArtistsViewModelProvider.notifier)
        .deleteArtist('A');
    verify(() => repo.deleteAll([1, 2])).called(1);
  });

  test('refresh() re-invalidates the downloaded artists provider', () async {
    await open([dt(fileKey: 1, albumArtist: 'A')]);
    container.read(downloadedArtistsViewModelProvider.notifier).refresh();
    // Re-emit and confirm the state stays consistent.
    ctrl.add([
      dt(fileKey: 1, albumArtist: 'A'),
      dt(fileKey: 2, albumArtist: 'B'),
    ]);
    for (var i = 0; i < 20; i++) {
      final state = container.read(downloadedArtistsViewModelProvider);
      if (state.artists?.length == 2) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(container.read(downloadedArtistsViewModelProvider).artists, [
      'A',
      'B',
    ]);
  });
}
