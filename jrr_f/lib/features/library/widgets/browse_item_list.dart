import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/browse_item.dart';
import 'browse_item_tile.dart';

/// Reusable list of browse items with favorite toggle.
/// Used by BrowseTreeView (server items) and FavoritesScreen (favorite items).
class BrowseItemList extends ConsumerWidget {
  /// Items to display (from server browse or local favorites)
  final List<BrowseItem> items;

  /// Callback when an item is tapped
  final ValueChanged<BrowseItem> onTap;

  /// Whether to show the favorite toggle icon
  final bool showFavoriteToggle;

  const BrowseItemList({
    super.key,
    required this.items,
    required this.onTap,
    this.showFavoriteToggle = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 148),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return BrowseItemTile(
          item: item,
          onTap: () => onTap(item),
          showFavoriteToggle: showFavoriteToggle,
        );
      },
    );
  }
}
