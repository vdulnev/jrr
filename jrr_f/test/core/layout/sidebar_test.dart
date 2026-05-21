import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/layout/sidebar.dart';
import 'package:jrr_f/core/router/navigation_notifier.dart';
import 'package:jrr_f/core/theme/app_theme.dart';

void main() {
  Future<void> pump(WidgetTester tester, {AppTab? seed}) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: Consumer(
            builder: (context, ref, _) {
              if (seed != null && ref.read(activeTabProvider) != seed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ref.read(activeTabProvider.notifier).select(seed);
                });
              }
              return const Scaffold(body: Sidebar());
            },
          ),
        ),
      ),
    );
    if (seed != null) await tester.pump();
  }

  testWidgets('shows the JRR brand and all nav items', (tester) async {
    await pump(tester);
    expect(find.text('JRR'), findsOneWidget);
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Queue'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Zones'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('tapping a nav item updates active tab provider', (tester) async {
    await pump(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(Sidebar)),
    );
    expect(container.read(activeTabProvider), AppTab.nowPlaying);

    await tester.tap(find.text('Library'));
    await tester.pump();
    expect(container.read(activeTabProvider), AppTab.library);

    await tester.tap(find.text('Zones'));
    await tester.pump();
    expect(container.read(activeTabProvider), AppTab.zones);
  });

  testWidgets('active nav item paints the accent foreground colour', (
    tester,
  ) async {
    await pump(tester, seed: AppTab.queue);

    final queueText = tester.widget<Text>(find.text('Queue'));
    expect(queueText.style?.color, AppColors.accent);
    expect(queueText.style?.fontWeight, FontWeight.w600);

    final libraryText = tester.widget<Text>(find.text('Library'));
    expect(libraryText.style?.color, AppColors.text);
    expect(libraryText.style?.fontWeight, FontWeight.w400);
  });

  testWidgets('sidebar paints bg1 and is 280px wide', (tester) async {
    await pump(tester);
    final material = tester.widget<Material>(
      find
          .descendant(of: find.byType(Sidebar), matching: find.byType(Material))
          .first,
    );
    expect(material.color, AppColors.bg1);

    final sized = tester.getSize(
      find
          .descendant(
            of: find.byType(Sidebar),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(sized.width, 280);
  });
}
