import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/data/models/albums.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/library/data/repositories/library_repository.dart';
import 'package:jrr_f/features/library/providers/library_providers.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockLibraryRepo extends Mock implements LibraryRepository {}

class FakeAlbum extends Fake implements Album {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAlbum());
  });

  late MockLibraryRepo repo;

  ProviderContainer open({bool isOffline = false}) {
    repo = MockLibraryRepo();
    final container = ProviderContainer(
      overrides: [
        libraryRepositoryProvider.overrideWithValue(repo),
        talkerProvider.overrideWithValue(Talker()),
        isOfflineActiveProvider.overrideWith((ref) => isOffline),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('LibraryChromeVisibleNotifier', () {
    test('starts visible and toggles via set()', () {
      final c = open();
      expect(c.read(libraryChromeVisibleProvider), isTrue);
      c.read(libraryChromeVisibleProvider.notifier).set(false);
      expect(c.read(libraryChromeVisibleProvider), isFalse);
      // Setting to the same value is a no-op.
      c.read(libraryChromeVisibleProvider.notifier).set(false);
      expect(c.read(libraryChromeVisibleProvider), isFalse);
      c.read(libraryChromeVisibleProvider.notifier).set(true);
      expect(c.read(libraryChromeVisibleProvider), isTrue);
    });
  });

  group('librarySearch', () {
    test('returns empty for whitespace-only query', () async {
      final c = open();
      expect(await c.read(librarySearchProvider('   ').future), Tracks.empty);
      verifyNever(() => repo.search(any()));
    });

    test('returns empty in offline mode', () async {
      final c = open(isOffline: true);
      expect(await c.read(librarySearchProvider('foo').future), Tracks.empty);
      verifyNever(() => repo.search(any()));
    });

    test('delegates to the repository when online with a real query', () async {
      final c = open();
      final tracks = Tracks.fromList(const [Track(fileKey: 1)]);
      when(() => repo.search('foo')).thenAnswer((_) async => right(tracks));
      expect(await c.read(librarySearchProvider('foo').future), tracks);
    });
  });

  group('artists', () {
    test('returns empty in offline mode', () async {
      final c = open(isOffline: true);
      expect(await c.read(artistsProvider.future), isEmpty);
    });

    test('delegates to the repository when online', () async {
      final c = open();
      when(() => repo.getArtists()).thenAnswer((_) async => right(['A', 'B']));
      expect(await c.read(artistsProvider.future), ['A', 'B']);
    });
  });

  group('albumsByArtist + albumGroupsByArtist', () {
    Album album({
      String name = 'X',
      int disc = 0,
      int totalDiscs = 0,
      String parent = '',
      String date = '',
    }) => Album(
      name: name,
      albumArtist: 'A',
      folderPath: parent.isEmpty ? '' : '$parent$name/',
      parentFolderPath: parent,
      albumGroupId: '${name.toLowerCase()}|$parent',
      discNumber: disc,
      totalDiscs: totalDiscs,
      date: date,
    );

    test('returns empty in offline mode', () async {
      final c = open(isOffline: true);
      expect(await c.read(albumsByArtistProvider('A').future), Albums.empty);
    });

    test('groups multi-disc albums while leaving singles flat', () async {
      final c = open();
      when(() => repo.getAlbumsByArtist('A')).thenAnswer(
        (_) async => right(
          Albums(
            albums: [
              album(
                name: 'Multi',
                disc: 1,
                totalDiscs: 2,
                parent: '/m/',
                date: '2020',
              ),
              album(
                name: 'Multi',
                disc: 2,
                totalDiscs: 2,
                parent: '/m/',
                date: '2020',
              ),
              album(name: 'Single', date: '2019'),
            ],
          ),
        ),
      );

      final groups = await c.read(albumGroupsByArtistProvider('A').future);
      expect(groups, hasLength(2));
      final multi = groups.firstWhere((g) => g.album.name == 'Multi');
      expect(multi.isMultiDisc, isTrue);
      expect(multi.discs.length, 2);
      final single = groups.firstWhere((g) => g.album.name == 'Single');
      expect(single.isMultiDisc, isFalse);
    });
  });

  group('albumTracks / folderTracks / randomAlbums', () {
    test('all return empty in offline mode', () async {
      final c = open(isOffline: true);
      const album = Album(
        name: 'A',
        albumArtist: 'X',
        folderPath: '/a/',
        parentFolderPath: '/',
        albumGroupId: 'a|/',
      );
      expect(await c.read(albumTracksProvider(album).future), Tracks.empty);
      expect(await c.read(folderTracksProvider('/x').future), Tracks.empty);
      expect(await c.read(randomAlbumsProvider.future), Albums.empty);
    });

    test('delegate to the repository when online', () async {
      final c = open();
      const album = Album(
        name: 'A',
        albumArtist: 'X',
        folderPath: '/a/',
        parentFolderPath: '/',
        albumGroupId: 'a|/',
      );
      when(
        () => repo.getAlbumTracks(album),
      ).thenAnswer((_) async => right(Tracks.empty));
      when(
        () => repo.getTracksByFolder('/x/'),
      ).thenAnswer((_) async => right(Tracks.empty));
      when(
        () => repo.getRandomAlbums(),
      ).thenAnswer((_) async => right(Albums.empty));

      await c.read(albumTracksProvider(album).future);
      await c.read(folderTracksProvider('/x/').future);
      await c.read(randomAlbumsProvider.future);

      verify(() => repo.getAlbumTracks(album)).called(1);
      verify(() => repo.getTracksByFolder('/x/')).called(1);
      verify(() => repo.getRandomAlbums()).called(1);
    });
  });

  group('browseChildren / browseFiles', () {
    test('return empty in offline mode', () async {
      final c = open(isOffline: true);
      expect(await c.read(browseChildrenProvider('-1').future), isEmpty);
      expect(await c.read(browseFilesProvider('-1').future), Tracks.empty);
    });

    test('delegate to the repository when online', () async {
      final c = open();
      when(
        () => repo.browseChildren('1'),
      ).thenAnswer((_) async => right(const [BrowseItem(id: '2', name: 'X')]));
      when(
        () => repo.browseFiles('1'),
      ).thenAnswer((_) async => right(Tracks.empty));

      final items = await c.read(browseChildrenProvider('1').future);
      expect(items.single.id, '2');
      final tracks = await c.read(browseFilesProvider('1').future);
      expect(tracks, Tracks.empty);
    });
  });

  group('searchByFileKey', () {
    test('online branch reads from repository', () async {
      final c = open();
      when(
        () => repo.searchByFileKey(42),
      ).thenAnswer((_) async => right(const Track(fileKey: 42)));
      final track = await c.read(searchByFileKeyProvider(42).future);
      expect(track?.fileKey, 42);
    });

    test('online error path propagates as AsyncError', () async {
      final c = open();
      when(
        () => repo.searchByFileKey(any()),
      ).thenAnswer((_) async => left(const AppException.unauthorized()));
      final sub = c.listen(searchByFileKeyProvider(99), (_, _) {});
      addTearDown(sub.close);
      for (var i = 0; i < 20; i++) {
        if (c.read(searchByFileKeyProvider(99)).hasError) break;
        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
      expect(
        c.read(searchByFileKeyProvider(99)).error,
        isA<UnauthorizedException>(),
      );
    });
  });

  group('BrowseNavigationStack', () {
    test('seeded with the root for the browse scope', () {
      final c = open();
      final state = c.read(browseNavigationStackProvider(BrowseScope.browse));
      expect(state.single.id, '-1');
      expect(state.single.name, 'Browse');
    });

    test('seeded empty for the favorites scope', () {
      final c = open();
      final state = c.read(
        browseNavigationStackProvider(BrowseScope.favorites),
      );
      expect(state, isEmpty);
    });

    test('push / pop / reset / navigateToBreadcrumb manage the stack', () {
      final c = open();
      final notifier = c.read(
        browseNavigationStackProvider(BrowseScope.browse).notifier,
      );
      notifier.push(const BrowseItem(id: 'a', name: 'A'));
      notifier.push(const BrowseItem(id: 'b', name: 'B'));
      notifier.push(const BrowseItem(id: 'c', name: 'C'));
      expect(
        c
            .read(browseNavigationStackProvider(BrowseScope.browse))
            .map((i) => i.id),
        ['-1', 'a', 'b', 'c'],
      );

      notifier.pop();
      expect(
        c
            .read(browseNavigationStackProvider(BrowseScope.browse))
            .map((i) => i.id),
        ['-1', 'a', 'b'],
      );

      notifier.navigateToBreadcrumb(0);
      expect(
        c
            .read(browseNavigationStackProvider(BrowseScope.browse))
            .map((i) => i.id),
        ['-1'],
      );

      notifier.navigateToBreadcrumb(-1);
      expect(
        c.read(browseNavigationStackProvider(BrowseScope.browse)),
        isEmpty,
      );

      notifier.push(const BrowseItem(id: 'x', name: 'X'));
      notifier.reset();
      expect(
        c.read(browseNavigationStackProvider(BrowseScope.browse)),
        isEmpty,
      );

      // pop on empty stack is a no-op.
      notifier.pop();
      expect(
        c.read(browseNavigationStackProvider(BrowseScope.browse)),
        isEmpty,
      );
    });
  });
}
