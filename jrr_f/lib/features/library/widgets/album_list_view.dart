import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/album_group.dart';
import 'album_row_tile.dart';

/// Reusable album list for embedded use (Random tab, etc.)
class AlbumListView extends ConsumerWidget {
  final List<AlbumGroup> groups;

  const AlbumListView({required this.groups, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: groups.length,
      itemBuilder: (_, i) => AlbumRowTile(album: groups[i].album),
    );
  }
}

/// Sliver variant of [AlbumListView] — for use inside a [CustomScrollView].
class AlbumSliverList extends StatelessWidget {
  final List<AlbumGroup> groups;

  const AlbumSliverList({required this.groups, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: groups.length,
      itemBuilder: (_, i) => AlbumRowTile(album: groups[i].album),
    );
  }
}
