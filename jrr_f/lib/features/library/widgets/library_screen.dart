import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/library_providers.dart';
import 'library_item_tile.dart';

@RoutePage()
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _query = value.trim());
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _debounce?.cancel();
    setState(() => _query = '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search artists, albums, tracks…',
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
              ],
              onChanged: _onSearchChanged,
            ),
          ),
        ),
      ),
      body: _query.isEmpty ? _ArtistBrowser() : _SearchResults(query: _query),
    );
  }
}

// ---------------------------------------------------------------------------
// Artist browse tab
// ---------------------------------------------------------------------------

class _ArtistBrowser extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsState = ref.watch(artistsProvider);

    return artistsState.when(
      loading: () => const LoadingView(),
      error: (e, _) =>
          ErrorView(error: e, onRetry: () => ref.invalidate(artistsProvider)),
      data: (artists) {
        if (artists.isEmpty) {
          return const Center(child: Text('No artists found'));
        }
        return ListView.builder(
          itemCount: artists.length,
          itemBuilder: (_, i) {
            final artist = artists[i];
            return ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(artist),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ref
                  .read(navigationProvider.notifier)
                  .push(AlbumListRoute(artist: artist)),
            );
          },
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Search results
// ---------------------------------------------------------------------------

class _SearchResults extends ConsumerWidget {
  final String query;

  const _SearchResults({required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsState = ref.watch(librarySearchProvider(query));

    return resultsState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(librarySearchProvider(query)),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(child: Text('No results for "$query"'));
        }
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, i) => LibraryItemTile(item: items[i]),
        );
      },
    );
  }
}
