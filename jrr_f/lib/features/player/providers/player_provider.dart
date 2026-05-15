import 'dart:async' hide Zone;
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import 'local_player_provider.dart';
import 'mcws_player_provider.dart';
import 'player_controller.dart';

part 'player_provider.g.dart';

/// Unified player provider. Resolves the active [PlayerController]
/// implementation from [activeZoneProvider] and forwards every command to it,
/// so call sites never branch on zone locality.
@Riverpod(keepAlive: true)
class Player extends _$Player {
  PlayerController _controllerFor(Zone? zone) {
    // Local, Offline, and Android Auto all share the localPlayerProvider
    // (which switches between specialized services). Only true remote
    // zones reach the MCWS controller.
    final isLocal =
        zone == null || zone.isLocal || zone.isOffline || zone.isAndroidAuto;
    return isLocal
        ? ref.read(localPlayerProvider.notifier)
        : ref.read(mcwsPlayerProvider.notifier);
  }

  PlayerController get _active => _controllerFor(ref.read(activeZoneProvider));

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
    if (zone == null) return null;

    getIt<Talker>().debug(
      '[PlayerProvider] build: zone=${zone.name} (id=${zone.id}, isLocal=${zone.isLocal}, isOffline=${zone.isOffline}, isAndroidAuto=${zone.isAndroidAuto})',
      '[PlayerProvider] build: zone=${zone.name} (id=${zone.id}, isLocal=${zone.isLocal}, isOffline=${zone.isOffline}, isAndroidAuto=${zone.isAndroidAuto})',
    );

    // Pipe state through the active transport. Both branches return
    // AsyncValue<PlayerStatus?>; awaiting `.future` re-fires this build
    // whenever the underlying notifier emits a new value.
    return (zone.isLocal || zone.isOffline || zone.isAndroidAuto)
        ? await ref.watch(localPlayerProvider.future)
        : await ref.watch(mcwsPlayerProvider.future);
  }

  // -------------------------------------------------------------------------
  // PlayerController forwarding — one-liners, no per-call dispatch.
  // -------------------------------------------------------------------------

  Future<void> refresh() => _active.refresh();
  Future<void> playPause() => _active.playPause();
  Future<void> next() => _active.next();
  Future<void> previous() => _active.previous();
  Future<void> seekTo(int positionMs) => _active.seekTo(positionMs);
  Future<void> setVolume(double level) => _active.setVolume(level);
  Future<void> toggleMute() => _active.toggleMute();
  Future<void> toggleShuffle() => _active.toggleShuffle();
  Future<void> playByIndex(int index) => _active.playByIndex(index);
  Future<void> cycleRepeat() => _active.cycleRepeat();
  Future<void> playNow(Tracks tracks) => _active.playNow(tracks);
  Future<void> playNext(Tracks tracks) => _active.playNext(tracks);
  Future<void> addToQueue(Tracks tracks) => _active.addToQueue(tracks);

  /// [zoneToRun] overrides the dispatch target so the active-zone listener
  /// can stop the previous zone after [activeZoneProvider] has already moved
  /// on.
  Future<void> stop({Zone? zoneToRun}) => _controllerFor(
    zoneToRun ?? ref.read(activeZoneProvider),
  ).stop(zoneToRun: zoneToRun);
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
