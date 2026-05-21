import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';

void main() {
  group('Zones', () {
    test('stores supplied list of zones', () {
      const list = [
        Zone(id: 'a', name: 'A', guid: 'ga', isDLNA: false),
        Zone(id: 'b', name: 'B', guid: 'gb', isDLNA: false),
      ];
      const zones = Zones(zones: list);
      expect(zones.zones, list);
    });

    test('equality compares list contents by value', () {
      const a = Zones(
        zones: [Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false)],
      );
      const b = Zones(
        zones: [Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false)],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when contents differ', () {
      const a = Zones(zones: []);
      const b = Zones(
        zones: [Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false)],
      );
      expect(a, isNot(equals(b)));
    });
  });
}
