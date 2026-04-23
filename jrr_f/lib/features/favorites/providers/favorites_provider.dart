import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/core/di/injection.dart';
import 'package:jrr_f/features/favorites/data/repositories/favorites_repository.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorites_provider.g.dart';

/// List of favorited browse items
@riverpod
class Favorites extends _$Favorites {
  @override
  Future<List<BrowseItem>> build() async {
    final result = await getIt<FavoritesRepository>().getAll();
    return result.fold(
      (error) => throw error,
      (favorites) => favorites
          .map((fav) => BrowseItem(id: fav.identifier, name: fav.displayName))
          .toList(),
    );
  }

  /// Check if a browse item is favorited
  AsyncValue<bool> isFavorite(BrowseItem item) {
    return switch (state) {
      AsyncData(:final value) => AsyncData(
        value.any((fav) => fav.id == item.id),
      ),
      AsyncLoading() => const AsyncLoading<bool>(),
      AsyncError(:final error, :final stackTrace) => AsyncError(
        error,
        stackTrace,
      ),
    };
  }

  /// Toggle a browse item's favorite status
  Future<void> toggleFavorite(BrowseItem item) async {
    switch (state) {
      case AsyncData(:final value):
        final isFav = value.any((fav) => fav.id == item.id);
        if (isFav) {
          await getIt<FavoritesRepository>().removeFavorite(item);
        } else {
          await getIt<FavoritesRepository>().addFavorite(item);
        }
        // Invalidate to refresh the list after modification
        ref.invalidate(favoritesProvider);
      case AsyncLoading():
        // Optionally, you could queue the toggle action until loading is complete
        break;
      case AsyncError():
        // Handle error state if needed
        break;
    }
  }

  /// Remove a browse item from favorites
  Future<void> removeBrowseItemFavoriteProvider(
    WidgetRef ref,
    BrowseItem item,
  ) async {
    await getIt<FavoritesRepository>().removeFavorite(item);
    ref.invalidate(favoritesProvider);
  }
}
