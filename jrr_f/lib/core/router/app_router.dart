import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/connection/widgets/connecting_screen.dart';
import '../../features/connection/widgets/server_setup_screen.dart';
import '../../features/player/widgets/now_playing_screen.dart';
import '../../features/zones/widgets/zone_list_screen.dart';
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
        AutoRoute(page: ServerSetupRoute.page),
        AutoRoute(page: NowPlayingRoute.page),
        AutoRoute(page: ZoneListRoute.page),
        AutoRoute(page: ConnectingRoute.page),
      ],
    ),
  ];
}
