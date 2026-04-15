// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ConnectingScreen]
class ConnectingRoute extends PageRouteInfo<ConnectingRouteArgs> {
  ConnectingRoute({Key? key, String? address, List<PageRouteInfo>? children})
    : super(
        ConnectingRoute.name,
        args: ConnectingRouteArgs(key: key, address: address),
        initialChildren: children,
      );

  static const String name = 'ConnectingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConnectingRouteArgs>(
        orElse: () => const ConnectingRouteArgs(),
      );
      return ConnectingScreen(key: args.key, address: args.address);
    },
  );
}

class ConnectingRouteArgs {
  const ConnectingRouteArgs({this.key, this.address});

  final Key? key;

  final String? address;

  @override
  String toString() {
    return 'ConnectingRouteArgs{key: $key, address: $address}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ConnectingRouteArgs) return false;
    return key == other.key && address == other.address;
  }

  @override
  int get hashCode => key.hashCode ^ address.hashCode;
}

/// generated route for
/// [NowPlayingScreen]
class NowPlayingRoute extends PageRouteInfo<void> {
  const NowPlayingRoute({List<PageRouteInfo>? children})
    : super(NowPlayingRoute.name, initialChildren: children);

  static const String name = 'NowPlayingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NowPlayingScreen();
    },
  );
}

/// generated route for
/// [QueueScreen]
class QueueRoute extends PageRouteInfo<void> {
  const QueueRoute({List<PageRouteInfo>? children})
    : super(QueueRoute.name, initialChildren: children);

  static const String name = 'QueueRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const QueueScreen();
    },
  );
}

/// generated route for
/// [RootScreen]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RootScreen();
    },
  );
}

/// generated route for
/// [ServerSetupScreen]
class ServerSetupRoute extends PageRouteInfo<void> {
  const ServerSetupRoute({List<PageRouteInfo>? children})
    : super(ServerSetupRoute.name, initialChildren: children);

  static const String name = 'ServerSetupRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ServerSetupScreen();
    },
  );
}

/// generated route for
/// [ZoneListScreen]
class ZoneListRoute extends PageRouteInfo<void> {
  const ZoneListRoute({List<PageRouteInfo>? children})
    : super(ZoneListRoute.name, initialChildren: children);

  static const String name = 'ZoneListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ZoneListScreen();
    },
  );
}
