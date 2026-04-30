import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../../player/providers/local_player_provider.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../../library/data/models/track.dart';
import '../data/repositories/queue_repository.dart';

part 'queue_provider.g.dart';

@riverpod
class Queue extends _$Queue {
  @override
  Future<List<Track>> build() async {
    final zone = ref.watch(activeZoneProvider);
    if (zone == null) return [];

    if (zone.isLocal) {
      final localQueue = ref.watch(localPlayerProvider.select((s) => s.sequenceState?.sequence.map((e) => e.tag as Track).toList() ?? []));
      return localQueue;
    }

    ref.watch(
      playerProvider.select(
        (status) => status.asData?.value?.playingNowChangeCounter,
      ),
    );

    final result = await getIt<QueueRepository>().getQueue(zone.id);
    return result.getOrElse((e) => throw e);
  }

  Future<void> removeItem(int index) async {
    final zone = ref.read(activeZoneProvider);
    if (zone?.isLocal == true) {
      await ref.read(localPlayerProvider.notifier).removeTrack(index);
    } else {
      await _run((id) => getIt<QueueRepository>().removeItem(id, index));
    }
  }

  Future<void> moveItem(int source, int target) async {
    final zone = ref.read(activeZoneProvider);
    if (zone?.isLocal == true) {
      await ref.read(localPlayerProvider.notifier).moveTrack(source, target);
    } else {
      await _run((id) => getIt<QueueRepository>().moveItem(id, source, target));
    }
  }

  Future<void> clearQueue() async {
    final zone = ref.read(activeZoneProvider);
    if (zone?.isLocal == true) {
      await ref.read(localPlayerProvider.notifier).setTracks([]);
    } else {
      await _run((id) => getIt<QueueRepository>().clearQueue(id));
    }
  }

  Future<void> _run(
    Future<Either<AppException, Unit>> Function(String zoneId) action,
  ) async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    await action(zone.id);
    await ref.read(playerProvider.notifier).refresh();
  }
}
