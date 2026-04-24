import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../providers/library_providers.dart';
import 'artists_tab.dart';
import 'browse_tab.dart';
import 'favorites_tab.dart';
import 'random_tab.dart';

@RoutePage()
class LibraryRootScreen extends ConsumerWidget {
  const LibraryRootScreen({super.key});

  static const _tabs = ['Artists', 'Random', 'Browse', 'Favorites'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(libraryTabIndexProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LIBRARY', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 6),
                  const Text('Browse', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 14),
                  // Segmented tab control
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.bg2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final isActive = tabIndex == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(libraryTabIndexProvider.notifier)
                                .set(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.bg4
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _tabs[i],
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isActive
                                      ? AppColors.text
                                      : AppColors.text3,
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
            ),
            // Tab content
            Expanded(
              child: IndexedStack(
                index: tabIndex,
                children: const [
                  ArtistsTab(),
                  RandomTab(),
                  BrowseTab(),
                  FavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
