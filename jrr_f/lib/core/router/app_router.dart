import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/connection/widgets/connecting_screen.dart';
import '../../features/connection/widgets/server_setup_screen.dart';
import '../../features/library/data/models/album.dart';
import '../../features/library/widgets/album_detail_screen.dart';
import '../../features/library/widgets/artist_albums_screen.dart';
import '../../features/library/widgets/artists_tab.dart';
import '../../features/library/widgets/browse_tab.dart';
import '../../features/library/widgets/favorites_tab.dart';
import '../../features/library/widgets/folder_tracks_screen.dart';
import '../../features/library/widgets/library_tab_routers.dart';
import '../../features/library/widgets/random_tab.dart';
import 'root_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: RootRoute.page,
      initial: true,
      children: [
        AutoRoute(page: ServerSetupRoute.page, initial: true),
        AutoRoute(
          page: ArtistsTabRouterRoute.page,
          children: [
            AutoRoute(page: ArtistsTabRoute.page, initial: true),
            AutoRoute(page: ArtistAlbumsRoute.page),
            AutoRoute(page: AlbumDetailRoute.page),
            AutoRoute(page: FolderTracksRoute.page),
          ],
        ),
        AutoRoute(
          page: RandomTabRouterRoute.page,
          children: [
            AutoRoute(page: RandomTabRoute.page, initial: true),
            AutoRoute(page: AlbumDetailRoute.page),
            AutoRoute(page: FolderTracksRoute.page),
          ],
        ),
        AutoRoute(
          page: BrowseTabRouterRoute.page,
          children: [AutoRoute(page: BrowseTabRoute.page, initial: true)],
        ),
        AutoRoute(
          page: FavoritesTabRouterRoute.page,
          children: [AutoRoute(page: FavoritesTabRoute.page, initial: true)],
        ),
        AutoRoute(page: ConnectingRoute.page),
      ],
    ),
  ];
}
