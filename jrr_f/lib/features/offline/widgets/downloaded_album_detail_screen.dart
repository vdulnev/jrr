import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../library/widgets/track_list_scaffold.dart';
import '../providers/downloaded_tracks_provider.dart';

@RoutePage()
class DownloadedAlbumDetailScreen extends ConsumerWidget {
  final String albumGroupId;

  const DownloadedAlbumDetailScreen({required this.albumGroupId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(downloadedAlbumTracksProvider(albumGroupId));

    return TrackListScaffold(
      title: Text(
        tracksState.maybeWhen(
          data:
              (tracks) =>
                  tracks.tracks.isNotEmpty ? tracks.tracks.first.album : 'Album',
          orElse: () => 'Album',
        ),
        style: AppTextStyles.subScreenTitle,
      ),
      subtitle: tracksState.maybeWhen(
        data:
            (tracks) =>
                tracks.tracks.isNotEmpty
                    ? [
                      tracks.tracks.first.albumArtist,
                      tracks.tracks.first.dateReadable,
                    ].where((s) => s.isNotEmpty).join(' \u00b7 ')
                    : 'Downloaded Album',
        orElse: () => 'Downloaded Album',
      ),
      tracksState: tracksState,
      onRetry: () => ref.invalidate(downloadedAlbumTracksProvider(albumGroupId)),
      actionSheetTitle: 'Album',
      addedSnackbarLabel: 'Album',
    );
  }
}
