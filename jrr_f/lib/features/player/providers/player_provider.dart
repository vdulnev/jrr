import 'dart:async' hide Zone;
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/repositories/library_repository.dart';
import 'package:jrr_f/features/player/data/models/local_palyback_state.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../data/repositories/player_repository.dart';
import 'local_player_provider.dart';

part 'player_provider.g.dart';

@Riverpod(keepAlive: true)
class Player extends _$Player {
  @override
  FutureOr<PlayerStatus?> build() async {
    ref.listen(activeZoneProvider, (oldZone, _) {
      if (oldZone != null) {
        stop(zoneToRun: oldZone);
      }
    });

    final zone = ref.watch(activeZoneProvider);
    if (zone == null) {
      return null;
    }

    if (zone.isLocal) {
      // Watch the local player provider and pipe its state into this one.
      final localPlaybackState = ref.watch(localPlayerProvider);
      return _calculateStatus(localPlaybackState);
    }

    final result = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
    return result.getOrElse((e) => throw e);
  }

  PlayerStatus _calculateStatus(LocalPlaybackState localPlaybackState) {
    final seqState = localPlaybackState.sequenceState;
    final currentSource = seqState?.currentSource;
    final currentIndex = seqState?.currentIndex ?? -1;
    final sequence = seqState?.sequence ?? [];

    final currentTrack = currentSource?.tag as Track?;

    final processingState = localPlaybackState.processingState;

    PlaybackState playbackState;
    if (processingState == ProcessingState.idle) {
      playbackState = PlaybackState.stopped;
    } else if (localPlaybackState.playing) {
      playbackState = PlaybackState.playing;
    } else {
      playbackState = PlaybackState.paused;
    }

    String statusText = '';
    if (processingState == ProcessingState.buffering) {
      statusText = 'Buffering...';
    } else if (processingState == ProcessingState.loading) {
      statusText = 'Loading...';
    }

    return PlayerStatus(
      zoneId: 'local',
      zoneName: 'Local',
      state: playbackState,
      fileKey: currentTrack?.fileKey ?? -1,
      positionMs: localPlaybackState.position.inMilliseconds,
      durationMs: localPlaybackState.duration?.inMilliseconds ?? 0,
      positionDisplay: _formatDuration(localPlaybackState.position),
      playingNowPosition: currentIndex,
      playingNowTracks: sequence.length,
      playingNowPositionDisplay: currentIndex > -1
          ? '${currentIndex + 1} of ${sequence.length}'
          : '',
      playingNowChangeCounter: 0,
      volume: localPlaybackState.volume,
      volumeDisplay: '${(localPlaybackState.volume * 100).toInt()}%',
      isMuted: localPlaybackState.volume == 0,
      name: currentTrack?.name ?? '',
      artist: currentTrack?.artist ?? '',
      album: currentTrack?.album ?? '',
      imageUrl: currentTrack?.imageUrl ?? '',
      status: statusText,
      shuffleMode: localPlaybackState.shuffleModeEnabled
          ? ShuffleMode.on
          : ShuffleMode.off,
      repeatMode: switch (localPlaybackState.loopMode) {
        LoopMode.off => RepeatMode.off,
        LoopMode.one => RepeatMode.track,
        LoopMode.all => RepeatMode.playlist,
      },
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Silently refreshes player status without showing a loading state.
  Future<void> refresh() async {
    final zone = ref.read(activeZoneProvider);
    if (zone == null || zone.isLocal) return;

    final result = await AsyncValue.guard(() async {
      final r = await getIt<PlayerRepository>().getPlaybackInfo(zone.id);
      return r.getOrElse((e) => throw e);
    });
    state = result;
  }

  // -------------------------------------------------------------------------
  // Commands — each fires the command then refreshes state.
  // -------------------------------------------------------------------------

  Future<void> playPause() => _run(
    remote: (id) => getIt<PlayerRepository>().playPause(id),
    local: () => ref.read(localPlayerProvider.notifier).playPause(),
  );

  Future<void> stop({Zone? zoneToRun}) => _run(
    remote: (id) => getIt<PlayerRepository>().stop(id),
    local: () => ref.read(localPlayerProvider.notifier).stop(),
    zoneToRun: zoneToRun,
  );

  Future<void> next() => _run(
    remote: (id) => getIt<PlayerRepository>().next(id),
    local: () => ref.read(localPlayerProvider.notifier).next(),
  );

  Future<void> previous() => _run(
    remote: (id) => getIt<PlayerRepository>().previous(id),
    local: () => ref.read(localPlayerProvider.notifier).previous(),
  );

  Future<void> seekTo(int positionMs) => _run(
    remote: (id) => getIt<PlayerRepository>().setPosition(id, positionMs),
    local: () => ref.read(localPlayerProvider.notifier).seekTo(positionMs),
  );

  Future<void> setVolume(double level) => _run(
    remote: (id) => getIt<PlayerRepository>().setVolume(id, level),
    local: () => ref.read(localPlayerProvider.notifier).setVolume(level),
  );

  Future<void> toggleMute() async {
    final isMuted = state.asData?.value?.isMuted ?? false;
    await _run(
      remote: (id) => getIt<PlayerRepository>().setMute(id, mute: !isMuted),
      local: () => ref.read(localPlayerProvider.notifier).setMute(!isMuted),
    );
  }

  Future<void> toggleShuffle() async {
    final current = state.asData?.value?.shuffleMode ?? ShuffleMode.off;
    final nextMode = current == ShuffleMode.off
        ? ShuffleMode.on
        : ShuffleMode.off;
    await _run(
      remote: (id) => getIt<PlayerRepository>().setShuffle(id, nextMode),
      local: () => ref.read(localPlayerProvider.notifier).setShuffle(nextMode),
    );
  }

  Future<void> playByIndex(int index) => _run(
    remote: (id) => getIt<PlayerRepository>().playByIndex(id, index),
    local: () => ref.read(localPlayerProvider.notifier).playByIndex(index),
  );

  Future<void> cycleRepeat() async {
    final current = state.asData?.value?.repeatMode ?? RepeatMode.off;
    final nextMode = switch (current) {
      RepeatMode.off => RepeatMode.playlist,
      RepeatMode.playlist => RepeatMode.track,
      RepeatMode.track => RepeatMode.off,
    };
    await _run(
      remote: (id) => getIt<PlayerRepository>().setRepeat(id, nextMode),
      local: () => ref.read(localPlayerProvider.notifier).setRepeat(nextMode),
    );
  }

  /// Replaces the Playing Now queue and starts playback immediately.
  Future<void> playNow(List<Track> tracks) => _run(
    remote: (_) {
      final zone = ref.read(activeZoneProvider);
      getIt<Talker>().debug(
        '[PlayerProvider] playNow: zone=$zone, tracks=$tracks',
      );
      if (zone == null) return Future.value();
      return getIt<LibraryRepository>().playNow(
        zone.id,
        tracks.map((t) => t.fileKey).toList(),
      );
    },
    local: () async {
      var provider = ref.read(localPlayerProvider.notifier);
      await provider.playNow(tracks);
    },
  );

  /// Inserts [fileKeys] immediately after the current track.
  Future<void> playNext(List<Track> tracks) => _run(
    remote: (_) {
      final zone = ref.read(activeZoneProvider);
      getIt<Talker>().debug(
        '[PlayerProvider] playNext: zone=$zone, tracks=$tracks',
      );
      if (zone == null) return Future.value();
      return getIt<LibraryRepository>().playNext(
        zone.id,
        tracks.map((t) => t.fileKey).toList(),
      );
    },
    local: () => ref.read(localPlayerProvider.notifier).playNext(tracks),
  );

  /// Appends [fileKeys] to the end of the Playing Now queue.
  Future<void> addToQueue(List<Track> tracks) {
    final zone = ref.read(activeZoneProvider);
    getIt<Talker>().debug(
      '[PlayerProvider] addToQueue: zone=$zone, tracks=$tracks',
    );
    if (zone == null) return Future.value();
    return _run(
      remote: (_) => getIt<LibraryRepository>().addToQueue(
        zone.id,
        tracks.map((t) => t.fileKey).toList(),
      ),
      local: () => ref.read(localPlayerProvider.notifier).addToQueue(tracks),
    );
  }

  Future<void> _run({
    required Future<dynamic> Function(String zoneId) remote,
    required Future<dynamic> Function() local,
    Zone? zoneToRun,
  }) async {
    final zone = zoneToRun ?? ref.read(activeZoneProvider);
    if (zone == null) return;

    if (zone.isLocal) {
      await local();
      // state is updated automatically via localPlayerProvider watch
    } else {
      await remote(zone.id);
      await refresh();
    }
  }
}
