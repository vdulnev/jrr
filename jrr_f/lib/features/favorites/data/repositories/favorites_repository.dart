import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';

abstract class FavoritesRepository {
  /// Get all browse item favorites
  Future<Either<AppException, List<Favorite>>> getAll();

  /// Check if a browse item is favorited
  Future<Either<AppException, bool>> isFavorite(BrowseItem item);

  /// Add a browse item to favorites
  Future<Either<AppException, void>> addFavorite(BrowseItem item);

  /// Remove a browse item from favorites
  Future<Either<AppException, void>> removeFavorite(BrowseItem item);

  /// Clear all favorites
  Future<Either<AppException, void>> clearAll();
}
