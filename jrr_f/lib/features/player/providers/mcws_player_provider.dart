import 'dart:async';

import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import 'player_controller.dart';

part 'mcws_player_provider.g.dart';

/// Owns all MCWS-driven (remote) playback control.
///
/// Returns `null` when the active zone is missing, local, or offline. The
/// unified [Player] provider watches this one for the remote branch and
/// dispatches commands here for non-local zones.
@Riverpod(keepAlive: true)
class McwsPlayer extends _$McwsPlayer implements PlayerController {
  @override
  FutureOr<PlayerStatus?> build() async {
    final zone = ref.watch(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline || zone.isAndroidAuto) {
      return null;
    }

    ref
        .read(talkerProvider)
        .debug('[McwsPlayer] build: zone=${zone.name} (id=${zone.id})');

    final result = await ref
        .read(playerRepositoryProvider)
        .getPlaybackInfo(zone.id);
    return result.getOrElse((e) => throw e);
  }

  /// Silently refreshes player status without flipping to a loading state.
  @override
  Future<void> refresh() async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline || zone.isAndroidAuto) {
      return;
    }

    final result = await AsyncValue.guard(() async {
      final r = await ref
          .read(playerRepositoryProvider)
          .getPlaybackInfo(zone.id);
      return r.getOrElse((e) => throw e);
    });
    state = result;
  }

  // --------------------------------------------------------------------------
  // Commands — each fires the MCWS request then refreshes state.
  // --------------------------------------------------------------------------

  @override
  Future<void> playPause() =>
      _run((id) => ref.read(playerRepositoryProvider).playPause(id));

  @override
  Future<void> stop({Zone? zoneToRun}) => _run(
    (id) => ref.read(playerRepositoryProvider).stop(id),
    zoneToRun: zoneToRun,
  );

  @override
  Future<void> next() =>
      _run((id) => ref.read(playerRepositoryProvider).next(id));

  @override
  Future<void> previous() =>
      _run((id) => ref.read(playerRepositoryProvider).previous(id));

  @override
  Future<void> seekTo(int positionMs) => _run(
    (id) => ref.read(playerRepositoryProvider).setPosition(id, positionMs),
  );

  @override
  Future<void> setVolume(double level) =>
      _run((id) => ref.read(playerRepositoryProvider).setVolume(id, level));

  @override
  Future<void> toggleMute() async {
    final isMuted = state.asData?.value?.isMuted ?? false;
    await _run(
      (id) => ref.read(playerRepositoryProvider).setMute(id, mute: !isMuted),
    );
  }

  @override
  Future<void> toggleShuffle() async {
    final current = state.asData?.value?.shuffleMode ?? ShuffleMode.off;
    final nextMode = current == ShuffleMode.off
        ? ShuffleMode.on
        : ShuffleMode.off;
    await _run(
      (id) => ref.read(playerRepositoryProvider).setShuffle(id, nextMode),
    );
  }

  @override
  Future<void> playByIndex(int index) =>
      _run((id) => ref.read(playerRepositoryProvider).playByIndex(id, index));

  @override
  Future<void> cycleRepeat() async {
    final current = state.asData?.value?.repeatMode ?? RepeatMode.off;
    final nextMode = switch (current) {
      RepeatMode.off => RepeatMode.playlist,
      RepeatMode.playlist => RepeatMode.track,
      RepeatMode.track => RepeatMode.off,
    };
    await _run(
      (id) => ref.read(playerRepositoryProvider).setRepeat(id, nextMode),
    );
  }

  /// Replaces the Playing Now queue and starts playback immediately.
  @override
  Future<void> playNow(Tracks tracks) {
    ref.read(talkerProvider).debug('[McwsPlayer] playNow: tracks=$tracks');
    return _run(
      (id) => ref
          .read(libraryRepositoryProvider)
          .playNow(id, tracks.tracks.map((t) => t.fileKey).toList()),
    );
  }

  /// Inserts [tracks] immediately after the current track.
  @override
  Future<void> playNext(Tracks tracks) {
    ref.read(talkerProvider).debug('[McwsPlayer] playNext: tracks=$tracks');
    return _run(
      (id) => ref
          .read(libraryRepositoryProvider)
          .playNext(id, tracks.tracks.map((t) => t.fileKey).toList()),
    );
  }

  /// Appends [tracks] to the end of the Playing Now queue.
  @override
  Future<void> addToQueue(Tracks tracks) {
    ref.read(talkerProvider).debug('[McwsPlayer] addToQueue: tracks=$tracks');
    return _run(
      (id) => ref
          .read(libraryRepositoryProvider)
          .addToQueue(id, tracks.tracks.map((t) => t.fileKey).toList()),
    );
  }

  Future<void> _run(
    Future<dynamic> Function(String zoneId) cmd, {
    Zone? zoneToRun,
  }) async {
    final zone = zoneToRun ?? ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline || zone.isAndroidAuto) {
      return;
    }
    await cmd(zone.id);
    await refresh();
  }
}
