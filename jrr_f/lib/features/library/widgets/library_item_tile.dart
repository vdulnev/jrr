import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../offline/data/models/download_state.dart';
import '../../offline/widgets/confirm_delete_dialog.dart';
import '../../offline/widgets/download_progress_indicator.dart';
import '../data/models/track.dart';
import '../providers/library_item_tile_view_model.dart';

class LibraryItemTile extends ConsumerStatefulWidget {
  final Track item;
  final int? trackNumber;
  final bool collapsedByDefault;

  const LibraryItemTile({
    required this.item,
    this.trackNumber,
    this.collapsedByDefault = false,
    super.key,
  });

  @override
  ConsumerState<LibraryItemTile> createState() => _LibraryItemTileState();
}

class _LibraryItemTileState extends ConsumerState<LibraryItemTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final state = ref.watch(libraryItemTileViewModelProvider(item.fileKey));
    final vm = ref.read(
      libraryItemTileViewModelProvider(item.fileKey).notifier,
    );

    final displayTrackNumber =
        widget.trackNumber ?? (item.trackNumber > 0 ? item.trackNumber : null);

    return ListTile(
      leading: displayTrackNumber != null
          ? SizedBox(
              width: 32,
              child: Text(
                '$displayTrackNumber',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : null,
      title: Text(
        item.name.isNotEmpty ? item.name : 'Unknown',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            [
              [
                item.dateReadable,
                item.album,
              ].where((s) => s.isNotEmpty).join(' - '),
              item.artist,
            ].where((s) => s.isNotEmpty).join(' · '),
            style: AppTextStyles.itemSubtitle,
          ),
          if (_expanded) ...[
            const SizedBox(height: 4),
            Text(
              item.folderPath,
              style: AppTextStyles.monoLabel.copyWith(color: AppColors.accent),
            ),
            const SizedBox(height: 2),
            Text(
              item.filePath,
              style: AppTextStyles.monoLabel.copyWith(
                fontSize: 10,
                color: AppColors.text3,
              ),
            ),
          ],
        ],
      ),
      onTap: () => setState(() => _expanded = !_expanded),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DownloadProgressIndicator(fileKey: item.fileKey),
          const SizedBox(width: 4),
          if (state.hideMenu)
            const SizedBox(width: 18)
          else
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                size: 18,
                color: AppColors.text3,
              ),
              padding: EdgeInsets.zero,
              onSelected: (action) => _handleAction(action, item, vm),
              itemBuilder: (context) => [
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
                const PopupMenuDivider(),
                if (!state.isOffline &&
                    state.downloadState == DownloadState.notDownloaded)
                  const PopupMenuItem(
                    value: 'download',
                    child: ListTile(
                      leading: Icon(Icons.download_for_offline_outlined),
                      title: Text('Download'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                if (!state.isOffline &&
                    (state.downloadState == DownloadState.queued ||
                        state.downloadState == DownloadState.running))
                  const PopupMenuItem(
                    value: 'cancelDownload',
                    child: ListTile(
                      leading: Icon(Icons.cancel_outlined),
                      title: Text('Cancel download'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                if (state.downloadState == DownloadState.downloaded)
                  const PopupMenuItem(
                    value: 'deleteDownload',
                    child: ListTile(
                      leading: Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      title: Text(
                        'Delete download',
                        style: TextStyle(color: AppColors.error),
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                if (!state.isOffline &&
                    state.downloadState == DownloadState.failed)
                  const PopupMenuItem(
                    value: 'download',
                    child: ListTile(
                      leading: Icon(Icons.replay_outlined),
                      title: Text('Retry download'),
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _handleAction(
    String action,
    Track item,
    LibraryItemTileViewModel vm,
  ) async {
    switch (action) {
      case 'play':
        await vm.playNow(item);
      case 'playNext':
        await vm.playNext(item);
      case 'add':
        await vm.addToQueue(item);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to playing now'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      case 'download':
        vm.enqueueDownload(item);
      case 'cancelDownload':
        vm.cancelDownload(item.fileKey);
      case 'deleteDownload':
        if (!context.mounted) return;
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Delete Download',
          message: 'Delete downloaded track "${item.name}"?',
        );
        if (confirmed) {
          await vm.deleteDownload(item.fileKey);
        }
    }
  }
}
