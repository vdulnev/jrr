import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/layout/layout_breakpoints.dart';

void main() {
  Future<BuildContext> pumpWithSize(WidgetTester tester, Size size) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size),
        child: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    return captured;
  }

  test('wideScreen constant is 840', () {
    expect(LayoutBreakpoints.wideScreen, 840);
  });

  testWidgets('isWide returns true when width equals 840', (tester) async {
    final ctx = await pumpWithSize(tester, const Size(840, 600));
    expect(LayoutBreakpoints.isWide(ctx), isTrue);
    expect(LayoutBreakpoints.isNarrow(ctx), isFalse);
  });

  testWidgets('isWide returns true for widths above 840', (tester) async {
    final ctx = await pumpWithSize(tester, const Size(1200, 800));
    expect(LayoutBreakpoints.isWide(ctx), isTrue);
    expect(LayoutBreakpoints.isNarrow(ctx), isFalse);
  });

  testWidgets('isWide returns false just below the threshold', (tester) async {
    final ctx = await pumpWithSize(tester, const Size(839, 600));
    expect(LayoutBreakpoints.isWide(ctx), isFalse);
    expect(LayoutBreakpoints.isNarrow(ctx), isTrue);
  });

  testWidgets('isNarrow returns true for small phone-like widths', (
    tester,
  ) async {
    final ctx = await pumpWithSize(tester, const Size(360, 800));
    expect(LayoutBreakpoints.isWide(ctx), isFalse);
    expect(LayoutBreakpoints.isNarrow(ctx), isTrue);
  });
}
