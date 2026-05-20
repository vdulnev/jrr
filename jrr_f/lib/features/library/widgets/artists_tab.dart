import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/core/di/providers.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/scroll_chrome_listener.dart';
import '../providers/library_providers.dart';

@RoutePage()
class ArtistsTabScreen extends ConsumerStatefulWidget {
  const ArtistsTabScreen({super.key});

  @override
  ConsumerState<ArtistsTabScreen> createState() => _ArtistsTabScreenState();
}

class _ArtistsTabScreenState extends ConsumerState<ArtistsTabScreen> {
  String _filter = '';

  @override
  Widget build(BuildContext context) {
    final talker = ref.read(talkerProvider);

    final artistsState = ref.watch(artistsProvider);

    talker.debug('[ArtistsTabScreen]: artistsState: $artistsState');

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

        return ScrollChromeListener(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => ref.invalidate(artistsProvider),
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
                            'Refresh',
                            style: AppTextStyles.accentSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Filter artists…',
                      prefixIcon: Icon(Icons.search, size: 18),
                      isDense: true,
                    ),
                    style: AppTextStyles.labelLarge,
                    onChanged: (v) => setState(() => _filter = v),
                  ),
                ),
              ),
              if (filtered.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text('No matches', style: AppTextStyles.emptyState),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final artist = filtered[i];
                    return GestureDetector(
                      onTap: () => context.router.push(
                        ArtistAlbumsRoute(artist: artist),
                      ),
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
              const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
            ],
          ),
        );
      },
    );
  }
}
