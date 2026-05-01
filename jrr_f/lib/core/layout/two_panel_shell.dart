import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../router/navigation_notifier.dart';
import '../../features/player/widgets/now_playing_screen.dart';
import '../../features/player/widgets/mini_player_panel.dart';
import '../../features/queue/widgets/queue_screen.dart';
import '../../features/connection/widgets/server_manager_screen.dart';
import '../../features/library/widgets/library_screen.dart';
import '../../features/zones/widgets/zone_list_screen.dart';
import 'sidebar.dart';

class TwoPanelShell extends ConsumerWidget {
  const TwoPanelShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeTabProvider);

    return Material(
      color: AppColors.bg1,
      child: Row(
        children: [
          const Sidebar(),
          Expanded(child: _MainPanel(activeTab: activeTab)),
        ],
      ),
    );
  }
}

class _MainPanel extends ConsumerWidget {
  final AppTab activeTab;

  const _MainPanel({required this.activeTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMiniPlayer = activeTab != AppTab.nowPlaying;

    return Column(
      children: [
        Expanded(child: _ContentArea(activeTab: activeTab)),
        if (showMiniPlayer)
          Container(
            decoration: const BoxDecoration(
              color: AppColors.bg1,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: MiniPlayerPanel(
              onItemTap: () {
                ref.read(activeTabProvider.notifier).select(AppTab.nowPlaying);
              },
            ),
          ),
      ],
    );
  }
}

class _ContentArea extends StatelessWidget {
  final AppTab activeTab;

  const _ContentArea({required this.activeTab});

  @override
  Widget build(BuildContext context) {
    Widget content;
    switch (activeTab) {
      case AppTab.nowPlaying:
        content = const NowPlayingScreen();
        break;
      case AppTab.queue:
        content = const QueueScreen();
        break;
      case AppTab.library:
        content = const LibraryScreen();
        break;
      case AppTab.zones:
        content = const ZoneListScreen();
        break;
      case AppTab.settings:
        content = const ServerManagerScreen();
        break;
    }

    return content;
  }
}
