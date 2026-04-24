import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../data/models/browse_item.dart';
import '../../favorites/providers/favorites_provider.dart';

/// Reusable tile for a browse item
class BrowseItemTile extends ConsumerWidget {
  final BrowseItem item;
  final VoidCallback onTap;
  final bool showFavoriteToggle;

  const BrowseItemTile({
    super.key,
    required this.item,
    required this.onTap,
    this.showFavoriteToggle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider.notifier).isFavorite(item);

    return switch (isFav) {
      AsyncData(:final value) => _Tile(
        onTap: onTap,
        item: item,
        showFavoriteToggle: showFavoriteToggle,
        isFav: value,
        onPressed: () =>
            ref.read(favoritesProvider.notifier).toggleFavorite(item),
      ),
      AsyncLoading() => _Tile(
        onTap: onTap,
        item: item,
        showFavoriteToggle: showFavoriteToggle,
        isLoading: true,
      ),
      AsyncError() => _Tile(
        onTap: onTap,
        item: item,
        showFavoriteToggle: showFavoriteToggle,
        isError: true,
      ),
    };
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.onTap,
    required this.item,
    required this.showFavoriteToggle,
    this.isFav = false,
    this.isLoading = false,
    this.isError = false,
    this.onPressed,
  });

  final VoidCallback onTap;
  final VoidCallback? onPressed;
  final BrowseItem item;
  final bool showFavoriteToggle;
  final bool isFav;
  final bool isLoading;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg3,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.folder_outlined,
                size: 20,
                color: AppColors.text3,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(item.name, style: AppTextStyles.itemTitle)),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.text3),
            if (showFavoriteToggle) ...[
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(_buildIcon(), color: _iconColor, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onPressed,
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _buildIcon() {
    if (isLoading) return Icons.hourglass_empty;
    if (isError) return Icons.error_outline;
    return isFav ? Icons.favorite : Icons.favorite_border;
  }

  Color get _iconColor {
    if (isLoading) return AppColors.text3.withValues(alpha: 0.5);
    if (isError) return AppColors.text3;
    return isFav ? AppColors.accent : AppColors.text3;
  }
}
