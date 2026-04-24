import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../providers/library_providers.dart';

/// Wrapper for the Library tab that supports nested navigation.
@RoutePage()
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navStack = ref.watch(libraryNavProvider);

    return AutoRouter.declarative(
      routes: (_) => [const LibraryRootRoute(), ...navStack],
    );
  }
}
