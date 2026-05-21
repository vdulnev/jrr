import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/layout/adaptive_layout.dart';

void main() {
  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AdaptiveLayoutBuilder(
          narrowBuilder: (_) => const Text('narrow'),
          wideBuilder: (_) => const Text('wide'),
        ),
      ),
    );
  }

  testWidgets('renders narrow builder when width below threshold', (
    tester,
  ) async {
    await pumpAt(tester, const Size(400, 800));
    expect(find.text('narrow'), findsOneWidget);
    expect(find.text('wide'), findsNothing);
  });

  testWidgets('renders wide builder when width equals threshold', (
    tester,
  ) async {
    await pumpAt(tester, const Size(840, 600));
    expect(find.text('wide'), findsOneWidget);
    expect(find.text('narrow'), findsNothing);
  });

  testWidgets('renders wide builder when width above threshold', (
    tester,
  ) async {
    await pumpAt(tester, const Size(1200, 900));
    expect(find.text('wide'), findsOneWidget);
    expect(find.text('narrow'), findsNothing);
  });

  testWidgets('renders narrow builder just below the threshold', (
    tester,
  ) async {
    await pumpAt(tester, const Size(839, 600));
    expect(find.text('narrow'), findsOneWidget);
    expect(find.text('wide'), findsNothing);
  });
}
