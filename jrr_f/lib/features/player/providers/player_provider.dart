import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../data/repositories/player_repository.dart';

part 'player_provider.g.dart';

@riverpod
class Player extends _$Player {
  @override
  Future<PlayerStatus> build() async {
    final zone = ref.watch(activeZoneProvider);
    if (zone == null) {
      throw const AppException.serverFailure(message: 'No active zone');
    }
    final result = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
    return result.getOrElse((e) => throw e);
  }

  /// Silently refreshes player status without showing a loading state.
  Future<void> refresh() async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    final result = await AsyncValue.guard(() async {
      final r = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
      return r.getOrElse((e) => throw e);
    });
    state = result;
  }

  // -------------------------------------------------------------------------
  // Commands — each fires the command then refreshes state.
  // -------------------------------------------------------------------------

  Future<void> playPause() =>
      _run((id) => getIt<PlayerRepository>().playPause(id));

  Future<void> stop() => _run((id) => getIt<PlayerRepository>().stop(id));

  Future<void> next() => _run((id) => getIt<PlayerRepository>().next(id));

  Future<void> previous() =>
      _run((id) => getIt<PlayerRepository>().previous(id));

  Future<void> seekTo(int positionMs) =>
      _run((id) => getIt<PlayerRepository>().setPosition(id, positionMs));

  Future<void> setVolume(double level) =>
      _run((id) => getIt<PlayerRepository>().setVolume(id, level));

  Future<void> toggleMute() async {
    final isMuted = state.asData?.value.isMuted ?? false;
    await _run((id) => getIt<PlayerRepository>().setMute(id, mute: !isMuted));
  }

  Future<void> toggleShuffle() async {
    final current = state.asData?.value.shuffleMode ?? ShuffleMode.off;
    final next = current == ShuffleMode.off ? ShuffleMode.on : ShuffleMode.off;
    await _run((id) => getIt<PlayerRepository>().setShuffle(id, next));
  }

  Future<void> cycleRepeat() async {
    final current = state.asData?.value.repeatMode ?? RepeatMode.off;
    final next = switch (current) {
      RepeatMode.off => RepeatMode.playlist,
      RepeatMode.playlist => RepeatMode.track,
      RepeatMode.track => RepeatMode.off,
    };
    await _run((id) => getIt<PlayerRepository>().setRepeat(id, next));
  }

  Future<void> _run(Future<dynamic> Function(String zoneId) action) async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    await action(zone.id);
    await refresh();
  }
}
