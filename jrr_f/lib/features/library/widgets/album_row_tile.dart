import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/artwork_widget.dart';
import '../../offline/widgets/album_download_progress_indicator.dart';
import '../../offline/widgets/confirm_delete_dialog.dart';
import '../data/models/album.dart';
import '../providers/album_row_tile_view_model.dart';

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
    final state = ref.watch(albumRowTileViewModelProvider(album));
    final vm = ref.read(albumRowTileViewModelProvider(album).notifier);

    if (state.hidden) return const SizedBox.shrink();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap:
          onTap ??
          () => state.isOffline
              ? context.router.push(
                  DownloadedAlbumDetailRoute(albumGroupId: album.albumGroupId),
                )
              : context.router.push(AlbumDetailRoute(album: album)),
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
            if (hasSubItems && !state.isOffline)
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
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: AlbumDownloadProgressIndicator(
                albumGroupId: album.albumGroupId,
              ),
            ),
            if (!state.isOffline || state.showDelete)
              PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: AppColors.text3,
                ),
                padding: EdgeInsets.zero,
                onSelected: (action) => _handleAction(context, vm, action),
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
                  if (album.folderPath.isNotEmpty && !state.isOffline)
                    const PopupMenuItem(
                      value: 'folder',
                      child: ListTile(
                        leading: Icon(Icons.folder_open_outlined),
                        title: Text('Open folder'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  const PopupMenuDivider(),
                  if (state.showDownload)
                    const PopupMenuItem(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(Icons.download_for_offline_outlined),
                        title: Text('Download album'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (state.showRetry)
                    const PopupMenuItem(
                      value: 'download',
                      child: ListTile(
                        leading: Icon(Icons.replay_outlined),
                        title: Text('Retry failed downloads'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (state.showCancel)
                    const PopupMenuItem(
                      value: 'cancelDownload',
                      child: ListTile(
                        leading: Icon(Icons.cancel_outlined),
                        title: Text('Cancel downloads'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  if (state.showDelete)
                    const PopupMenuItem(
                      value: 'deleteDownload',
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
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
    AlbumRowTileViewModel vm,
    String action,
  ) async {
    switch (action) {
      case 'folder':
        context.router.push(FolderTracksRoute(folderPath: album.folderPath));
      case 'play':
        await vm.playAlbum(album);
      case 'playNext':
        await vm.playAlbumNext(album);
      case 'add':
        await vm.addAlbumToQueue(album);
      case 'download':
        await vm.downloadAlbum(album);
      case 'cancelDownload':
        await vm.cancelAlbumDownload(album);
      case 'deleteDownload':
        final count = await vm.downloadedTrackCount(album);
        if (count == 0 || !context.mounted) return;
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Delete downloads?',
          message: 'Delete $count downloaded tracks from "${album.name}"?',
        );
        if (!confirmed) return;
        await vm.deleteAlbumDownload(album);
    }
  }
}
