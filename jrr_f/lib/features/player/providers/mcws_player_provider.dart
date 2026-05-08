import 'dart:async';

import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/library/data/repositories/library_repository.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../data/repositories/player_repository.dart';

part 'mcws_player_provider.g.dart';

/// Owns all MCWS-driven (remote) playback control.
///
/// Returns `null` when the active zone is missing, local, or offline. The
/// unified [Player] provider watches this one for the remote branch and
/// dispatches commands here for non-local zones.
@Riverpod(keepAlive: true)
class McwsPlayer extends _$McwsPlayer {
  @override
  FutureOr<PlayerStatus?> build() async {
    final zone = ref.watch(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline) return null;

    getIt<Talker>().debug(
      '[McwsPlayer] build: zone=${zone.name} (id=${zone.id})',
    );

    final result = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
    return result.getOrElse((e) => throw e);
  }

  /// Silently refreshes player status without flipping to a loading state.
  Future<void> refresh() async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline) return;

    final result = await AsyncValue.guard(() async {
      final r = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
      return r.getOrElse((e) => throw e);
    });
    state = result;
  }

  // --------------------------------------------------------------------------
  // Commands — each fires the MCWS request then refreshes state.
  // --------------------------------------------------------------------------

  Future<void> playPause() =>
      _run((id) => getIt<PlayerRepository>().playPause(id));

  Future<void> stop({Zone? zoneToRun}) =>
      _run((id) => getIt<PlayerRepository>().stop(id), zoneToRun: zoneToRun);

  Future<void> next() => _run((id) => getIt<PlayerRepository>().next(id));

  Future<void> previous() =>
      _run((id) => getIt<PlayerRepository>().previous(id));

  Future<void> seekTo(int positionMs) =>
      _run((id) => getIt<PlayerRepository>().setPosition(id, positionMs));

  Future<void> setVolume(double level) =>
      _run((id) => getIt<PlayerRepository>().setVolume(id, level));

  Future<void> toggleMute() async {
    final isMuted = state.asData?.value?.isMuted ?? false;
    await _run((id) => getIt<PlayerRepository>().setMute(id, mute: !isMuted));
  }

  Future<void> toggleShuffle() async {
    final current = state.asData?.value?.shuffleMode ?? ShuffleMode.off;
    final nextMode = current == ShuffleMode.off
        ? ShuffleMode.on
        : ShuffleMode.off;
    await _run((id) => getIt<PlayerRepository>().setShuffle(id, nextMode));
  }

  Future<void> playByIndex(int index) =>
      _run((id) => getIt<PlayerRepository>().playByIndex(id, index));

  Future<void> cycleRepeat() async {
    final current = state.asData?.value?.repeatMode ?? RepeatMode.off;
    final nextMode = switch (current) {
      RepeatMode.off => RepeatMode.playlist,
      RepeatMode.playlist => RepeatMode.track,
      RepeatMode.track => RepeatMode.off,
    };
    await _run((id) => getIt<PlayerRepository>().setRepeat(id, nextMode));
  }

  /// Replaces the Playing Now queue and starts playback immediately.
  Future<void> playNow(Tracks tracks) {
    getIt<Talker>().debug('[McwsPlayer] playNow: tracks=$tracks');
    return _run(
      (id) => getIt<LibraryRepository>().playNow(
        id,
        tracks.tracks.map((t) => t.fileKey).toList(),
      ),
    );
  }

  /// Inserts [tracks] immediately after the current track.
  Future<void> playNext(Tracks tracks) {
    getIt<Talker>().debug('[McwsPlayer] playNext: tracks=$tracks');
    return _run(
      (id) => getIt<LibraryRepository>().playNext(
        id,
        tracks.tracks.map((t) => t.fileKey).toList(),
      ),
    );
  }

  /// Appends [tracks] to the end of the Playing Now queue.
  Future<void> addToQueue(Tracks tracks) {
    getIt<Talker>().debug('[McwsPlayer] addToQueue: tracks=$tracks');
    return _run(
      (id) => getIt<LibraryRepository>().addToQueue(
        id,
        tracks.tracks.map((t) => t.fileKey).toList(),
      ),
    );
  }

  Future<void> _run(
    Future<dynamic> Function(String zoneId) cmd, {
    Zone? zoneToRun,
  }) async {
    final zone = zoneToRun ?? ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline) return;
    await cmd(zone.id);
    await refresh();
  }
}
