import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../providers/downloaded_tracks_provider.dart';

@RoutePage()
class DownloadedArtistsScreen extends ConsumerWidget {
  const DownloadedArtistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsState = ref.watch(downloadedArtistsProvider);

    return artistsState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(downloadedArtistsProvider),
      ),
      data: (artists) {
        if (artists.isEmpty) {
          return const _EmptyState();
        }
        return ListView.builder(
          itemCount: artists.length,
          itemBuilder: (context, i) {
            final artist = artists[i];
            return ListTile(
              title: Text(artist),
              onTap:
                  () => context.router.push(
                    DownloadedAlbumsRoute(artist: artist),
                  ),
            );
          },
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_for_offline_outlined,
            size: 64,
            color: AppColors.text3,
          ),
          SizedBox(height: 16),
          Text('No downloads yet', style: AppTextStyles.emptyState),
          SizedBox(height: 8),
          Text(
            'Tracks you download will appear here',
            style: AppTextStyles.itemSubtitle,
          ),
        ],
      ),
    );
  }
}
