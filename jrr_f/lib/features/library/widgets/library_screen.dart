import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/album.dart';
import '../providers/library_providers.dart';
import 'album_row_tile.dart';
import 'browse_screen.dart';

@RoutePage()
class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  static const _tabs = ['Artists', 'Random', 'Browse'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(libraryTabIndexProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('LIBRARY', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 6),
                  const Text('Browse', style: AppTextStyles.screenTitle),
                  const SizedBox(height: 14),
                  // Segmented tab control
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: AppColors.bg2,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: List.generate(_tabs.length, (i) {
                        final isActive = tabIndex == i;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => ref
                                .read(libraryTabIndexProvider.notifier)
                                .set(i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              height: 32,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.bg4
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _tabs[i],
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isActive
                                      ? AppColors.text
                                      : AppColors.text3,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            // Tab content
            Expanded(
              child: IndexedStack(
                index: tabIndex,
                children: const [
                  _ArtistsTab(),
                  _RandomTab(),
                  _BrowseTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArtistsTab extends ConsumerStatefulWidget {
  const _ArtistsTab();

  @override
  ConsumerState<_ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends ConsumerState<_ArtistsTab> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final artistsState = ref.watch(artistsProvider);

    return artistsState.when(
      loading: () => const LoadingView(),
      error: (e, _) =>
          ErrorView(error: e, onRetry: () => ref.invalidate(artistsProvider)),
      data: (artists) {
        final filtered = _filter.isEmpty
            ? artists
            : artists
                  .where((a) => a.toLowerCase().contains(_filter.toLowerCase()))
                  .toList();

        return Column(
          children: [
            // Filter field
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Filter artists\u2026',
                  prefixIcon: Icon(Icons.search, size: 18),
                  isDense: true,
                ),
                style: AppTextStyles.labelLarge,
                onChanged: (v) => setState(() => _filter = v),
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No matches',
                        style: AppTextStyles.emptyState,
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 148),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final artist = filtered[i];
                        return GestureDetector(
                          onTap: () => ref
                              .read(navigationProvider.notifier)
                              .push(ArtistAlbumsRoute(artist: artist)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColors.line),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Avatar circle
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.bg3,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    artist.isNotEmpty
                                        ? artist[0].toUpperCase()
                                        : '?',
                                    style: AppTextStyles.avatarLetter,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    artist,
                                    style: AppTextStyles.itemTitle,
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: AppColors.text3,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _RandomTab extends ConsumerWidget {
  const _RandomTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsState = ref.watch(randomAlbumsProvider);

    return albumsState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(randomAlbumsProvider),
      ),
      data: (albums) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => ref.invalidate(randomAlbumsProvider),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Shuffle',
                      style: AppTextStyles.accentSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: AlbumListView(albums: albums)),
        ],
      ),
    );
  }
}

class _BrowseTab extends StatelessWidget {
  const _BrowseTab();

  @override
  Widget build(BuildContext context) {
    return const BrowseTreeView();
  }
}

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
