import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../providers/library_providers.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  static const _tabs = [
    'Artists',
    'Random',
    'Browse',
    'Favorites',
    'Downloads',
  ];

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  int? _lastIndex;

  @override
  Widget build(BuildContext context) {
    final isOffline = ref.watch(isOfflineActiveProvider);

    return AutoTabsRouter(
      routes: const [
        ArtistsTabRouterRoute(),
        RandomTabRouterRoute(),
        BrowseTabRouterRoute(),
        FavoritesTabRouterRoute(),
        DownloadsTabRouterRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        if (isOffline && tabsRouter.activeIndex != 4) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            tabsRouter.setActiveIndex(4);
          });
        }

        if (_lastIndex != null && _lastIndex != tabsRouter.activeIndex) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            ref.read(libraryChromeVisibleProvider.notifier).set(true);
          });
        }
        _lastIndex = tabsRouter.activeIndex;

        final chromeVisible = ref.watch(libraryChromeVisibleProvider);

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: chromeVisible
                      ? _Header(
                          activeIndex: tabsRouter.activeIndex,
                          onTabSelected: tabsRouter.setActiveIndex,
                        )
                      : const SizedBox(width: double.infinity),
                ),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Header extends ConsumerWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const _Header({required this.activeIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineActiveProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LIBRARY', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 6),
          Text(
            isOffline ? 'Offline' : 'Browse',
            style: AppTextStyles.screenTitle,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.bg2,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(LibraryScreen._tabs.length, (i) {
                final isActive = activeIndex == i;
                final isDownloads = i == 4;
                final isDisabled = isOffline && !isDownloads;

                return Expanded(
                  child: GestureDetector(
                    onTap: isDisabled ? null : () => onTabSelected(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.bg4 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        LibraryScreen._tabs[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isActive
                              ? AppColors.text
                              : (isDisabled
                                    ? AppColors.text3.withValues(alpha: 0.3)
                                    : AppColors.text3),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
