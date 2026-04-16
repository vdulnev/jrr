import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/album.dart';
import '../providers/library_providers.dart';
import 'library_action_sheet.dart';
import 'library_item_tile.dart';

@RoutePage()
class AlbumDetailScreen extends ConsumerWidget {
  final Album album;

  const AlbumDetailScreen({required this.album, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(albumTracksProvider(album));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (album.artist.isNotEmpty)
              Text(
                album.artist,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
        actions: [
          tracksState.maybeWhen(
            data: (tracks) => tracks.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    tooltip: 'Play album',
                    onPressed: () => showLibraryActionSheet(
                      context,
                      ref,
                      items: tracks,
                      title: album.name,
                    ),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: tracksState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(albumTracksProvider(album)),
        ),
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(child: Text('No tracks found'));
          }
          return ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (_, i) =>
                LibraryItemTile(item: tracks[i], trackNumber: i + 1),
          );
        },
      ),
    );
  }
}
