import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../providers/library_providers.dart';
import 'album_list_screen.dart';

@RoutePage()
class RandomAlbumsScreen extends ConsumerWidget {
  const RandomAlbumsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(randomAlbumsProvider);
    return state.when(
      loading: () => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SubScreenHeader(
                title: 'Random Albums',
                subtitle: 'Library',
                onBack: () => ref.read(libraryNavProvider.notifier).pop(),
              ),
              const Expanded(child: LoadingView()),
            ],
          ),
        ),
      ),
      error: (e, _) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SubScreenHeader(
                title: 'Random Albums',
                subtitle: 'Library',
                onBack: () => ref.read(libraryNavProvider.notifier).pop(),
              ),
              Expanded(
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(randomAlbumsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (albums) => AlbumListScreen(
        albums: albums,
        title: 'Random Albums',
        subtitle: 'Library',
        onBack: () => ref.read(libraryNavProvider.notifier).pop(),
        onRefresh: () => ref.invalidate(randomAlbumsProvider),
      ),
    );
  }
}
