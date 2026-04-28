import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../favorites/widgets/favorites_screen.dart';

@RoutePage()
class FavoritesTabScreen extends StatelessWidget {
  const FavoritesTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesScreen();
  }
}
