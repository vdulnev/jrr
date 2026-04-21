import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../providers/library_providers.dart';
import 'album_list_screen.dart';

@RoutePage()
class ArtistAlbumsScreen extends ConsumerWidget {
  final String artist;

  const ArtistAlbumsScreen({required this.artist, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(albumsByArtistProvider(artist));
    return state.when(
      loading: () => Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              SubScreenHeader(
                title: artist,
                subtitle: 'Artist',
                onBack: () => ref.read(navigationProvider.notifier).pop(),
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
                title: artist,
                subtitle: 'Artist',
                onBack: () => ref.read(navigationProvider.notifier).pop(),
              ),
              Expanded(
                child: ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(albumsByArtistProvider(artist)),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (albums) => AlbumListScreen(
        albums: albums,
        title: artist,
        subtitle: 'Artist',
        onRefresh: () => ref.invalidate(albumsByArtistProvider(artist)),
      ),
    );
  }
}
