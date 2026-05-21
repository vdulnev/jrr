import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';

void main() {
  late AppDatabase db;
  late FavoritesRepositoryImpl repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = FavoritesRepositoryImpl(db: db);
  });

  tearDown(() async {
    await db.close();
  });

  const item = BrowseItem(id: '42', name: 'Rock');

  test('getAll returns empty list initially', () async {
    final result = await repo.getAll();
    expect(result.getOrElse((_) => [const _Sentinel()]), isEmpty);
  });

  test('addFavorite inserts a row visible to getAll', () async {
    await repo.addFavorite(item);
    final list = (await repo.getAll()).getOrElse((_) => []);
    expect(list, hasLength(1));
    expect(list.first.identifier, '42');
    expect(list.first.displayName, 'Rock');
    expect(list.first.type, 'browse_item');
  });

  test('isFavorite reflects current state', () async {
    expect((await repo.isFavorite(item)).getOrElse((_) => true), isFalse);
    await repo.addFavorite(item);
    expect((await repo.isFavorite(item)).getOrElse((_) => false), isTrue);
  });

  test('removeFavorite deletes only the matching identifier', () async {
    await repo.addFavorite(item);
    await repo.addFavorite(const BrowseItem(id: '99', name: 'Pop'));

    await repo.removeFavorite(item);
    final list = (await repo.getAll()).getOrElse((_) => []);
    expect(list, hasLength(1));
    expect(list.first.identifier, '99');
  });

  test('clearAll empties the favorites table', () async {
    await repo.addFavorite(item);
    await repo.addFavorite(const BrowseItem(id: '99', name: 'Pop'));
    await repo.clearAll();
    expect((await repo.getAll()).getOrElse((_) => []), isEmpty);
  });

  test('getAll orders by addedAt descending', () async {
    await repo.addFavorite(const BrowseItem(id: '1', name: 'first'));
    // Force a tick so addedAt timestamps differ on fast machines.
    await Future<void>.delayed(const Duration(milliseconds: 2));
    await repo.addFavorite(const BrowseItem(id: '2', name: 'second'));
    final list = (await repo.getAll()).getOrElse((_) => []);
    expect(list.first.identifier, '2');
    expect(list.last.identifier, '1');
  });
}

class _Sentinel implements Favorite {
  const _Sentinel();
  @override
  dynamic noSuchMethod(Invocation i) => super.noSuchMethod(i);
}
