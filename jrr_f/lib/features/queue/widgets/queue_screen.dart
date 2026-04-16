import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../providers/queue_provider.dart';
import 'queue_item_tile.dart';

@RoutePage()
class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    final currentIndex = ref.watch(
      playerProvider.select((s) => s.asData?.value.playingNowPosition ?? -1),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing Now'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
        actions: [
          queueState.maybeWhen(
            data: (items) => items.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear_all),
                    tooltip: 'Clear queue',
                    onPressed: () =>
                        ref.read(queueProvider.notifier).clearQueue(),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: queueState.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(queueProvider)),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Queue is empty'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) =>
                QueueItemTile(item: items[i], index: i, isPlaying: i == currentIndex),
          );
        },
      ),
    );
  }
}
