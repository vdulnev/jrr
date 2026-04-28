// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AlbumDetailScreen]
class AlbumDetailRoute extends PageRouteInfo<AlbumDetailRouteArgs> {
  AlbumDetailRoute({
    required Album album,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AlbumDetailRoute.name,
         args: AlbumDetailRouteArgs(album: album, key: key),
         initialChildren: children,
       );

  static const String name = 'AlbumDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AlbumDetailRouteArgs>();
      return AlbumDetailScreen(album: args.album, key: args.key);
    },
  );
}

class AlbumDetailRouteArgs {
  const AlbumDetailRouteArgs({required this.album, this.key});

  final Album album;

  final Key? key;

  @override
  String toString() {
    return 'AlbumDetailRouteArgs{album: $album, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumDetailRouteArgs) return false;
    return album == other.album && key == other.key;
  }

  @override
  int get hashCode => album.hashCode ^ key.hashCode;
}

/// generated route for
/// [ArtistAlbumsScreen]
class ArtistAlbumsRoute extends PageRouteInfo<ArtistAlbumsRouteArgs> {
  ArtistAlbumsRoute({
    required String artist,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         ArtistAlbumsRoute.name,
         args: ArtistAlbumsRouteArgs(artist: artist, key: key),
         initialChildren: children,
       );

  static const String name = 'ArtistAlbumsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ArtistAlbumsRouteArgs>();
      return ArtistAlbumsScreen(artist: args.artist, key: args.key);
    },
  );
}

class ArtistAlbumsRouteArgs {
  const ArtistAlbumsRouteArgs({required this.artist, this.key});

  final String artist;

  final Key? key;

  @override
  String toString() {
    return 'ArtistAlbumsRouteArgs{artist: $artist, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ArtistAlbumsRouteArgs) return false;
    return artist == other.artist && key == other.key;
  }

  @override
  int get hashCode => artist.hashCode ^ key.hashCode;
}

/// generated route for
/// [ArtistsTabRouterScreen]
class ArtistsTabRouterRoute extends PageRouteInfo<void> {
  const ArtistsTabRouterRoute({List<PageRouteInfo>? children})
    : super(ArtistsTabRouterRoute.name, initialChildren: children);

  static const String name = 'ArtistsTabRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ArtistsTabRouterScreen();
    },
  );
}

/// generated route for
/// [ArtistsTabScreen]
class ArtistsTabRoute extends PageRouteInfo<void> {
  const ArtistsTabRoute({List<PageRouteInfo>? children})
    : super(ArtistsTabRoute.name, initialChildren: children);

  static const String name = 'ArtistsTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ArtistsTabScreen();
    },
  );
}

/// generated route for
/// [BrowseTabRouterScreen]
class BrowseTabRouterRoute extends PageRouteInfo<void> {
  const BrowseTabRouterRoute({List<PageRouteInfo>? children})
    : super(BrowseTabRouterRoute.name, initialChildren: children);

  static const String name = 'BrowseTabRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BrowseTabRouterScreen();
    },
  );
}

/// generated route for
/// [BrowseTabScreen]
class BrowseTabRoute extends PageRouteInfo<void> {
  const BrowseTabRoute({List<PageRouteInfo>? children})
    : super(BrowseTabRoute.name, initialChildren: children);

  static const String name = 'BrowseTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const BrowseTabScreen();
    },
  );
}

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
/// [FavoritesTabRouterScreen]
class FavoritesTabRouterRoute extends PageRouteInfo<void> {
  const FavoritesTabRouterRoute({List<PageRouteInfo>? children})
    : super(FavoritesTabRouterRoute.name, initialChildren: children);

  static const String name = 'FavoritesTabRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesTabRouterScreen();
    },
  );
}

/// generated route for
/// [FavoritesTabScreen]
class FavoritesTabRoute extends PageRouteInfo<void> {
  const FavoritesTabRoute({List<PageRouteInfo>? children})
    : super(FavoritesTabRoute.name, initialChildren: children);

  static const String name = 'FavoritesTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FavoritesTabScreen();
    },
  );
}

/// generated route for
/// [FolderTracksScreen]
class FolderTracksRoute extends PageRouteInfo<FolderTracksRouteArgs> {
  FolderTracksRoute({
    required String folderPath,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         FolderTracksRoute.name,
         args: FolderTracksRouteArgs(folderPath: folderPath, key: key),
         initialChildren: children,
       );

  static const String name = 'FolderTracksRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<FolderTracksRouteArgs>();
      return FolderTracksScreen(folderPath: args.folderPath, key: args.key);
    },
  );
}

class FolderTracksRouteArgs {
  const FolderTracksRouteArgs({required this.folderPath, this.key});

  final String folderPath;

  final Key? key;

  @override
  String toString() {
    return 'FolderTracksRouteArgs{folderPath: $folderPath, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FolderTracksRouteArgs) return false;
    return folderPath == other.folderPath && key == other.key;
  }

  @override
  int get hashCode => folderPath.hashCode ^ key.hashCode;
}

/// generated route for
/// [RandomTabRouterScreen]
class RandomTabRouterRoute extends PageRouteInfo<void> {
  const RandomTabRouterRoute({List<PageRouteInfo>? children})
    : super(RandomTabRouterRoute.name, initialChildren: children);

  static const String name = 'RandomTabRouterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RandomTabRouterScreen();
    },
  );
}

/// generated route for
/// [RandomTabScreen]
class RandomTabRoute extends PageRouteInfo<void> {
  const RandomTabRoute({List<PageRouteInfo>? children})
    : super(RandomTabRoute.name, initialChildren: children);

  static const String name = 'RandomTabRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RandomTabScreen();
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
