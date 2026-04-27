import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';
import '../../features/connection/widgets/server_manager_screen.dart';
import '../../features/library/widgets/library_screen.dart';
import '../../features/player/widgets/mini_player_panel.dart';
import '../../features/player/widgets/now_playing_screen.dart';
import '../../features/queue/widgets/queue_screen.dart';
import '../../features/zones/providers/zone_polling_provider.dart';
import '../../features/zones/widgets/zone_list_screen.dart';
import '../../shared/widgets/loading_view.dart';
import '../layout/adaptive_layout.dart';
import '../layout/sidebar.dart';
import '../layout/two_panel_shell.dart';
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
    ref.watch(zonePollingProvider);

    return AdaptiveLayoutBuilder(
      narrowBuilder: (context) => _NarrowLayout(ref: ref),
      wideBuilder: (context) => _WideLayout(ref: ref),
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  final WidgetRef ref;

  const _NarrowLayout({required this.ref});

  @override
  Widget build(BuildContext context) {
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

    if (navStack.isNotEmpty) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: AutoRouter.declarative(
                routes: (_) => [const NowPlayingRoute(), ...navStack],
              ),
            ),
            ...miniPlayer != null ? [miniPlayer] : [],
          ],
        ),
        bottomNavigationBar: _TabBar(
          active: activeTab,
          onSelect: (tab) => ref.read(activeTabProvider.notifier).select(tab),
        ),
      );
    }

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
                ServerManagerScreen(),
              ],
            ),
          ),
          ...miniPlayer != null ? [miniPlayer] : [],
        ],
      ),
      bottomNavigationBar: _TabBar(
        active: activeTab,
        onSelect: (tab) => ref.read(activeTabProvider.notifier).select(tab),
      ),
    );
  }
}

class _WideLayout extends StatelessWidget {
  final WidgetRef ref;

  const _WideLayout({required this.ref});

  @override
  Widget build(BuildContext context) {
    final navStack = ref.watch(navigationProvider);
    final activeTab = ref.watch(activeTabProvider);

    if (navStack.isNotEmpty) {
      final showMiniPlayer = activeTab != AppTab.nowPlaying;

      return Scaffold(
        body: Material(
          color: AppColors.bg1,
          child: Row(
            children: [
              const Sidebar(),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: AutoRouter.declarative(
                        routes: (_) => [const NowPlayingRoute(), ...navStack],
                      ),
                    ),
                    if (showMiniPlayer)
                      Container(
                        decoration: const BoxDecoration(
                          color: AppColors.bg1,
                          border: Border(
                            top: BorderSide(color: AppColors.line),
                          ),
                        ),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: MiniPlayerPanel(
                          onTap: () {
                            ref
                                .read(activeTabProvider.notifier)
                                .select(AppTab.nowPlaying);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const TwoPanelShell();
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
            _TabItem(
              icon: (c) => Icon(Icons.settings_outlined, color: c),
              label: 'Settings',
              isActive: active == AppTab.settings,
              onTap: () => onSelect(AppTab.settings),
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
