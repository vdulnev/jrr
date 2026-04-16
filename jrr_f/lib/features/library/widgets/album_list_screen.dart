import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/library_providers.dart';

@RoutePage()
class AlbumListScreen extends ConsumerWidget {
  final String artist;

  const AlbumListScreen({required this.artist, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsState = ref.watch(albumsByArtistProvider(artist));

    return Scaffold(
      appBar: AppBar(
        title: Text(artist),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
      ),
      body: albumsState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(albumsByArtistProvider(artist)),
        ),
        data: (albums) {
          if (albums.isEmpty) {
            return const Center(child: Text('No albums found'));
          }
          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (_, i) {
              final album = albums[i];
              return ListTile(
                leading: const Icon(Icons.album_outlined),
                title: Text(album.name),
                subtitle: Text(artist),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => ref
                    .read(navigationProvider.notifier)
                    .push(AlbumDetailRoute(album: album)),
              );
            },
          );
        },
      ),
    );
  }
}
