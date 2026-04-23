import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../favorites/providers/favorites_provider.dart';
import '../../library/data/models/browse_item.dart';
import '../../library/providers/library_providers.dart';
import '../../library/widgets/browse_content.dart';
import '../../library/widgets/browse_item_list.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackProvider = browseNavigationStackProvider(BrowseScope.favorites);
    final stack = ref.watch(stackProvider);

    if (stack.isEmpty) {
      return _FavoritesList(
        onPush: (item) {
          ref
              .read(stackProvider.notifier)
              .push(BrowseItem(id: item.id, name: item.name));
        },
      );
    }

    return BrowseContent(
      breadcrumbPrefix: 'Favorites',
      stack: stack,
      onPush: (item) {
        ref
            .read(stackProvider.notifier)
            .push(BrowseItem(id: item.id, name: item.name));
      },
      onTapBreadcrumb: (i) =>
          ref.read(stackProvider.notifier).navigateToBreadcrumb(i),
    );
  }
}

class _FavoritesList extends ConsumerWidget {
  final ValueChanged<BrowseItem> onPush;

  const _FavoritesList({required this.onPush});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);

    return favorites.when(
      loading: () => const LoadingView(),
      error: (e, _) =>
          ErrorView(error: e, onRetry: () => ref.invalidate(favoritesProvider)),
      data: (items) {
        if (items.isEmpty) {
          return const _EmptyState();
        }
        return BrowseItemList(items: items, onTap: onPush);
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_outlined,
            size: 64,
            color: AppColors.text3,
          ),
          SizedBox(height: 16),
          Text('No favorites yet', style: AppTextStyles.emptyState),
          SizedBox(height: 8),
          Text(
            'Browse folders and tap the heart icon to add them here',
            style: AppTextStyles.itemSubtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
