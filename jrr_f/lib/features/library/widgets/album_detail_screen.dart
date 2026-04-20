import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/album.dart';
import '../providers/library_providers.dart';
import 'track_list_scaffold.dart';

@RoutePage()
class AlbumDetailScreen extends ConsumerWidget {
  final Album album;

  const AlbumDetailScreen({required this.album, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TrackListScaffold(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(album.name),
          if (album.albumArtist.isNotEmpty)
            Text(
              album.albumArtist,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
      tracksState: ref.watch(albumTracksProvider(album)),
      onRetry: () => ref.invalidate(albumTracksProvider(album)),
      actionSheetTitle: album.name,
      addedSnackbarLabel: album.name,
    );
  }
}
