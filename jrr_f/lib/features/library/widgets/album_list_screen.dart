import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/album.dart';
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
                            trailing: const Icon(Icons.chevron_right),
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
