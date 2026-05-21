import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/shared/widgets/vu_meter.dart';

/// Wraps the widget with a fixed-size box and the app theme so the painted
/// region is identical regardless of the host viewport.
Widget _harness({required Widget child}) {
  return MaterialApp(
    theme: buildAppTheme(),
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: AppColors.bg1,
      body: Center(
        child: SizedBox(width: 60, height: 60, child: Center(child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets('VUMeter — inactive', (tester) async {
    await tester.pumpWidget(_harness(child: const VUMeter(active: false)));
    await tester.pump();
    await expectLater(
      find.byType(VUMeter),
      matchesGoldenFile('goldens/vu_meter_inactive.png'),
    );
  });

  testWidgets('VUMeter — active at t=0', (tester) async {
    await tester.pumpWidget(_harness(child: const VUMeter(active: true)));
    // Stop the animation to a fixed phase so the painted bars stay stable.
    await tester.pump(const Duration(milliseconds: 150));
    await expectLater(
      find.byType(VUMeter),
      matchesGoldenFile('goldens/vu_meter_active_t150.png'),
    );
  });

  testWidgets('VUMeter — active at t=300ms (mid-cycle)', (tester) async {
    await tester.pumpWidget(_harness(child: const VUMeter(active: true)));
    await tester.pump(const Duration(milliseconds: 300));
    await expectLater(
      find.byType(VUMeter),
      matchesGoldenFile('goldens/vu_meter_active_t300.png'),
    );
  });

  testWidgets('VUMeter — active at t=450ms (late cycle)', (tester) async {
    await tester.pumpWidget(_harness(child: const VUMeter(active: true)));
    await tester.pump(const Duration(milliseconds: 450));
    await expectLater(
      find.byType(VUMeter),
      matchesGoldenFile('goldens/vu_meter_active_t450.png'),
    );
  });
}
