import 'package:flutter/material.dart';

import '../data/models/track.dart';
import 'library_item_tile.dart';

class MultiDiscList extends StatelessWidget {
  final List<Track> tracks;

  const MultiDiscList({required this.tracks, super.key});

  @override
  Widget build(BuildContext context) {
    final children = _buildChildren(context, tracks);
    return ListView(children: children);
  }
}

/// Sliver variant of [MultiDiscList] — for use inside a [CustomScrollView].
class MultiDiscSliverList extends StatelessWidget {
  final List<Track> tracks;

  const MultiDiscSliverList({required this.tracks, super.key});

  @override
  Widget build(BuildContext context) {
    final children = _buildChildren(context, tracks);
    return SliverList(delegate: SliverChildListDelegate(children));
  }
}

List<Widget> _buildChildren(BuildContext context, List<Track> tracks) {
  final discs = <int, List<Track>>{};
  for (final track in tracks) {
    (discs[track.discNumber] ??= []).add(track);
  }
  final sortedDiscs = discs.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  final totalDiscs = tracks
      .map((t) => t.totalDiscs)
      .reduce((a, b) => a > b ? a : b);

  return [
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
  ];
}
