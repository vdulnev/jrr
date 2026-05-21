import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/action_chip_button.dart';

void main() {
  testWidgets('renders the label and fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActionChipButton(label: 'Play', onTap: () => taps++),
        ),
      ),
    );
    expect(find.text('Play'), findsOneWidget);
    await tester.tap(find.byType(ActionChipButton));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('renders without onTap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ActionChipButton(label: 'Disabled')),
      ),
    );
    expect(find.text('Disabled'), findsOneWidget);
  });
}
