import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/track.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';
import 'library_item_tile.dart';

/// Displays tracks from a browse leaf node (Browse/Files).
class BrowseFilesView extends ConsumerStatefulWidget {
  final String id;
  final String title;

  const BrowseFilesView({required this.id, required this.title, super.key});

  @override
  ConsumerState<BrowseFilesView> createState() => _BrowseFilesViewState();
}

class _BrowseFilesViewState extends ConsumerState<BrowseFilesView> {
  bool _grouped = false;

  @override
  Widget build(BuildContext context) {
    final tracksState = ref.watch(browseFilesProvider(widget.id));

    return tracksState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(browseFilesProvider(widget.id)),
      ),
      data: (tracks) {
        if (tracks.isEmpty) {
          return const Center(child: Text('No tracks'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      _grouped
                          ? Icons.format_list_bulleted
                          : Icons.group_work_outlined,
                    ),
                    tooltip: _grouped ? 'Flat list' : 'Group by artist/album',
                    onPressed: () => setState(() => _grouped = !_grouped),
                  ),
                  IconButton(
                    icon: const Icon(Icons.play_arrow_outlined),
                    tooltip: 'Play all',
                    onPressed: () {
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
                    icon: const Icon(Icons.queue_play_next),
                    tooltip: 'Play next',
                    onPressed: () {
                      final zone = ref.read(activeZoneProvider);
                      if (zone == null) return;
                      getIt<LibraryRepository>().playNext(
                        zone.id,
                        tracks.map((t) => t.fileKey).toList(),
                      );
                      ref.read(playerProvider.notifier).refresh();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add all to playing now',
                    onPressed: () {
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
                              'Added "${widget.title}" to playing now',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _grouped
                  ? _GroupedTrackList(tracks: tracks)
                  : ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (_, i) => LibraryItemTile(
                        item: tracks[i],
                        trackNumber: tracks[i].trackNumber > 0
                            ? tracks[i].trackNumber
                            : i + 1,
                        collapsedByDefault: true,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _GroupedTrackList extends ConsumerWidget {
  final List<Track> tracks;

  const _GroupedTrackList({required this.tracks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Group by artist, then by album + dateReadable + folderPath
    final byArtist = <String, Map<String, List<Track>>>{};
    for (final track in tracks) {
      final artist = track.artist.isEmpty ? 'Unknown Artist' : track.artist;
      final albumKey = [
        track.album,
        track.dateReadable,
        track.folderPath,
      ].join('\x00');
      (byArtist[artist] ??= {})[albumKey] =
          ((byArtist[artist] ?? {})[albumKey] ?? [])..add(track);
    }

    final sortedArtists = byArtist.keys.toList()..sort();

    return ListView(
      children: [
        for (final artist in sortedArtists) ...[
          _ArtistHeader(
            artist: artist,
            tracks: byArtist[artist]!.values.expand((t) => t).toList(),
          ),
          for (final entry in byArtist[artist]!.entries) ...[
            _AlbumHeader(
              label: _albumLabel(entry.value.first),
              tracks: entry.value,
            ),
            for (final track in entry.value)
              LibraryItemTile(
                item: track,
                trackNumber: track.trackNumber > 0 ? track.trackNumber : null,
                collapsedByDefault: true,
              ),
          ],
        ],
      ],
    );
  }

  String _albumLabel(Track track) {
    final parts = <String>[
      if (track.album.isNotEmpty) track.album,
      if (track.dateReadable.isNotEmpty) track.dateReadable,
    ];
    return parts.join(' · ');
  }
}

class _ArtistHeader extends ConsumerWidget {
  final String artist;
  final List<Track> tracks;

  const _ArtistHeader({required this.artist, required this.tracks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              artist,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          _PlayAddButtons(tracks: tracks, ref: ref, context: context),
        ],
      ),
    );
  }
}

class _AlbumHeader extends ConsumerWidget {
  final String label;
  final List<Track> tracks;

  const _AlbumHeader({required this.label, required this.tracks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 8, 2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          _PlayAddButtons(tracks: tracks, ref: ref, context: context),
        ],
      ),
    );
  }
}

class _PlayAddButtons extends StatelessWidget {
  final List<Track> tracks;
  final WidgetRef ref;
  final BuildContext context;

  const _PlayAddButtons({
    required this.tracks,
    required this.ref,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.play_arrow_outlined, size: 20),
          visualDensity: VisualDensity.compact,
          tooltip: 'Play',
          onPressed: () {
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
          icon: const Icon(Icons.queue_play_next, size: 20),
          visualDensity: VisualDensity.compact,
          tooltip: 'Play next',
          onPressed: () {
            final zone = ref.read(activeZoneProvider);
            if (zone == null) return;
            getIt<LibraryRepository>().playNext(
              zone.id,
              tracks.map((t) => t.fileKey).toList(),
            );
            ref.read(playerProvider.notifier).refresh();
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, size: 20),
          visualDensity: VisualDensity.compact,
          tooltip: 'Add to playing now',
          onPressed: () {
            final zone = ref.read(activeZoneProvider);
            if (zone == null) return;
            getIt<LibraryRepository>().addToQueue(
              zone.id,
              tracks.map((t) => t.fileKey).toList(),
            );
            ref.read(playerProvider.notifier).refresh();
          },
        ),
      ],
    );
  }
}
