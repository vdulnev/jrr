import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_list_view_model.dart';
import 'package:jrr_f/features/zones/providers/zone_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

void main() {
  Future<ProviderContainer> open({
    AsyncValue<Zones> zones = const AsyncValue.loading(),
    Zone? active,
    PlaybackState playback = PlaybackState.stopped,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        talkerProvider.overrideWithValue(Talker()),
        zoneListProvider.overrideWith(() => _ZoneList(zones)),
        playerProvider.overrideWith(
          () => TestPlayer(status: stoppedStatus(state: playback)),
        ),
        if (active != null)
          activeZoneProvider.overrideWith(() => _StaticActive(active)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('exposes zones, error, active zone, and playback state', () async {
    const zone = Zone(id: '0', name: 'A', guid: 'g', isDLNA: false);
    final c = await open(
      zones: const AsyncValue.data(Zones(zones: [zone])),
      active: zone,
      playback: PlaybackState.playing,
    );
    final sub = c.listen(zoneListViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    await c.read(zoneListProvider.future);
    await c.read(playerProvider.future);
    final state = c.read(zoneListViewModelProvider);
    expect(state.zones?.zones, [zone]);
    expect(state.activeZone, zone);
    expect(state.error, isNull);
    expect(state.activePlaybackState, PlaybackState.playing);
  });

  test('error surfaces when the zone list provider fails', () async {
    final c = await open(
      zones: AsyncValue.error(StateError('boom'), StackTrace.empty),
    );
    final sub = c.listen(zoneListViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    for (var i = 0; i < 20; i++) {
      if (c.read(zoneListViewModelProvider).error != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    final state = c.read(zoneListViewModelProvider);
    expect(state.error, isA<StateError>());
  });

  test('setZone forwards to ActiveZone.setZone', () async {
    const a = Zone(id: '0', name: 'A', guid: 'guid-a', isDLNA: false);
    const b = Zone(id: '1', name: 'B', guid: 'guid-b', isDLNA: false);
    final c = await open(
      zones: const AsyncValue.data(Zones(zones: [a, b])),
      active: a,
    );
    c.read(zoneListViewModelProvider.notifier).setZone(b);
    expect(c.read(activeZoneProvider), b);
  });
}

class _ZoneList extends ZoneList {
  _ZoneList(this._value);
  final AsyncValue<Zones> _value;
  @override
  Future<Zones> build() async {
    return _value.maybeWhen(
      data: (z) => z,
      orElse: () => throw _value.error ?? StateError('loading'),
    );
  }
}

class _StaticActive extends ActiveZone {
  _StaticActive(this._zone);
  final Zone _zone;
  @override
  Zone? build() => _zone;
}
