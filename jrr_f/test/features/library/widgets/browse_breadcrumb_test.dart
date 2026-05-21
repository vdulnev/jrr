import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'package:jrr_f/features/library/widgets/browse_breadcrumb.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('renders each stack entry separated by chevrons', (tester) async {
    await pump(
      tester,
      BrowseBreadcrumb(
        stack: const [
          BrowseItem(id: '1', name: 'Music'),
          BrowseItem(id: '2', name: 'Rock'),
          BrowseItem(id: '3', name: 'Pop'),
        ],
        onTap: (_) {},
      ),
    );
    expect(find.text('Music'), findsOneWidget);
    expect(find.text('Rock'), findsOneWidget);
    expect(find.text('Pop'), findsOneWidget);
    // 2 chevrons between 3 entries.
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(2));
  });

  testWidgets('prefix taps emit -1', (tester) async {
    final taps = <int>[];
    await pump(
      tester,
      BrowseBreadcrumb(
        stack: const [BrowseItem(id: '1', name: 'Last')],
        onTap: taps.add,
        prefix: 'Root',
      ),
    );
    await tester.tap(find.text('Root'));
    await tester.pumpAndSettle();
    expect(taps, [-1]);
  });

  testWidgets('tapping a non-last entry emits its index', (tester) async {
    final taps = <int>[];
    await pump(
      tester,
      BrowseBreadcrumb(
        stack: const [
          BrowseItem(id: '1', name: 'A'),
          BrowseItem(id: '2', name: 'B'),
          BrowseItem(id: '3', name: 'C'),
        ],
        onTap: taps.add,
      ),
    );
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(taps, [0]);
  });

  testWidgets('tapping the last entry is a no-op', (tester) async {
    final taps = <int>[];
    await pump(
      tester,
      BrowseBreadcrumb(
        stack: const [
          BrowseItem(id: '1', name: 'A'),
          BrowseItem(id: '2', name: 'B'),
        ],
        onTap: taps.add,
      ),
    );
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(taps, isEmpty);
  });
}
