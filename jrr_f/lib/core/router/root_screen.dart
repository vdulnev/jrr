import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';
import '../../features/library/widgets/library_screen.dart';
import '../../features/player/widgets/mini_player_panel.dart';
import '../../features/player/widgets/now_playing_screen.dart';
import '../../features/queue/widgets/queue_screen.dart';
import '../../features/zones/widgets/zone_list_screen.dart';
import '../../shared/widgets/loading_view.dart';
import '../theme/app_theme.dart';
import 'app_router.dart';
import 'navigation_notifier.dart';

@RoutePage()
class RootScreen extends ConsumerWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (session is Restoring) {
      return const Scaffold(body: LoadingView());
    }

    if (session is! Authenticated) {
      return AutoRouter.declarative(routes: (_) => [const ServerSetupRoute()]);
    }

    return const _AuthenticatedShell();
  }
}

class _AuthenticatedShell extends ConsumerWidget {
  const _AuthenticatedShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);
    final navStack = ref.watch(navigationProvider);
    final showMiniPlayer =
        activeTab != AppTab.nowPlaying || navStack.isNotEmpty;

    final miniPlayer = showMiniPlayer
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: MiniPlayerPanel(
              onTap: () {
                ref.read(navigationProvider.notifier).clear();
                ref.read(activeTabProvider.notifier).select(AppTab.nowPlaying);
              },
            ),
          )
        : null;

    // If we have sub-screens pushed, show them via declarative router
    if (navStack.isNotEmpty) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: AutoRouter.declarative(
                routes: (_) => [const NowPlayingRoute(), ...navStack],
              ),
            ),
            ?miniPlayer,
          ],
        ),
        bottomNavigationBar: _TabBar(
          active: activeTab,
          onSelect: (tab) => ref.read(activeTabProvider.notifier).select(tab),
        ),
      );
    }

    // Main tab content
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IndexedStack(
              index: activeTab.index,
              children: const [
                NowPlayingScreen(),
                QueueScreen(),
                LibraryScreen(),
                ZoneListScreen(),
              ],
            ),
          ),
          ?miniPlayer,
        ],
      ),
      bottomNavigationBar: _TabBar(
        active: activeTab,
        onSelect: (tab) => ref.read(activeTabProvider.notifier).select(tab),
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  final AppTab active;
  final ValueChanged<AppTab> onSelect;

  const _TabBar({required this.active, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: AppColors.bg1.withValues(alpha: 0.94),
        border: const Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _TabItem(
              icon: _playingIcon,
              label: 'Playing',
              isActive: active == AppTab.nowPlaying,
              onTap: () => onSelect(AppTab.nowPlaying),
            ),
            _TabItem(
              icon: _queueIcon,
              label: 'Queue',
              isActive: active == AppTab.queue,
              onTap: () => onSelect(AppTab.queue),
            ),
            _TabItem(
              icon: _libraryIcon,
              label: 'Library',
              isActive: active == AppTab.library,
              onTap: () => onSelect(AppTab.library),
            ),
            _TabItem(
              icon: _zonesIcon,
              label: 'Zones',
              isActive: active == AppTab.zones,
              onTap: () => onSelect(AppTab.zones),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _playingIcon(Color c) => Icon(Icons.album_outlined, color: c);
  static Widget _queueIcon(Color c) =>
      Icon(Icons.queue_music_outlined, color: c);
  static Widget _libraryIcon(Color c) =>
      Icon(Icons.library_music_outlined, color: c);
  static Widget _zonesIcon(Color c) =>
      Icon(Icons.speaker_group_outlined, color: c);
}

class _TabItem extends StatelessWidget {
  final Widget Function(Color) icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.accent : AppColors.text3;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon(color),
            const SizedBox(height: 4),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: AppFonts.sans,
                fontSize: 9,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: color,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
