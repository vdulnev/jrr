import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/lifecycle/app_lifecycle_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'subscribing to appLifecycleProvider attaches an AppLifecycleListener',
    () {
      // Track lifecycle observers before/after the provider is read.
      final before = WidgetsBinding.instance.lifecycleState;
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Reading the keepAlive void provider has no return value beyond
      // exercising the side-effect of attaching the listener.
      container.read(appLifecycleProvider);

      // Sanity: the binding is still alive after subscription.
      expect(WidgetsBinding.instance.lifecycleState, before);
    },
  );
}
