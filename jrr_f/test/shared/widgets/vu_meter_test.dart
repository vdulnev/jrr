import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/vu_meter.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('renders 7 bars regardless of active flag', (tester) async {
    await pump(tester, const VUMeter(active: false));
    expect(find.byType(Container), findsNWidgets(7));
  });

  testWidgets('toggling active starts the animation', (tester) async {
    Widget meter(bool active) => MaterialApp(
      home: Scaffold(body: VUMeter(active: active)),
    );
    await tester.pumpWidget(meter(false));
    await tester.pump(const Duration(milliseconds: 50));

    // Flip to active and let the animation tick.
    await tester.pumpWidget(meter(true));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.pump(const Duration(milliseconds: 100));

    // Flip back to inactive — should stop without error.
    await tester.pumpWidget(meter(false));
    await tester.pump(const Duration(milliseconds: 50));
    expect(find.byType(VUMeter), findsOneWidget);
  });
}
