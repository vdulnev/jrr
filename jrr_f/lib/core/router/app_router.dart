import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';
import '../../features/connection/widgets/connecting_screen.dart';
import '../../features/connection/widgets/server_setup_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: RootRoute.page,
      initial: true,
      children: [
        AutoRoute(page: ServerSetupRoute.page),
        AutoRoute(page: PlayerPlaceholderRoute.page),
        AutoRoute(page: ConnectingRoute.page),
      ],
    ),
  ];
}

/// Root screen that switches between auth and player stacks.
@RoutePage()
class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    return AutoRouter.declarative(
      routes: (_) => switch (session) {
        Unauthenticated() => [const ServerSetupRoute()],
        Authenticated() => [const PlayerPlaceholderRoute()],
      },
    );
  }
}

/// Placeholder for the player screen, replaced in Phase 3.
@RoutePage()
class PlayerPlaceholderScreen extends StatelessWidget {
  const PlayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
