import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../player/providers/player_provider.dart';
import 'queue_provider.dart';
import 'queue_view_state.dart';

part 'queue_view_model.g.dart';

@riverpod
class QueueViewModel extends _$QueueViewModel {
  @override
  QueueViewState build() {
    final queue = ref.watch(queueProvider);
    final currentIndex = ref.watch(playingNowPositionProvider);
    return QueueViewState(
      tracks: queue.value,
      error: queue.error,
      currentIndex: currentIndex,
    );
  }

  void playByIndex(int index) =>
      ref.read(playerProvider.notifier).playByIndex(index);

  Future<void> removeItem(int index) =>
      ref.read(queueProvider.notifier).removeItem(index);

  Future<void> clearQueue() => ref.read(queueProvider.notifier).clearQueue();
}
