import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/library_providers.dart';
import 'album_list_view.dart';

@RoutePage()
class RandomTabScreen extends ConsumerWidget {
  const RandomTabScreen({super.key});

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
