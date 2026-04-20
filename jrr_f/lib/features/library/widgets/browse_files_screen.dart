import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';
import 'library_item_tile.dart';

/// Displays tracks from a browse leaf node (Browse/Files).
class BrowseFilesView extends ConsumerWidget {
  final String id;
  final String title;

  const BrowseFilesView({required this.id, required this.title, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(browseFilesProvider(id));

    return tracksState.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(browseFilesProvider(id)),
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
                    icon: const Icon(Icons.play_arrow_outlined),
                    tooltip: 'Play all',
                    onPressed: () {
                      final zone = ref.read(activeZoneProvider);
                      if (zone == null) return;
                      getIt<LibraryRepository>().playNow(
                        zone.id,
                        tracks.map((t) => t.fileKey).toList(),
                      );
                      ref.read(playerProvider.notifier).refresh();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'Add all to playing now',
                    onPressed: () {
                      final zone = ref.read(activeZoneProvider);
                      if (zone == null) return;
                      getIt<LibraryRepository>().addToQueue(
                        zone.id,
                        tracks.map((t) => t.fileKey).toList(),
                      );
                      ref.read(playerProvider.notifier).refresh();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added "$title" to playing now'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
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
