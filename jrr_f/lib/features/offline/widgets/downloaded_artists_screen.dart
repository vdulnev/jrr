import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../library/data/models/tracks.dart';
import '../../player/providers/player_provider.dart';
import '../data/repositories/downloads_repository.dart';
import '../providers/downloaded_tracks_provider.dart';

@RoutePage()
class DownloadedArtistsScreen extends ConsumerWidget {
  const DownloadedArtistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsState = ref.watch(downloadedArtistsProvider);

    return artistsState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(downloadedArtistsProvider),
      ),
      data: (artists) {
        if (artists.isEmpty) {
          return const _EmptyState();
        }
        return ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, i) {
            final artist = artists[i];
            return _ArtistRow(artist: artist);
          },
        );
      },
    );
  }
}

class _ArtistRow extends ConsumerWidget {
  final String artist;

  const _ArtistRow({required this.artist});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              onSelected: (action) => _handleAction(context, ref, action),
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

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final downloaded = await ref.read(downloadedTracksProvider.future);
    final artistTracks = downloaded
        .where(
          (t) =>
              (t.albumArtist.isEmpty ? 'Unknown Artist' : t.albumArtist) ==
              artist,
        )
        .map((t) => t.track)
        .toList();

    if (artistTracks.isEmpty) return;

    artistTracks.sort((a, b) {
      final albumCompare = a.album.compareTo(b.album);
      if (albumCompare != 0) return albumCompare;
      final discCompare = a.discNumber.compareTo(b.discNumber);
      if (discCompare != 0) return discCompare;
      return a.trackNumber.compareTo(b.trackNumber);
    });

    final tracks = Tracks(tracks: artistTracks);

    switch (action) {
      case 'play':
        ref.read(playerProvider.notifier).playNow(tracks);
      case 'playNext':
        ref.read(playerProvider.notifier).playNext(tracks);
      case 'add':
        ref.read(playerProvider.notifier).addToQueue(tracks);
      case 'deleteDownload':
        await getIt<DownloadsRepository>().deleteAll(
          artistTracks.map((t) => t.fileKey).toList(),
        );
    }
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
