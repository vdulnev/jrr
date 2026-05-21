import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/favorites/data/repositories/favorites_repository.dart';
import 'package:jrr_f/features/favorites/providers/favorites_provider.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesRepo extends Mock implements FavoritesRepository {}

class FakeBrowseItem extends Fake implements BrowseItem {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBrowseItem());
  });

  late MockFavoritesRepo repo;
  late ProviderContainer container;

  Favorite fav(int id, {String identifier = '1', String name = 'A'}) =>
      Favorite(
        id: id,
        type: 'browse_item',
        identifier: identifier,
        displayName: name,
        addedAt: id,
      );

  setUp(() {
    repo = MockFavoritesRepo();
    container = ProviderContainer(
      overrides: [favoritesRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  test('build() maps Favorite rows into BrowseItems', () async {
    when(
      () => repo.getAll(),
    ).thenAnswer((_) async => right([fav(1, identifier: 'x', name: 'X')]));
    final result = await container.read(favoritesProvider.future);
    expect(result, hasLength(1));
    expect(result.single.id, 'x');
    expect(result.single.name, 'X');
  });

  test('build() surfaces repository errors via AsyncError state', () async {
    when(
      () => repo.getAll(),
    ).thenAnswer((_) async => left(const AppException.database(error: 'x')));
    final emissions = <AsyncValue<List<BrowseItem>>>[];
    final sub = container.listen(
      favoritesProvider,
      (_, next) => emissions.add(next),
      fireImmediately: true,
    );
    addTearDown(sub.close);
    // Pump until the AsyncError lands (build() runs on the next microtask).
    for (var i = 0; i < 20; i++) {
      if (emissions.any((e) => e.hasError)) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(emissions.last.hasError, isTrue);
    expect(emissions.last.error, isA<DatabaseException>());
  });

  group('isFavorite', () {
    test('returns AsyncData(true) when the id is present', () async {
      when(
        () => repo.getAll(),
      ).thenAnswer((_) async => right([fav(1, identifier: '7', name: 'Rock')]));
      await container.read(favoritesProvider.future);
      final result = container
          .read(favoritesProvider.notifier)
          .isFavorite(const BrowseItem(id: '7', name: 'Rock'));
      expect(result.value, isTrue);
    });

    test('returns AsyncData(false) when the id is absent', () async {
      when(() => repo.getAll()).thenAnswer((_) async => right(const []));
      await container.read(favoritesProvider.future);
      final result = container
          .read(favoritesProvider.notifier)
          .isFavorite(const BrowseItem(id: '9', name: 'Pop'));
      expect(result.value, isFalse);
    });
  });

  group('toggleFavorite', () {
    test('adds when item is missing then refreshes', () async {
      var rows = <Favorite>[];
      when(() => repo.getAll()).thenAnswer((_) async => right(rows));
      when(() => repo.addFavorite(any())).thenAnswer((_) async {
        rows = [fav(1, identifier: '5', name: 'New')];
        return right(null);
      });
      when(
        () => repo.removeFavorite(any()),
      ).thenAnswer((_) async => right(null));

      await container.read(favoritesProvider.future);
      await container
          .read(favoritesProvider.notifier)
          .toggleFavorite(const BrowseItem(id: '5', name: 'New'));

      verify(() => repo.addFavorite(any())).called(1);
      verifyNever(() => repo.removeFavorite(any()));
      // After invalidateSelf, the next read returns the updated rows.
      final after = await container.read(favoritesProvider.future);
      expect(after.single.id, '5');
    });

    test('removes when item is present', () async {
      var rows = [fav(1, identifier: '5', name: 'X')];
      when(() => repo.getAll()).thenAnswer((_) async => right(rows));
      when(() => repo.removeFavorite(any())).thenAnswer((_) async {
        rows = [];
        return right(null);
      });
      when(() => repo.addFavorite(any())).thenAnswer((_) async => right(null));

      await container.read(favoritesProvider.future);
      await container
          .read(favoritesProvider.notifier)
          .toggleFavorite(const BrowseItem(id: '5', name: 'X'));

      verify(() => repo.removeFavorite(any())).called(1);
      verifyNever(() => repo.addFavorite(any()));
    });
  });
}
