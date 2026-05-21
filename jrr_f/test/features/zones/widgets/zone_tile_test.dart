import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/widgets/zone_tile.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('renders speaker icon for non-DLNA zone', (tester) async {
    await pump(
      tester,
      ZoneTile(
        zone: const Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false),
        isSelected: false,
        onTap: () {},
      ),
    );
    expect(find.byIcon(Icons.speaker), findsOneWidget);
    expect(find.text('Player'), findsOneWidget);
    expect(find.text('DLNA'), findsNothing);
  });

  testWidgets('renders cast icon and DLNA subtitle for DLNA zones', (
    tester,
  ) async {
    await pump(
      tester,
      ZoneTile(
        zone: const Zone(id: '0', name: 'TV', guid: 'g', isDLNA: true),
        isSelected: false,
        onTap: () {},
      ),
    );
    expect(find.byIcon(Icons.cast), findsOneWidget);
    expect(find.text('DLNA'), findsOneWidget);
  });

  testWidgets('check icon appears when selected and onTap fires', (
    tester,
  ) async {
    var taps = 0;
    await pump(
      tester,
      ZoneTile(
        zone: const Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false),
        isSelected: true,
        onTap: () => taps++,
      ),
    );
    expect(find.byIcon(Icons.check), findsOneWidget);
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });
}
