import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/library_providers.dart';

class ArtistsTab extends ConsumerStatefulWidget {
  const ArtistsTab({super.key});

  @override
  ConsumerState<ArtistsTab> createState() => _ArtistsTabState();
}

class _ArtistsTabState extends ConsumerState<ArtistsTab> {
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
                              .read(libraryNavProvider.notifier)
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
