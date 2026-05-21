import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/widgets/sub_screen_header.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('renders title and back button; tap invokes onBack', (
    tester,
  ) async {
    var back = 0;
    await pump(tester, SubScreenHeader(title: 'Hello', onBack: () => back++));
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(back, 1);
  });

  testWidgets('uppercases the subtitle when supplied', (tester) async {
    await pump(
      tester,
      SubScreenHeader(title: 'Hello', subtitle: 'album', onBack: () {}),
    );
    expect(find.text('ALBUM'), findsOneWidget);
  });

  testWidgets('prefers titleWidget over title when both omitted', (
    tester,
  ) async {
    await pump(
      tester,
      SubScreenHeader(titleWidget: const Text('Custom'), onBack: () {}),
    );
    expect(find.text('Custom'), findsOneWidget);
  });

  testWidgets('renders trailing widget and content when provided', (
    tester,
  ) async {
    await pump(
      tester,
      SubScreenHeader(
        title: 'X',
        trailing: const Icon(Icons.menu),
        content: const Text('extra'),
        onBack: () {},
      ),
    );
    expect(find.byIcon(Icons.menu), findsOneWidget);
    expect(find.text('extra'), findsOneWidget);
  });
}
