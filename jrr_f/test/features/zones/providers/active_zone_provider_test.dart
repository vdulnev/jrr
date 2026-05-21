import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

void main() {
  late SharedPreferences prefs;

  Future<ProviderContainer> open({
    AsyncValue<Zones> zones = const AsyncValue.loading(),
    Map<String, Object> seed = const {},
  }) async {
    SharedPreferences.setMockInitialValues(seed);
    prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        talkerProvider.overrideWithValue(Talker()),
        zoneListProvider.overrideWith(() => _ZoneList(zones)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('build()', () {
    test('starts as null', () async {
      final c = await open();
      expect(c.read(activeZoneProvider), isNull);
      expect(c.read(isOfflineActiveProvider), isFalse);
      expect(c.read(isAndroidAutoActiveProvider), isFalse);
      expect(c.read(isOfflineLikeActiveProvider), isFalse);
      expect(c.read(isVirtualZoneActiveProvider), isFalse);
    });
  });

  group('restoreZone via zoneListProvider emissions', () {
    test('picks the first zone when no guid pref is set', () async {
      const a = Zone(id: '0', name: 'A', guid: 'guid-a', isDLNA: false);
      const b = Zone(id: '1', name: 'B', guid: 'guid-b', isDLNA: false);
      final c = await open(zones: const AsyncValue.data(Zones(zones: [a, b])));
      final sub = c.listen(activeZoneProvider, (_, _) {});
      addTearDown(sub.close);
      // Listening to zoneListProvider's change is what triggers _restoreZone;
      // active_zone_provider already does that in build(), so just let the
      // pump happen.
      await Future<void>.delayed(Duration.zero);
      expect(c.read(activeZoneProvider), a);
      expect(prefs.getString(kActiveZoneGuidKey), 'guid-a');
    });

    test('picks the zone matching the saved guid', () async {
      const a = Zone(id: '0', name: 'A', guid: 'guid-a', isDLNA: false);
      const b = Zone(id: '1', name: 'B', guid: 'guid-b', isDLNA: false);
      final c = await open(
        zones: const AsyncValue.data(Zones(zones: [a, b])),
        seed: {kActiveZoneGuidKey: 'guid-b'},
      );
      final sub = c.listen(activeZoneProvider, (_, _) {});
      addTearDown(sub.close);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(activeZoneProvider), b);
    });

    test('clears state when zone list arrives empty', () async {
      final c = await open(
        zones: const AsyncValue.data(Zones(zones: [])),
        seed: {kActiveZoneGuidKey: 'guid-x'},
      );
      final sub = c.listen(activeZoneProvider, (_, _) {});
      addTearDown(sub.close);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(activeZoneProvider), isNull);
      expect(prefs.containsKey(kActiveZoneGuidKey), isFalse);
    });
  });

  group('setZone / clear', () {
    test('setZone updates state and pref', () async {
      final c = await open();
      const zone = Zone(id: '0', name: 'A', guid: 'guid-a', isDLNA: false);
      c.read(activeZoneProvider.notifier).setZone(zone);
      expect(c.read(activeZoneProvider), zone);
      expect(prefs.getString(kActiveZoneGuidKey), 'guid-a');
    });

    test('clear() removes the pref', () async {
      final c = await open(seed: {kActiveZoneGuidKey: 'guid-a'});
      c.read(activeZoneProvider.notifier).clear();
      expect(c.read(activeZoneProvider), isNull);
      expect(prefs.containsKey(kActiveZoneGuidKey), isFalse);
    });
  });

  group('derived flags', () {
    test('isOfflineActive reflects current zone', () async {
      final c = await open();
      c.read(activeZoneProvider.notifier).setZone(Zone.offline);
      expect(c.read(isOfflineActiveProvider), isTrue);
      expect(c.read(isOfflineLikeActiveProvider), isTrue);
      expect(c.read(isVirtualZoneActiveProvider), isTrue);
      expect(c.read(isAndroidAutoActiveProvider), isFalse);
    });

    test('isAndroidAutoActive flag', () async {
      final c = await open();
      c.read(activeZoneProvider.notifier).setZone(Zone.androidAuto);
      expect(c.read(isAndroidAutoActiveProvider), isTrue);
      expect(c.read(isOfflineLikeActiveProvider), isTrue);
      expect(c.read(isVirtualZoneActiveProvider), isTrue);
    });

    test('Local zone is virtual but not offline / android-auto', () async {
      final c = await open();
      c.read(activeZoneProvider.notifier).setZone(Zone.local);
      expect(c.read(isVirtualZoneActiveProvider), isTrue);
      expect(c.read(isOfflineActiveProvider), isFalse);
      expect(c.read(isAndroidAutoActiveProvider), isFalse);
      expect(c.read(isOfflineLikeActiveProvider), isFalse);
    });
  });
}

class _ZoneList extends ZoneList {
  _ZoneList(this._value);
  final AsyncValue<Zones> _value;
  @override
  Future<Zones> build() async {
    final v = _value;
    return v.maybeWhen(
      data: (z) => z,
      orElse: () => throw v.error ?? StateError('loading'),
    );
  }
}
