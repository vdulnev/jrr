import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/album.dart';
import 'album_row_tile.dart';

/// Reusable album list for embedded use (Random tab, etc.)
class AlbumListView extends ConsumerWidget {
  final List<Album> albums;

  const AlbumListView({required this.albums, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 148),
      itemCount: albums.length,
      itemBuilder: (_, i) {
        final album = albums[i];
        return AlbumRowTile(album: album);
      },
    );
  }
}
