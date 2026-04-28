import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  static const _tabs = ['Artists', 'Random', 'Browse', 'Favorites'];

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ArtistsTabRouterRoute(),
        RandomTabRouterRoute(),
        BrowseTabRouterRoute(),
        FavoritesTabRouterRoute(),
      ],
      transitionBuilder: (context, child, animation) => child,
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Header(
                  activeIndex: tabsRouter.activeIndex,
                  onTabSelected: tabsRouter.setActiveIndex,
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

class _Header extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabSelected;

  const _Header({required this.activeIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('LIBRARY', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 6),
          const Text('Browse', style: AppTextStyles.screenTitle),
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
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTabSelected(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 32,
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.bg4 : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        LibraryScreen._tabs[i],
                        style: AppTextStyles.labelLarge.copyWith(
                          color: isActive ? AppColors.text : AppColors.text3,
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
