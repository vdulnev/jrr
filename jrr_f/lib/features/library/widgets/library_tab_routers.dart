import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ArtistsTabRouterScreen extends StatelessWidget {
  const ArtistsTabRouterScreen({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}

@RoutePage()
class RandomTabRouterScreen extends StatelessWidget {
  const RandomTabRouterScreen({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}

@RoutePage()
class BrowseTabRouterScreen extends StatelessWidget {
  const BrowseTabRouterScreen({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}

@RoutePage()
class FavoritesTabRouterScreen extends StatelessWidget {
  const FavoritesTabRouterScreen({super.key});

  @override
  Widget build(BuildContext context) => const AutoRouter();
}
