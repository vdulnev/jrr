import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
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
        appBar: AppBar(title: Text(artist)),
        body: const LoadingView(),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: Text(artist)),
        body: ErrorView(
          error: e,
          onRetry: () => ref.invalidate(albumsByArtistProvider(artist)),
        ),
      ),
      data: (albums) => AlbumListScreen(
        albums: albums,
        title: artist,
        onRefresh: () => ref.invalidate(albumsByArtistProvider(artist)),
      ),
    );
  }
}
