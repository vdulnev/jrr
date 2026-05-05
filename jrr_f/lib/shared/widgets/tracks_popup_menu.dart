import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../features/library/data/models/tracks.dart';
import '../../features/offline/data/repositories/downloads_repository.dart';
import '../../features/player/providers/player_provider.dart';
import '../../features/zones/providers/active_zone_provider.dart';

import '../../features/offline/data/models/download_state.dart';
import '../../features/offline/providers/download_jobs_provider.dart';
import '../../features/offline/providers/downloaded_tracks_provider.dart';

class TracksPopupMenu extends ConsumerWidget {
  final Tracks tracks;
  final String? label;

  const TracksPopupMenu({required this.tracks, this.label, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(isOfflineActiveProvider);
    final downloadedTracks = ref.watch(downloadedTracksProvider).value ?? [];
    final downloadJobs = ref.watch(downloadJobsProvider).value ?? [];

    final trackKeys = tracks.tracks.map((t) => t.fileKey).toSet();

    final downloadedKeys = downloadedTracks
        .where((t) => trackKeys.contains(t.fileKey))
        .map((t) => t.fileKey)
        .toSet();

    if (isOffline && downloadedKeys.isEmpty) {
      return const SizedBox(width: 18);
    }

    final jobsForTracks = downloadJobs.where(
      (j) => trackKeys.contains(j.fileKey),
    );

    final activeJobs = jobsForTracks.where(
      (j) =>
          j.state == DownloadState.queued || j.state == DownloadState.running,
    );
    final failedJobs = jobsForTracks.where(
      (j) => j.state == DownloadState.failed,
    );

    final showDownload =
        !isOffline &&
        downloadedKeys.length < tracks.length &&
        activeJobs.isEmpty;
    final showCancel = !isOffline && activeJobs.isNotEmpty;
    final showDelete = downloadedKeys.isNotEmpty;
    final showRetry = !isOffline && failedJobs.isNotEmpty && activeJobs.isEmpty;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.text3),
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
        const PopupMenuDivider(),
        if (showDownload)
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(Icons.download_for_offline_outlined),
              title: Text('Download all'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (showRetry)
          const PopupMenuItem(
            value: 'download',
            child: ListTile(
              leading: Icon(Icons.replay_outlined),
              title: Text('Retry failed downloads'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (showCancel)
          const PopupMenuItem(
            value: 'cancelDownload',
            child: ListTile(
              leading: Icon(Icons.cancel_outlined),
              title: Text('Cancel downloads'),
              contentPadding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
            ),
          ),
        if (showDelete)
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

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    final downloadsRepo = getIt<DownloadsRepository>();
    switch (action) {
      case 'play':
        ref.read(playerProvider.notifier).playNow(tracks);
      case 'playNext':
        ref.read(playerProvider.notifier).playNext(tracks);
      case 'add':
        ref.read(playerProvider.notifier).addToQueue(tracks);
        if (label != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "$label" to playing now'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      case 'download':
        downloadsRepo.enqueueAll(tracks.tracks);
        if (label != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Downloading "$label"'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      case 'cancelDownload':
        final trackKeys = tracks.tracks.map((t) => t.fileKey).toList();
        downloadsRepo.cancelAll(trackKeys);
      case 'deleteDownload':
        final trackKeys = tracks.tracks.map((t) => t.fileKey).toList();
        downloadsRepo.deleteAll(trackKeys);
    }
    ref.read(playerProvider.notifier).refresh();
  }
}
