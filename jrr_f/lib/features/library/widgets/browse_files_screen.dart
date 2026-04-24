import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/tracks_popup_menu.dart';
import '../providers/library_providers.dart';
import 'grouped_track_list.dart';
import 'library_item_tile.dart';

/// Displays tracks from a browse leaf node (Browse/Files).
class BrowseFilesView extends ConsumerStatefulWidget {
  final String id;
  final String title;

  const BrowseFilesView({required this.id, required this.title, super.key});

  @override
  ConsumerState<BrowseFilesView> createState() => _BrowseFilesViewState();
}

class _BrowseFilesViewState extends ConsumerState<BrowseFilesView> {
  bool _grouped = false;

  @override
  Widget build(BuildContext context) {
    final tracksState = ref.watch(browseFilesProvider(widget.id));

    return tracksState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(browseFilesProvider(widget.id)),
      ),
      data: (tracks) {
        if (tracks.isEmpty) {
          return const Center(child: Text('No tracks'));
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      _grouped
                          ? Icons.format_list_bulleted
                          : Icons.group_work_outlined,
                    ),
                    tooltip: _grouped ? 'Flat list' : 'Group by artist/album',
                    onPressed: () => setState(() => _grouped = !_grouped),
                  ),
                  TracksPopupMenu(tracks: tracks, label: widget.title),
                ],
              ),
            ),
            Expanded(
              child: _grouped
                  ? GroupedTrackList(tracks: tracks)
                  : ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (_, i) => LibraryItemTile(
                        item: tracks[i],
                        trackNumber: tracks[i].trackNumber > 0
                            ? tracks[i].trackNumber
                            : i + 1,
                        collapsedByDefault: true,
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
