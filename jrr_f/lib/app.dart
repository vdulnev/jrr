import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  late final AppRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'JRiver Remote',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0066CC),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: _router.config(),
    );
  }
}
