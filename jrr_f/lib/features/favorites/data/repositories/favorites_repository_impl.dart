import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/di/injection.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'favorites_repository.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final AppDatabase _db = getIt<AppDatabase>();

  static const String _browseItemType = 'browse_item';

  @override
  Future<Either<AppException, List<Favorite>>> getAll() async {
    try {
      final favorites =
          await (_db.select(_db.favorites)
                ..where((tbl) => tbl.type.equals(_browseItemType))
                ..orderBy([(tbl) => OrderingTerm.desc(tbl.addedAt)]))
              .get();
      return Right(favorites);
    } catch (e) {
      return Left(AppException.database(error: e.toString()));
    }
  }

  @override
  Future<Either<AppException, bool>> isFavorite(BrowseItem item) async {
    try {
      final favorites =
          await (_db.select(_db.favorites)..where(
                (tbl) =>
                    tbl.type.equals(_browseItemType) &
                    tbl.identifier.equals(item.id),
              ))
              .get();
      return Right(favorites.isNotEmpty);
    } catch (e) {
      return Left(AppException.database(error: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> addFavorite(BrowseItem item) async {
    try {
      await _db
          .into(_db.favorites)
          .insert(
            FavoritesCompanion.insert(
              type: _browseItemType,
              identifier: item.id,
              displayName: item.name,
              addedAt: DateTime.now().millisecondsSinceEpoch,
            ),
            mode: InsertMode.insertOrReplace,
          );
      return const Right(null);
    } catch (e) {
      return Left(AppException.database(error: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> removeFavorite(BrowseItem item) async {
    try {
      await (_db.delete(_db.favorites)..where(
            (tbl) =>
                tbl.type.equals(_browseItemType) &
                tbl.identifier.equals(item.id),
          ))
          .go();
      return const Right(null);
    } catch (e) {
      return Left(AppException.database(error: e.toString()));
    }
  }

  @override
  Future<Either<AppException, void>> clearAll() async {
    try {
      await _db.delete(_db.favorites).go();
      return const Right(null);
    } catch (e) {
      return Left(AppException.database(error: e.toString()));
    }
  }
}
