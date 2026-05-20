import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/scroll_chrome_listener.dart';
import '../providers/downloaded_artists_view_model.dart';
import 'confirm_delete_dialog.dart';

@RoutePage()
class DownloadedArtistsScreen extends ConsumerWidget {
  const DownloadedArtistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(downloadedArtistsViewModelProvider);
    final vm = ref.read(downloadedArtistsViewModelProvider.notifier);

    if (state.hasError) {
      return ErrorView(error: state.error!, onRetry: vm.refresh);
    }
    if (state.isLoading) return const LoadingView();
    if (state.isEmpty) return const _EmptyState();

    final artists = state.artists!;
    return ScrollChromeListener(
      child: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: artists.length,
            itemBuilder: (context, i) {
              final artist = artists[i];
              return _ArtistRow(
                artist: artist,
                onPlay: () => vm.playArtist(artist),
                onPlayNext: () => vm.playNextArtist(artist),
                onAdd: () => vm.addArtistToQueue(artist),
                onDelete: () => _confirmDelete(context, vm, artist),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    DownloadedArtistsViewModel vm,
    String artist,
  ) async {
    final count = await vm.trackCountForArtist(artist);
    if (count == 0 || !context.mounted) return;
    final confirmed = await showConfirmDeleteDialog(
      context: context,
      title: 'Delete downloads?',
      message: 'Delete all $count downloaded tracks for "$artist"?',
    );
    if (!confirmed) return;
    await vm.deleteArtist(artist);
  }
}

class _ArtistRow extends StatelessWidget {
  const _ArtistRow({
    required this.artist,
    required this.onPlay,
    required this.onPlayNext,
    required this.onAdd,
    required this.onDelete,
  });

  final String artist;
  final VoidCallback onPlay;
  final VoidCallback onPlayNext;
  final VoidCallback onAdd;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.router.push(DownloadedAlbumsRoute(artist: artist)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.bg3,
              ),
              alignment: Alignment.center,
              child: Text(
                artist.isNotEmpty ? artist[0].toUpperCase() : '?',
                style: AppTextStyles.avatarLetter,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(artist, style: AppTextStyles.itemTitle)),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 18,
                color: AppColors.text3,
              ),
              padding: EdgeInsets.zero,
              onSelected: (action) {
                switch (action) {
                  case 'play':
                    onPlay();
                  case 'playNext':
                    onPlayNext();
                  case 'add':
                    onAdd();
                  case 'deleteDownload':
                    onDelete();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'play',
                  child: ListTile(
                    leading: Icon(Icons.play_arrow_outlined),
                    title: Text('Play'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: 'playNext',
                  child: ListTile(
                    leading: Icon(Icons.queue_play_next),
                    title: Text('Play next'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuItem(
                  value: 'add',
                  child: ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Add to playing now'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 'deleteDownload',
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: AppColors.error),
                    title: Text(
                      'Delete downloads',
                      style: TextStyle(color: AppColors.error),
                    ),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_for_offline_outlined,
            size: 64,
            color: AppColors.text3,
          ),
          SizedBox(height: 16),
          Text('No downloads yet', style: AppTextStyles.emptyState),
          SizedBox(height: 8),
          Text(
            'Tracks you download will appear here',
            style: AppTextStyles.itemSubtitle,
          ),
        ],
      ),
    );
  }
}
