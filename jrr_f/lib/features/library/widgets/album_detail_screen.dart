import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/album.dart';
import '../data/models/track.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';
import 'library_action_sheet.dart';
import 'library_item_tile.dart';

@RoutePage()
class AlbumDetailScreen extends ConsumerWidget {
  final Album album;

  const AlbumDetailScreen({required this.album, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(albumTracksProvider(album));

    return Scaffold(
      appBar: AppBar(
        title: tracksState.maybeWhen(
          data: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (album.artist.isNotEmpty)
                Text(
                  album.artist,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
          orElse: () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(album.name, maxLines: 1, overflow: TextOverflow.ellipsis),
              if (album.artist.isNotEmpty)
                Text(
                  album.artist,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
        actions: [
          tracksState.maybeWhen(
            data: (tracks) => tracks.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.play_arrow_outlined),
                        tooltip: 'Play album',
                        onPressed: () async {
                          final zone = ref.read(activeZoneProvider);
                          if (zone == null) return;
                          getIt<LibraryRepository>().playNow(
                            zone.id,
                            tracks.map((t) => t.fileKey).toList(),
                          );
                          ref.read(playerProvider.notifier).refresh();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        tooltip: 'Add album to playing now',
                        onPressed: () async {
                          final zone = ref.read(activeZoneProvider);
                          if (zone == null) return;
                          getIt<LibraryRepository>().addToQueue(
                            zone.id,
                            tracks.map((t) => t.fileKey).toList(),
                          );
                          ref.read(playerProvider.notifier).refresh();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added "${album.name}" to playing now',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => showLibraryActionSheet(
                          context,
                          ref,
                          items: tracks,
                          title: album.name,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: tracksState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(albumTracksProvider(album)),
        ),
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(child: Text('No tracks found'));
          }
          final isMultiDisc = tracks.any(
            (t) => t.totalDiscs > 1 || t.discNumber > 1,
          );
          if (!isMultiDisc) {
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
          }
          return _MultiDiscList(tracks: tracks);
        },
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
