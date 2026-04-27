import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../library/data/models/track.dart';
import '../data/repositories/local_queue_repository.dart';

part 'local_queue_provider.g.dart';

@Riverpod(keepAlive: true)
class LocalQueue extends _$LocalQueue {
  late LocalQueueRepository _repo;

  @override
  Future<List<Track>> build() async {
    _repo = getIt<LocalQueueRepository>();
    final result = await _repo.getTracks();
    return result.getOrElse((e) => throw e);
  }

  Future<void> addTracks(List<Track> tracks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.addTracks(tracks);
      final result = await _repo.getTracks();
      return result.getOrElse((e) => throw e);
    });
  }

  Future<void> setTracks(List<Track> tracks) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.setTracks(tracks);
      final result = await _repo.getTracks();
      return result.getOrElse((e) => throw e);
    });
  }

  Future<void> removeTrack(int index) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.removeTrack(index);
      final result = await _repo.getTracks();
      return result.getOrElse((e) => throw e);
    });
  }

  Future<void> moveTrack(int oldIndex, int newIndex) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.moveTrack(oldIndex, newIndex);
      final result = await _repo.getTracks();
      return result.getOrElse((e) => throw e);
    });
  }

  Future<void> clear() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _repo.clear();
      return [];
    });
  }
}
