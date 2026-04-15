import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';
import '../router/navigation_notifier.dart';
import 'app_router.dart';

@RoutePage()
class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final navStack = ref.watch(navigationProvider);

    return AutoRouter.declarative(
      routes: (_) => switch (session) {
        Unauthenticated() => [const ServerSetupRoute()],
        Authenticated() => [const NowPlayingRoute(), ...navStack],
      },
    );
  }
}
