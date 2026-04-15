import 'package:flutter/material.dart';

// No longer registered as a route — superseded by NowPlayingScreen.
class PlayerPlaceholderScreen extends StatelessWidget {
  const PlayerPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
