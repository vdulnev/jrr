import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/router/navigation_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
  });

  test('build() defaults to nowPlaying', () {
    expect(container.read(activeTabProvider), AppTab.nowPlaying);
  });

  test('select() updates state and notifies listeners', () {
    final emissions = <AppTab>[];
    container.listen(
      activeTabProvider,
      (_, next) => emissions.add(next),
      fireImmediately: true,
    );
    container.read(activeTabProvider.notifier).select(AppTab.library);
    container.read(activeTabProvider.notifier).select(AppTab.settings);

    expect(emissions, [AppTab.nowPlaying, AppTab.library, AppTab.settings]);
    expect(container.read(activeTabProvider), AppTab.settings);
  });
}
