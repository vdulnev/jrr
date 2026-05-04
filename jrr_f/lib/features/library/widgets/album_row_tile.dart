import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/artwork_widget.dart';
import '../../player/providers/player_provider.dart';
import '../data/models/album.dart';
import '../providers/library_providers.dart';

class AlbumRowTile extends ConsumerWidget {
  final Album album;
  final bool showArtist;
  final double indent;
  final String? titleOverride;
  final VoidCallback? onTap;
  final bool hasSubItems;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const AlbumRowTile({
    required this.album,
    this.showArtist = true,
    this.indent = 0,
    this.titleOverride,
    this.onTap,
    this.hasSubItems = false,
    this.isExpanded = false,
    this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap ?? () => context.router.push(AlbumDetailRoute(album: album)),
      child: Container(
        padding: EdgeInsets.fromLTRB(20 + indent, 12, 20, 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ArtworkWidget(
                fileKey: album.artworkFileKey,
                size: indent > 0 ? 32 : 48,
              ),
            ),
            SizedBox(width: indent > 0 ? 10 : 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleOverride ??
                        [
                          album.date,
                          album.name,
                          if (album.totalDiscs > 1 && album.discNumber > 0)
                            'Disc ${album.discNumber}/${album.totalDiscs}',
                        ].where((s) => s.isNotEmpty).join(' - '),
                    style: indent > 0
                        ? AppTextStyles.labelLarge
                        : AppTextStyles.itemTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    showArtist ? album.albumArtist : album.folderPath,
                    style: AppTextStyles.itemSubtitle,
                    maxLines: showArtist ? 1 : (indent > 0 ? 1 : null),
                    overflow: showArtist
                        ? TextOverflow.ellipsis
                        : (indent > 0
                            ? TextOverflow.ellipsis
                            : TextOverflow.visible),
                    softWrap: !showArtist && indent == 0,
                  ),
                ],
              ),
            ),
            if (hasSubItems)
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 20,
                  color: AppColors.text3,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onToggle,
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
      context.router.push(FolderTracksRoute(folderPath: album.folderPath));
      return;
    }

    final tracks = await ref.read(albumTracksProvider(album).future);

    switch (action) {
      case 'play':
        ref.read(playerProvider.notifier).playNow(tracks);
      case 'playNext':
        ref.read(playerProvider.notifier).playNext(tracks);
      case 'add':
        ref.read(playerProvider.notifier).addToQueue(tracks);
    }
    ref.read(playerProvider.notifier).refresh();
  }
}
