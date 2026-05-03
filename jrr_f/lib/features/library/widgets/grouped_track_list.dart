import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/tracks_popup_menu.dart';
import '../data/models/track.dart';
import '../data/models/tracks.dart';
import 'library_item_tile.dart';

class GroupedTrackList extends ConsumerWidget {
  final List<Track> tracks;

  const GroupedTrackList({required this.tracks, super.key});

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
      if (track.dateReadable.isNotEmpty) track.dateReadable,
      if (track.album.isNotEmpty) track.album,
    ];
    return parts.join(' - ');
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
          TracksPopupMenu(tracks: Tracks(tracks: tracks)),
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
          TracksPopupMenu(tracks: Tracks(tracks: tracks)),
        ],
      ),
    );
  }
}
