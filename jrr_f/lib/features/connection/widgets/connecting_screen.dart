import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/loading_view.dart';

@RoutePage()
class ConnectingScreen extends StatelessWidget {
  final String address;

  const ConnectingScreen({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoadingView(message: 'Connecting to $address…'));
  }
}
