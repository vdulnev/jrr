import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';
import '../../features/player/widgets/mini_player_panel.dart';
import '../../shared/widgets/loading_view.dart';
import '../router/navigation_notifier.dart';
import 'app_router.dart';

@RoutePage()
class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (session is Restoring) {
      return const Scaffold(body: LoadingView());
    }

    final navStack = ref.watch(navigationProvider);
    final showMiniPlayer = session is Authenticated && navStack.isNotEmpty;

    return Column(
      children: [
        Expanded(
          child: AutoRouter.declarative(
            routes: (_) => switch (session) {
              Unauthenticated() => [const ServerSetupRoute()],
              Authenticated() => [const NowPlayingRoute(), ...navStack],
              Restoring() => [const ServerSetupRoute()],
            },
          ),
        ),
        AnimatedSlide(
          offset: showMiniPlayer ? Offset.zero : const Offset(0, 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: showMiniPlayer
              ? const MiniPlayerPanel()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
