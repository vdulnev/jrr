import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../../library/widgets/album_row_tile.dart';
import '../providers/downloaded_tracks_provider.dart';

@RoutePage()
class DownloadedAlbumsScreen extends ConsumerWidget {
  final String artist;

  const DownloadedAlbumsScreen({required this.artist, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final albumsState = ref.watch(downloadedAlbumsProvider(artist));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubScreenHeader(
              titleWidget: Text(artist, style: AppTextStyles.subScreenTitle),
              subtitle: 'Downloaded Albums',
              onBack: () => context.router.maybePop(),
            ),
            Expanded(
              child: albumsState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () =>
                      ref.invalidate(downloadedAlbumsProvider(artist)),
                ),
                data: (albums) {
                  if (albums.isEmpty) {
                    return const Center(child: Text('No albums found'));
                  }
                  return ListView.builder(
                    itemCount: albums.length,
                    itemBuilder: (context, i) {
                      final album = albums[i];
                      final albumGroupId =
                          '${album.name}|${album.parentFolderPath}';
                      return AlbumRowTile(
                        album: album,
                        onTap: () => context.router.push(
                          DownloadedAlbumDetailRoute(
                            albumGroupId: albumGroupId,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
