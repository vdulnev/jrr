import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/router/app_router.dart';

void main() {
  group('AppRouter route table', () {
    final router = AppRouter();

    test('defaultRouteType is material', () {
      expect(router.defaultRouteType, isA<MaterialRouteType>());
    });

    test('has a single top-level RootRoute marked initial', () {
      expect(router.routes, hasLength(1));
      final root = router.routes.single;
      expect(root.name, 'RootRoute');
      expect(root.initial, isTrue);
    });

    test('RootRoute has the expected nested children', () {
      final childNames = router.routes.single.children!.map((r) => r.name);
      expect(
        childNames,
        containsAll(<String>[
          'ServerSetupRoute',
          'ArtistsTabRouterRoute',
          'RandomTabRouterRoute',
          'BrowseTabRouterRoute',
          'FavoritesTabRouterRoute',
          'DownloadsTabRouterRoute',
          'ConnectingRoute',
        ]),
      );
    });

    test('ArtistsTabRouter exposes artists, artist albums, album & folder', () {
      final artistsRouter = router.routes.single.children!.firstWhere(
        (r) => r.name == 'ArtistsTabRouterRoute',
      );
      final childNames = artistsRouter.children!.map((r) => r.name);
      expect(
        childNames,
        containsAll(<String>[
          'ArtistsTabRoute',
          'ArtistAlbumsRoute',
          'AlbumDetailRoute',
          'FolderTracksRoute',
        ]),
      );
      final initial = artistsRouter.children!.firstWhere(
        (r) => r.initial == true,
      );
      expect(initial.name, 'ArtistsTabRoute');
    });

    test('RandomTabRouter exposes random, album, folder', () {
      final randomRouter = router.routes.single.children!.firstWhere(
        (r) => r.name == 'RandomTabRouterRoute',
      );
      final childNames = randomRouter.children!.map((r) => r.name);
      expect(
        childNames,
        containsAll(<String>[
          'RandomTabRoute',
          'AlbumDetailRoute',
          'FolderTracksRoute',
        ]),
      );
    });

    test('DownloadsTabRouter exposes artists, albums, album detail', () {
      final downloadsRouter = router.routes.single.children!.firstWhere(
        (r) => r.name == 'DownloadsTabRouterRoute',
      );
      final childNames = downloadsRouter.children!.map((r) => r.name);
      expect(
        childNames,
        containsAll(<String>[
          'DownloadedArtistsRoute',
          'DownloadedAlbumsRoute',
          'DownloadedAlbumDetailRoute',
        ]),
      );
      final initial = downloadsRouter.children!.firstWhere(
        (r) => r.initial == true,
      );
      expect(initial.name, 'DownloadedArtistsRoute');
    });

    test('ServerSetupRoute is initial inside RootRoute', () {
      final root = router.routes.single;
      final initial = root.children!.firstWhere((r) => r.initial == true);
      expect(initial.name, 'ServerSetupRoute');
    });
  });
}
