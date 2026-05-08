import 'dart:async' hide Zone;
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import 'local_player_provider.dart';
import 'mcws_player_provider.dart';

part 'player_provider.g.dart';

/// Unified player provider. Dispatches between [LocalPlayer] (just_audio) for
/// local/offline zones and [McwsPlayer] (MCWS HTTP API) for remote zones.
///
/// Public surface is preserved so consumers don't need to know which transport
/// is active.
@Riverpod(keepAlive: true)
class Player extends _$Player {
  @override
  FutureOr<PlayerStatus?> build() async {
    ref.listen(activeZoneProvider, (oldZone, newZone) {
      // Only fire a stop when switching between two real zones. A null newZone
      // means the session is being torn down (logout) — the McwsClient has
      // already been removed from getIt, so a remote stop would crash.
      if (oldZone != null && newZone != null) {
        stop(zoneToRun: oldZone);
      }
    });

    final zone = ref.watch(activeZoneProvider);
    if (zone == null) {
      return null;
    }

    getIt<Talker>().debug(
      '[PlayerProvider] build: zone=${zone.name} (id=${zone.id}, isLocal=${zone.isLocal}, isOffline=${zone.isOffline})',
    );

    // Pipe state through the appropriate transport. Both branches return
    // AsyncValue<PlayerStatus?>; awaiting `.future` re-fires this build
    // whenever the underlying notifier emits a new value.
    if (zone.isLocal || zone.isOffline) {
      return await ref.watch(localPlayerProvider.future);
    }
    return await ref.watch(mcwsPlayerProvider.future);
  }

  /// Silently refreshes player status without showing a loading state.
  /// Used by [PlayerPolling] to drive periodic updates for remote zones.
  Future<void> refresh() async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal || zone.isOffline) return;
    await ref.read(mcwsPlayerProvider.notifier).refresh();
  }

  // -------------------------------------------------------------------------
  // Commands — dispatch to the local or MCWS notifier based on active zone.
  // -------------------------------------------------------------------------

  Future<void> playPause() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).playPause(),
    local: () => ref.read(localPlayerProvider.notifier).playPause(),
  );

  Future<void> stop({Zone? zoneToRun}) => _run(
    remote: () =>
        ref.read(mcwsPlayerProvider.notifier).stop(zoneToRun: zoneToRun),
    local: () => ref.read(localPlayerProvider.notifier).stop(),
    zoneToRun: zoneToRun,
  );

  Future<void> next() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).next(),
    local: () => ref.read(localPlayerProvider.notifier).next(),
  );

  Future<void> previous() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).previous(),
    local: () => ref.read(localPlayerProvider.notifier).previous(),
  );

  Future<void> seekTo(int positionMs) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).seekTo(positionMs),
    local: () => ref.read(localPlayerProvider.notifier).seekTo(positionMs),
  );

  Future<void> setVolume(double level) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).setVolume(level),
    local: () => ref.read(localPlayerProvider.notifier).setVolume(level),
  );

  Future<void> toggleMute() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).toggleMute(),
    local: () {
      final isMuted = state.asData?.value?.isMuted ?? false;
      return ref.read(localPlayerProvider.notifier).setMute(!isMuted);
    },
  );

  Future<void> toggleShuffle() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).toggleShuffle(),
    local: () {
      final current = state.asData?.value?.shuffleMode ?? ShuffleMode.off;
      final nextMode = current == ShuffleMode.off
          ? ShuffleMode.on
          : ShuffleMode.off;
      return ref.read(localPlayerProvider.notifier).setShuffle(nextMode);
    },
  );

  Future<void> playByIndex(int index) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).playByIndex(index),
    local: () => ref.read(localPlayerProvider.notifier).playByIndex(index),
  );

  Future<void> cycleRepeat() => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).cycleRepeat(),
    local: () {
      final current = state.asData?.value?.repeatMode ?? RepeatMode.off;
      final nextMode = switch (current) {
        RepeatMode.off => RepeatMode.playlist,
        RepeatMode.playlist => RepeatMode.track,
        RepeatMode.track => RepeatMode.off,
      };
      return ref.read(localPlayerProvider.notifier).setRepeat(nextMode);
    },
  );

  /// Replaces the Playing Now queue and starts playback immediately.
  Future<void> playNow(Tracks tracks) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).playNow(tracks),
    local: () => ref.read(localPlayerProvider.notifier).playNow(tracks),
  );

  /// Inserts [tracks] immediately after the current track.
  Future<void> playNext(Tracks tracks) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).playNext(tracks),
    local: () => ref.read(localPlayerProvider.notifier).playNext(tracks),
  );

  /// Appends [tracks] to the end of the Playing Now queue.
  Future<void> addToQueue(Tracks tracks) => _run(
    remote: () => ref.read(mcwsPlayerProvider.notifier).addToQueue(tracks),
    local: () => ref.read(localPlayerProvider.notifier).addToQueue(tracks),
  );

  Future<void> _run({
    required Future<void> Function() remote,
    required Future<void> Function() local,
    Zone? zoneToRun,
  }) async {
    final zone = zoneToRun ?? ref.read(activeZoneProvider);
    if (zone == null) return;

    if (zone.isLocal || zone.isOffline) {
      await local();
      // state is updated automatically via localPlaybackStateProvider watch
    } else {
      await remote();
      // state is updated automatically via mcwsPlayerProvider watch
    }
  }
}

@Riverpod(keepAlive: true)
class PlayingNowPosition extends _$PlayingNowPosition {
  @override
  int build() {
    final talker = getIt<Talker>();
    final playerStatus = ref.watch(playerProvider);
    return playerStatus.when(
      skipLoadingOnReload: true,
      data: (status) {
        talker.debug(
          '[playingNowPositionProvider] Current playingNowPosition: ${status?.playingNowPosition}',
        );
        return status?.playingNowPosition ?? -1;
      },
      error: (error, st) {
        talker.error(
          '[playingNowPositionProvider] Error occurred while fetching playingNowPosition: $error',
          st,
        );
        return -1;
      },
      loading: () {
        talker.debug('[playingNowPositionProvider] Loading playingNowPosition');
        return -1;
      },
    );
  }
}
