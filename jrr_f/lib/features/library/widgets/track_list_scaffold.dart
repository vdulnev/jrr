import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/track.dart';
import '../data/repositories/library_repository.dart';
import 'library_item_tile.dart';

class TrackListScaffold extends ConsumerWidget {
  final Widget title;
  final AsyncValue<List<Track>> tracksState;
  final VoidCallback onRetry;
  final String actionSheetTitle;
  final String addedSnackbarLabel;

  const TrackListScaffold({
    required this.title,
    required this.tracksState,
    required this.onRetry,
    required this.actionSheetTitle,
    required this.addedSnackbarLabel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: back button row
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => ref.read(navigationProvider.notifier).pop(),
                ),
                const Spacer(),
                ...tracksState.maybeWhen(
                  data: (tracks) => tracks.isNotEmpty
                      ? [
                          _TracksPopupMenu(
                            tracks: tracks,
                            label: addedSnackbarLabel,
                          ),
                        ]
                      : <Widget>[],
                  orElse: () => <Widget>[],
                ),
              ],
            ),
            // Title — full width, no truncation
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: title,
            ),
            // Content
            Expanded(
              child: tracksState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e, onRetry: onRetry),
                data: (tracks) {
                  if (tracks.isEmpty) {
                    return const Center(child: Text('No tracks found'));
                  }
                  final isMultiDisc = tracks.any(
                    (t) => t.totalDiscs > 1 || t.discNumber > 1,
                  );
                  if (isMultiDisc) {
                    return _MultiDiscList(tracks: tracks);
                  }
                  return ListView.builder(
                    itemCount: tracks.length,
                    itemBuilder: (_, i) => LibraryItemTile(
                      item: tracks[i],
                      trackNumber: tracks[i].trackNumber > 0
                          ? tracks[i].trackNumber
                          : i + 1,
                      collapsedByDefault: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiDiscList extends StatelessWidget {
  final List<Track> tracks;

  const _MultiDiscList({required this.tracks});

  @override
  Widget build(BuildContext context) {
    final discs = <int, List<Track>>{};
    for (final track in tracks) {
      (discs[track.discNumber] ??= []).add(track);
    }
    final sortedDiscs = discs.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final totalDiscs = tracks
        .map((t) => t.totalDiscs)
        .reduce((a, b) => a > b ? a : b);

    return ListView(
      children: [
        for (final entry in sortedDiscs) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Disc ${entry.key} of $totalDiscs',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          for (final track in entry.value)
            LibraryItemTile(
              item: track,
              trackNumber: track.trackNumber > 0 ? track.trackNumber : null,
              collapsedByDefault: true,
            ),
        ],
      ],
    );
  }
}

class _TracksPopupMenu extends ConsumerWidget {
  final List<Track> tracks;
  final String label;

  const _TracksPopupMenu({required this.tracks, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppColors.text3),
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
      ],
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "$label" to playing now'),
              duration: const Duration(seconds: 1),
            ),
          );
        }
    }
    ref.read(playerProvider.notifier).refresh();
  }
}
