import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/progress_bar.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: SizedBox(width: 200, child: child)),
    ),
  );

  testWidgets('builds without callbacks', (tester) async {
    await pump(tester, const AppProgressBar(progress: 0.4));
    expect(find.byType(AppProgressBar), findsOneWidget);
  });

  testWidgets('tap reports the clamped fractional position', (tester) async {
    final reports = <double>[];
    await pump(tester, AppProgressBar(progress: 0.0, onChanged: reports.add));
    await tester.tapAt(tester.getCenter(find.byType(AppProgressBar)));
    await tester.pumpAndSettle();
    expect(reports.single, closeTo(0.5, 0.05));
  });

  testWidgets('dragging emits progressively updated values', (tester) async {
    final reports = <double>[];
    await pump(tester, AppProgressBar(progress: 0.0, onChanged: reports.add));
    final box = find.byType(AppProgressBar);
    final start = tester.getTopLeft(box) + const Offset(10, 24);
    final gesture = await tester.startGesture(start);
    await gesture.moveBy(const Offset(80, 0));
    await tester.pump();
    await gesture.moveBy(const Offset(40, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(reports.length, greaterThan(1));
    expect(reports.last, greaterThan(reports.first));
  });
}
