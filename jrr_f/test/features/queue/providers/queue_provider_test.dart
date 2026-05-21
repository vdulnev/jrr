import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/queue/data/repositories/queue_repository.dart';
import 'package:jrr_f/features/queue/providers/queue_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

class MockQueueRepo extends Mock implements QueueRepository {}

void main() {
  late MockQueueRepo repo;

  Future<ProviderContainer> open({Zone? activeZone}) async {
    repo = MockQueueRepo();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        sharedPreferencesProvider.overrideWithValue(prefs),
        queueRepositoryProvider.overrideWithValue(repo),
        playerProvider.overrideWith(() => TestPlayer()),
        activeZoneProvider.overrideWith(() => _Active(activeZone)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('returns empty when no zone is active', () async {
    final c = await open();
    final tracks = await c.read(queueProvider.future);
    expect(tracks, Tracks.empty);
  });

  test('returns repository result for remote zones', () async {
    const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
    final c = await open(activeZone: zone);
    final result = Tracks.fromList(const [Track(fileKey: 1, name: 'Song')]);
    when(() => repo.getQueue('0')).thenAnswer((_) async => right(result));

    final tracks = await c.read(queueProvider.future);
    expect(tracks.tracks.first.fileKey, 1);
  });

  test(
    'removeItem delegates to repository.removeItem for remote zones',
    () async {
      const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
      final c = await open(activeZone: zone);
      when(
        () => repo.getQueue('0'),
      ).thenAnswer((_) async => right(Tracks.empty));
      when(() => repo.removeItem('0', 3)).thenAnswer((_) async => right(unit));

      await c.read(queueProvider.future);
      await c.read(queueProvider.notifier).removeItem(3);
      verify(() => repo.removeItem('0', 3)).called(1);
    },
  );

  test('moveItem delegates to repository.moveItem for remote zones', () async {
    const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
    final c = await open(activeZone: zone);
    when(() => repo.getQueue('0')).thenAnswer((_) async => right(Tracks.empty));
    when(() => repo.moveItem('0', 1, 4)).thenAnswer((_) async => right(unit));

    await c.read(queueProvider.future);
    await c.read(queueProvider.notifier).moveItem(1, 4);
    verify(() => repo.moveItem('0', 1, 4)).called(1);
  });

  test(
    'clearQueue delegates to repository.clearQueue for remote zones',
    () async {
      const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
      final c = await open(activeZone: zone);
      when(
        () => repo.getQueue('0'),
      ).thenAnswer((_) async => right(Tracks.empty));
      when(() => repo.clearQueue('0')).thenAnswer((_) async => right(unit));

      await c.read(queueProvider.future);
      await c.read(queueProvider.notifier).clearQueue();
      verify(() => repo.clearQueue('0')).called(1);
    },
  );
}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}
