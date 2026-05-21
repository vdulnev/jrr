import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';

void main() {
  group('Zone', () {
    test('offline constant flags isOffline', () {
      expect(Zone.offline.id, 'offline');
      expect(Zone.offline.isOffline, isTrue);
      expect(Zone.offline.isLocal, isFalse);
      expect(Zone.offline.isAndroidAuto, isFalse);
      expect(Zone.offline.isDLNA, isFalse);
    });

    test('local constant flags isLocal', () {
      expect(Zone.local.id, 'local');
      expect(Zone.local.isLocal, isTrue);
      expect(Zone.local.isOffline, isFalse);
      expect(Zone.local.isAndroidAuto, isFalse);
    });

    test('androidAuto constant flags isAndroidAuto', () {
      expect(Zone.androidAuto.id, 'android-auto');
      expect(Zone.androidAuto.isAndroidAuto, isTrue);
      expect(Zone.androidAuto.isLocal, isFalse);
      expect(Zone.androidAuto.isOffline, isFalse);
    });

    test('equality compares by value', () {
      const a = Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false);
      const b = Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when guid differs', () {
      const a = Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false);
      const b = Zone(id: 'a', name: 'A', guid: 'h', isDLNA: false);
      expect(a, isNot(equals(b)));
    });

    test('copyWith overrides selected fields', () {
      const a = Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false);
      final b = a.copyWith(name: 'B', isDLNA: true);
      expect(b.name, 'B');
      expect(b.isDLNA, isTrue);
      expect(a.name, 'A');
    });
  });
}
