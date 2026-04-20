import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/repositories/library_repository.dart';
import '../providers/library_providers.dart';
import 'library_action_sheet.dart';
import 'library_item_tile.dart';

@RoutePage()
class FolderTracksScreen extends ConsumerWidget {
  final String folderPath;

  const FolderTracksScreen({required this.folderPath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(folderTracksProvider(folderPath));

    return Scaffold(
      appBar: AppBar(
        title: Text(folderPath, style: Theme.of(context).textTheme.bodySmall),
        toolbarHeight: kToolbarHeight * 1.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
        actions: [
          tracksState.maybeWhen(
            data: (tracks) => tracks.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
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
                                content: Text(
                                  'Added ${tracks.length} tracks'
                                  ' to playing now',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () => showLibraryActionSheet(
                          context,
                          ref,
                          items: tracks,
                          title: folderPath,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: tracksState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(folderTracksProvider(folderPath)),
        ),
        data: (tracks) {
          if (tracks.isEmpty) {
            return const Center(child: Text('No tracks found'));
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
    );
  }
}
