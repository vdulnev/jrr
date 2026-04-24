import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../../../shared/widgets/tracks_popup_menu.dart';
import '../data/models/track.dart';
import 'library_item_tile.dart';
import 'multi_disc_list.dart';

class TrackListScaffold extends ConsumerWidget {
  final Widget title;
  final String? subtitle;
  final AsyncValue<List<Track>> tracksState;
  final VoidCallback onRetry;
  final String actionSheetTitle;
  final String addedSnackbarLabel;
  final Widget? headerContent;
  final VoidCallback? onBack;

  const TrackListScaffold({
    required this.title,
    this.subtitle,
    required this.tracksState,
    required this.onRetry,
    required this.actionSheetTitle,
    required this.addedSnackbarLabel,
    this.headerContent,
    this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubScreenHeader(
              titleWidget: title,
              subtitle: subtitle,
              onBack:
                  onBack ?? () => ref.read(navigationProvider.notifier).pop(),
              content: headerContent,
              trailing: tracksState.maybeWhen(
                data: (tracks) => tracks.isNotEmpty
                    ? TracksPopupMenu(tracks: tracks, label: addedSnackbarLabel)
                    : null,
                orElse: () => null,
              ),
            ),
            // Content
            Expanded(
              child: tracksState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(error: e, onRetry: onRetry),
                data: (tracks) {
                  if (tracks.isEmpty) {
                    return const Center(child: Text('No tracks found'));
                  }
                  final isMultiDisc = tracks.any(
                    (t) => t.totalDiscs > 1 || t.discNumber > 1,
                  );
                  if (isMultiDisc) {
                    return MultiDiscList(tracks: tracks);
                  }
                  return ListView.builder(
                    itemCount: tracks.length,
                    itemBuilder: (_, i) => LibraryItemTile(
                      item: tracks[i],
                      trackNumber: tracks[i].trackNumber > 0
                          ? tracks[i].trackNumber
                          : i + 1,
                      collapsedByDefault: true,
                    ),
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
