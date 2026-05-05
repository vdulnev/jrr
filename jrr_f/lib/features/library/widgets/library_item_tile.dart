import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/theme/app_theme.dart';
import '../../offline/data/models/download_state.dart';
import '../../offline/data/repositories/downloads_repository.dart';
import '../../offline/providers/download_status_provider.dart';
import '../../offline/widgets/confirm_delete_dialog.dart';
import '../../offline/widgets/download_progress_indicator.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/track.dart';
import '../data/models/tracks.dart';

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
            ].where((s) => s.isNotEmpty).join(' \u00b7 '),
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
          Consumer(
            builder: (context, ref, child) {
              final isOffline = ref.watch(isOfflineActiveProvider);
              final downloadState = ref.watch(
                downloadStatusProvider(item.fileKey),
              );

              if (isOffline && downloadState != DownloadState.downloaded) {
                return const SizedBox(width: 18); // Placeholder for alignment
              }

              return PopupMenuButton<String>(
                icon: const Icon(
                  Icons.more_vert,
                  size: 18,
                  color: AppColors.text3,
                ),
                padding: EdgeInsets.zero,
                onSelected: (action) => _handleAction(action, item),
                itemBuilder: (context) {
                  return [
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
                    if (!isOffline &&
                        downloadState == DownloadState.notDownloaded)
                      const PopupMenuItem(
                        value: 'download',
                        child: ListTile(
                          leading: Icon(Icons.download_for_offline_outlined),
                          title: Text('Download'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    if (!isOffline &&
                        (downloadState == DownloadState.queued ||
                            downloadState == DownloadState.running))
                      const PopupMenuItem(
                        value: 'cancelDownload',
                        child: ListTile(
                          leading: Icon(Icons.cancel_outlined),
                          title: Text('Cancel download'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    if (downloadState == DownloadState.downloaded)
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
                    if (!isOffline && downloadState == DownloadState.failed)
                      const PopupMenuItem(
                        value: 'download',
                        child: ListTile(
                          leading: Icon(Icons.replay_outlined),
                          title: Text('Retry download'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ];
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(String action, Track item) async {
    final tracks = Tracks(tracks: [item]);
    final downloadsRepo = getIt<DownloadsRepository>();

    switch (action) {
      case 'play':
        ref.read(playerProvider.notifier).playNow(tracks);
      case 'playNext':
        ref.read(playerProvider.notifier).playNext(tracks);
      case 'add':
        ref.read(playerProvider.notifier).addToQueue(tracks);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to playing now'),
              duration: Duration(seconds: 1),
            ),
          );
        }
      case 'download':
        downloadsRepo.enqueue(item);
      case 'cancelDownload':
        downloadsRepo.cancel(item.fileKey);
      case 'deleteDownload':
        if (!mounted) return;
        final confirmed = await showConfirmDeleteDialog(
          context: context,
          title: 'Delete download?',
          message: 'Delete the downloaded copy of "${item.name}"?',
        );
        if (!confirmed) return;
        await downloadsRepo.delete(item.fileKey);
    }
  }
}
