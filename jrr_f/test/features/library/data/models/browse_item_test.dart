import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';

void main() {
  group('BrowseItem', () {
    test('exposes id and name', () {
      const item = BrowseItem(id: '42', name: 'Rock');
      expect(item.id, '42');
      expect(item.name, 'Rock');
    });

    test('equality compares by value', () {
      const a = BrowseItem(id: '1', name: 'A');
      const b = BrowseItem(id: '1', name: 'A');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when id or name differ', () {
      const base = BrowseItem(id: '1', name: 'A');
      expect(base, isNot(equals(const BrowseItem(id: '2', name: 'A'))));
      expect(base, isNot(equals(const BrowseItem(id: '1', name: 'B'))));
    });

    test('copyWith overrides selected fields', () {
      const base = BrowseItem(id: '1', name: 'A');
      expect(base.copyWith(name: 'B'), const BrowseItem(id: '1', name: 'B'));
    });
  });
}
