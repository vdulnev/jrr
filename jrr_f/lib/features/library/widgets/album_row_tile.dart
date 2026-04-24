import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/album.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';

class AlbumRowTile extends ConsumerWidget {
  final Album album;
  final bool showArtist;

  const AlbumRowTile({required this.album, this.showArtist = true, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref
          .read(libraryNavProvider.notifier)
          .push(AlbumDetailRoute(album: album)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            // Album art placeholder
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.bg3,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.album,
                size: 24,
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    [
                      album.date,
                      album.name,
                    ].where((s) => s.isNotEmpty).join(' - '),
                    style: AppTextStyles.itemTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (showArtist) ...[
                        Flexible(
                          child: Text(
                            album.artist,
                            style: AppTextStyles.itemSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (album.trackCount > 0)
                          const Text(
                            '  \u00b7  ',
                            style: AppTextStyles.itemSubtitle,
                          ),
                      ],
                      if (album.trackCount > 0)
                        Text(
                          '${album.trackCount} tracks',
                          style: AppTextStyles.monoLabel,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 18,
                color: AppColors.text3,
              ),
              padding: EdgeInsets.zero,
              onSelected: (action) => _handleAction(context, ref, action),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'play',
                  child: ListTile(
                    leading: Icon(Icons.play_arrow_outlined),
                    title: Text('Play'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuItem(
                  value: 'playNext',
                  child: ListTile(
                    leading: Icon(Icons.queue_play_next),
                    title: Text('Play next'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const PopupMenuItem(
                  value: 'add',
                  child: ListTile(
                    leading: Icon(Icons.add_circle_outline),
                    title: Text('Add to playing now'),
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                if (album.folderPath.isNotEmpty)
                  const PopupMenuItem(
                    value: 'folder',
                    child: ListTile(
                      leading: Icon(Icons.folder_open_outlined),
                      title: Text('Open folder'),
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
    if (action == 'folder') {
      ref
          .read(navigationProvider.notifier)
          .push(FolderTracksRoute(folderPath: album.folderPath));
      return;
    }

    final tracks = await ref.read(albumTracksProvider(album).future);
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;

    final keys = tracks.map((t) => t.fileKey).toList();
    final repo = getIt<LibraryRepository>();

    switch (action) {
      case 'play':
        repo.playNow(zone.id, keys);
      case 'playNext':
        repo.playNext(zone.id, keys);
      case 'add':
        repo.addToQueue(zone.id, keys);
    }
    ref.read(playerProvider.notifier).refresh();
  }
}
