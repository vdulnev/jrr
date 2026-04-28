import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'browse_screen.dart';

@RoutePage()
class BrowseTabScreen extends StatelessWidget {
  const BrowseTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrowseTreeView();
  }
}
