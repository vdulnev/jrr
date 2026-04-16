import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../../player/data/models/player_status.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../../library/data/models/track.dart';
import '../data/repositories/queue_repository.dart';

part 'queue_provider.g.dart';

@riverpod
class Queue extends _$Queue {
  int? _lastChangeCounter;

  @override
  Future<List<Track>> build() async {
    final zone = ref.watch(activeZoneProvider);
    if (zone == null) return [];

    // Invalidate self whenever the Playing Now change counter increments.
    ref.listen<AsyncValue<PlayerStatus>>(playerProvider, (_, next) {
      final counter = next.asData?.value.playingNowChangeCounter;
      if (counter != null && counter != _lastChangeCounter) {
        _lastChangeCounter = counter;
        ref.invalidateSelf();
      }
    });

    final result = await getIt<QueueRepository>().getQueue(zone.id);
    return result.getOrElse((e) => throw e);
  }

  Future<void> playByIndex(int index) =>
      _run((id) => getIt<QueueRepository>().playByIndex(id, index));

  Future<void> removeItem(int index) =>
      _run((id) => getIt<QueueRepository>().removeItem(id, index));

  Future<void> moveItem(int source, int target) =>
      _run((id) => getIt<QueueRepository>().moveItem(id, source, target));

  Future<void> clearQueue() =>
      _run((id) => getIt<QueueRepository>().clearQueue(id));

  Future<void> _run(
    Future<Either<AppException, Unit>> Function(String zoneId) action,
  ) async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    await action(zone.id);
    await ref.read(playerProvider.notifier).refresh();
  }
}
