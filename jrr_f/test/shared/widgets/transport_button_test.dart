import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/transport_button.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('renders the supplied child icon', (tester) async {
    await pump(tester, const TransportButton(child: Icon(Icons.play_arrow)));
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('invokes onPressed when tapped', (tester) async {
    var taps = 0;
    await pump(
      tester,
      TransportButton(
        onPressed: () => taps++,
        child: const Icon(Icons.skip_next),
      ),
    );
    await tester.tap(find.byType(TransportButton));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('disables tap when onPressed is null', (tester) async {
    await pump(tester, const TransportButton(child: Icon(Icons.pause)));
    await tester.tap(find.byType(TransportButton));
    await tester.pumpAndSettle();
    // No throw, no callback to call — just confirm the widget rendered.
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });

  testWidgets('accent variant builds with a gradient when enabled', (
    tester,
  ) async {
    await pump(
      tester,
      TransportButton(
        accent: true,
        onPressed: () {},
        child: const Icon(Icons.play_arrow),
      ),
    );
    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(AnimatedScale),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.gradient, isNotNull);
  });
}
