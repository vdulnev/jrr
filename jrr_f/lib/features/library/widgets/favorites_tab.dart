import 'package:flutter/material.dart';
import '../../favorites/widgets/favorites_screen.dart';

/// Wrapper for the Favorites section when used as a tab in the Library.
class FavoritesTab extends StatelessWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const FavoritesScreen();
  }
}
