import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/library/data/repositories/library_repository.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/player/data/repositories/player_repository.dart';
import 'package:jrr_f/features/player/providers/mcws_player_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

class MockPlayerRepo extends Mock implements PlayerRepository {}

class MockLibraryRepo extends Mock implements LibraryRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(ShuffleMode.off);
    registerFallbackValue(RepeatMode.off);
  });

  late MockPlayerRepo playerRepo;
  late MockLibraryRepo libraryRepo;
  const remoteZone = Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false);

  ProviderContainer open({Zone? activeZone}) {
    playerRepo = MockPlayerRepo();
    libraryRepo = MockLibraryRepo();
    when(
      () => playerRepo.getPlaybackInfo(any()),
    ).thenAnswer((_) async => right(stoppedStatus(zoneId: '0')));

    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        playerRepositoryProvider.overrideWithValue(playerRepo),
        libraryRepositoryProvider.overrideWithValue(libraryRepo),
        activeZoneProvider.overrideWith(() => _Active(activeZone)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('build()', () {
    test(
      'returns null for null / local / offline / android-auto zones',
      () async {
        for (final zone in [null, Zone.local, Zone.offline, Zone.androidAuto]) {
          final c = open(activeZone: zone);
          expect(await c.read(mcwsPlayerProvider.future), isNull);
        }
      },
    );

    test('fetches playback info for remote zones', () async {
      final c = open(activeZone: remoteZone);
      final status = await c.read(mcwsPlayerProvider.future);
      expect(status?.zoneId, '0');
      verify(() => playerRepo.getPlaybackInfo('0')).called(1);
    });
  });

  group('command dispatch', () {
    test('every transport command delegates and refreshes', () async {
      final c = open(activeZone: remoteZone);
      await c.read(mcwsPlayerProvider.future);

      when(
        () => playerRepo.playPause(any()),
      ).thenAnswer((_) async => right(unit));
      when(() => playerRepo.stop(any())).thenAnswer((_) async => right(unit));
      when(() => playerRepo.next(any())).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.previous(any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.setPosition(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.setVolume(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.setMute(any(), mute: any(named: 'mute')),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.setShuffle(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.setRepeat(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => playerRepo.playByIndex(any(), any()),
      ).thenAnswer((_) async => right(unit));

      final notifier = c.read(mcwsPlayerProvider.notifier);
      await notifier.playPause();
      await notifier.stop();
      await notifier.next();
      await notifier.previous();
      await notifier.seekTo(123);
      await notifier.setVolume(0.7);
      await notifier.toggleMute();
      await notifier.toggleShuffle();
      await notifier.playByIndex(5);
      await notifier.cycleRepeat();

      verify(() => playerRepo.playPause('0')).called(1);
      verify(() => playerRepo.stop('0')).called(1);
      verify(() => playerRepo.next('0')).called(1);
      verify(() => playerRepo.previous('0')).called(1);
      verify(() => playerRepo.setPosition('0', 123)).called(1);
      verify(() => playerRepo.setVolume('0', 0.7)).called(1);
      verify(() => playerRepo.setMute('0', mute: true)).called(1);
      verify(() => playerRepo.setShuffle('0', ShuffleMode.on)).called(1);
      verify(() => playerRepo.playByIndex('0', 5)).called(1);
      verify(() => playerRepo.setRepeat('0', RepeatMode.playlist)).called(1);
    });

    test('library commands delegate to libraryRepository', () async {
      final c = open(activeZone: remoteZone);
      await c.read(mcwsPlayerProvider.future);

      when(
        () => libraryRepo.playNow(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => libraryRepo.playNext(any(), any()),
      ).thenAnswer((_) async => right(unit));
      when(
        () => libraryRepo.addToQueue(any(), any()),
      ).thenAnswer((_) async => right(unit));

      final tracks = Tracks.fromList(const [Track(fileKey: 1)]);
      final notifier = c.read(mcwsPlayerProvider.notifier);
      await notifier.playNow(tracks);
      await notifier.playNext(tracks);
      await notifier.addToQueue(tracks);

      verify(() => libraryRepo.playNow('0', [1])).called(1);
      verify(() => libraryRepo.playNext('0', [1])).called(1);
      verify(() => libraryRepo.addToQueue('0', [1])).called(1);
    });

    test('virtual zones short-circuit every command', () async {
      final c = open(activeZone: Zone.local);
      await c.read(mcwsPlayerProvider.future);
      await c.read(mcwsPlayerProvider.notifier).playPause();
      verifyNever(() => playerRepo.playPause(any()));
    });

    test('refresh on a virtual zone is a no-op', () async {
      final c = open(activeZone: Zone.local);
      await c.read(mcwsPlayerProvider.future);
      await c.read(mcwsPlayerProvider.notifier).refresh();
      // getPlaybackInfo was not called for the virtual zone (build returned
      // null before the call, and refresh skips too).
      verifyNever(() => playerRepo.getPlaybackInfo(any()));
    });
  });
}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}
