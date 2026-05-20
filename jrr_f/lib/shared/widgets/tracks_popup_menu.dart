import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../features/library/data/models/tracks.dart';
import 'tracks_popup_menu_view_model.dart';

class TracksPopupMenu extends ConsumerWidget {
  final Tracks tracks;
  final String? label;

  const TracksPopupMenu({required this.tracks, this.label, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tracksPopupMenuViewModelProvider(tracks));
    final vm = ref.read(tracksPopupMenuViewModelProvider(tracks).notifier);

    if (state.hidden) return const SizedBox(width: 18);

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.text3),
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
        const PopupMenuDivider(),
        if (state.showDownload)
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(Icons.download_for_offline_outlined),
              title: Text('Download all'),
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
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    TracksPopupMenuViewModel vm,
    String action,
  ) async {
    switch (action) {
      case 'play':
        await vm.playNow(tracks);
      case 'playNext':
        await vm.playNext(tracks);
      case 'add':
        await vm.addToQueue(tracks);
        if (label != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "$label" to playing now'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      case 'download':
        await vm.downloadTracks(tracks);
        if (label != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloading "$label"'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      case 'cancelDownload':
        await vm.cancelDownloads(tracks);
      case 'deleteDownload':
        await vm.deleteDownloads(tracks);
    }
  }
}
