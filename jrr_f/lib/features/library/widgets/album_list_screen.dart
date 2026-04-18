import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/album.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';

@RoutePage()
class AlbumListScreen extends ConsumerStatefulWidget {
  final String artist;

  const AlbumListScreen({required this.artist, super.key});

  @override
  ConsumerState<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends ConsumerState<AlbumListScreen> {
  String _filter = '';

  List<Album> _filtered(List<Album> albums) {
    if (_filter.isEmpty) return albums;
    final lower = _filter.toLowerCase();
    return albums.where((a) => a.name.toLowerCase().contains(lower)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final albumsState = ref.watch(albumsByArtistProvider(widget.artist));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.artist),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
      ),
      body: albumsState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(albumsByArtistProvider(widget.artist)),
        ),
        data: (albums) {
          if (albums.isEmpty) {
            return const Center(child: Text('No albums found'));
          }
          final filtered = _filtered(albums);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filter albums',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                  ),
                  onChanged: (v) => setState(() => _filter = v),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text('No matches'))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final album = filtered[i];
                          return ListTile(
                            leading: const Icon(Icons.album_outlined),
                            title: Text(album.name),
                            subtitle: Text(widget.artist),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _AlbumActionButtons(album: album),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                            onTap: () => ref
                                .read(navigationProvider.notifier)
                                .push(AlbumDetailRoute(album: album)),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AlbumActionButtons extends ConsumerWidget {
  final Album album;

  const _AlbumActionButtons({required this.album});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) async {
        final tracks = await ref.read(albumTracksProvider(album).future);
        final zone = ref.read(activeZoneProvider);
        if (zone == null) return;

        final keys = tracks.map((t) => t.fileKey).toList();

        if (action == 'play') {
          getIt<LibraryRepository>().playNow(zone.id, keys);
        } else if (action == 'add') {
          getIt<LibraryRepository>().addToQueue(zone.id, keys);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Added "${album.name}" to playing now'),
                duration: const Duration(seconds: 1),
              ),
            );
          }
        }
        ref.read(playerProvider.notifier).refresh();
      },
      itemBuilder: (context) => [
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
}
