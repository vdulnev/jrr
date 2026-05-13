import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../library/data/models/track.dart';
import '../../library/data/models/tracks.dart';
import '../../queue/data/repositories/local_queue_repository.dart';
import '../../zones/data/models/zone.dart';
import '../data/models/local_palyback_state.dart';
import '../data/models/playback_state.dart';
import '../data/models/player_state_data.dart';
import '../data/models/player_status.dart';
import '../data/models/sequence_state_data.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../services/local_player_service.dart';
import 'local_audio_quality_provider.dart';
import 'player_controller.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import '../../zones/providers/active_zone_provider.dart';

part 'local_player_provider.g.dart';

@Riverpod(keepAlive: true)
class LocalPlayerPosition extends _$LocalPlayerPosition {
  @override
  Duration build() {
    final service = getIt<LocalPlayerService>();
    final talker = getIt<Talker>();

    final sub = service.positionStream.listen(
      (pos) => state = pos,
      onError: (Object e, StackTrace st) => talker.error(e, st),
    );

    ref.onDispose(() => sub.cancel());

    return service.position;
  }
}

@Riverpod(keepAlive: true)
class LocalPlayerState extends _$LocalPlayerState {
  @override
  PlayerStateData build() {
    final service = getIt<LocalPlayerService>();
    final talker = getIt<Talker>();

    final sub = service.playerStateStream.listen(
      (s) => state = PlayerStateData(
        playing: s.playing,
        processingState: s.processingState,
      ),
      onError: (Object e, StackTrace st) => talker.error(e, st),
    );

    ref.onDispose(() => sub.cancel());

    return PlayerStateData(
      playing: service.playing,
      processingState: service.processingState,
    );
  }
}

@Riverpod(keepAlive: true)
class LocalPlayerSequence extends _$LocalPlayerSequence {
  @override
  SequenceStateData? build() {
    final service = getIt<LocalPlayerService>();
    final talker = getIt<Talker>();

    final sub = service.sequenceStateStream.listen((s) {
      if (s == null) {
        talker.debug('[localPlayerSequenceProvider] SequenceState: null');
        state = null;
        return;
      }
      String trackInfo;
      if (s.currentIndex != null &&
          s.currentIndex! >= 0 &&
          s.currentIndex! < s.sequence.length) {
        final element = s.sequence[s.currentIndex!];
        if (element.tag is Track) {
          final track = element.tag as Track;
          trackInfo =
              'name: ${track.name}, uri: ${(element is UriAudioSource) ? element.uri : 'none for ${s.runtimeType}'}';
        } else {
          trackInfo = 'none';
        }
      } else {
        trackInfo = 'none';
      }
      talker.debug(
        '[localPlayerSequenceProvider] SequenceState updated: '
        'currentIndex=${s.currentIndex}, '
        'sequenceLength=${s.sequence.length}, '
        'shuffleModeEnabled=${s.shuffleModeEnabled}, '
        'shuffleIndices=${s.shuffleIndices}, '
        'loopMode=${s.loopMode}, '
        'currentTrack=$trackInfo',
      );
      state = SequenceStateData(
        sequence: Tracks(
          tracks: s.sequence.map((e) => e.tag as Track).toList(),
        ),
        currentIndex: s.currentIndex ?? -1,
        shuffleIndices: s.shuffleIndices,
        shuffleModeEnabled: s.shuffleModeEnabled,
        loopMode: s.loopMode,
      );
    }, onError: (Object e, StackTrace st) => talker.error(e, st));

    ref.onDispose(() => sub.cancel());

    final current = service.sequenceState;
    if (current == null) return null;

    return SequenceStateData(
      sequence: Tracks(
        tracks: current.sequence.map((e) => e.tag as Track).toList(),
      ),
      currentIndex: current.currentIndex ?? -1,
      shuffleIndices: current.shuffleIndices,
      shuffleModeEnabled: current.shuffleModeEnabled,
      loopMode: current.loopMode,
    );
  }
}

@Riverpod(keepAlive: true)
class LocalPlayerVolume extends _$LocalPlayerVolume {
  @override
  double build() {
    final service = getIt<LocalPlayerService>();
    final talker = getIt<Talker>();

    final sub = service.volumeStream.listen(
      (v) => state = v,
      onError: (Object e, StackTrace st) => talker.error(e, st),
    );

    ref.onDispose(() => sub.cancel());

    return 1.0;
  }
}

@Riverpod(keepAlive: true)
class LocalPlayerDuration extends _$LocalPlayerDuration {
  @override
  Duration? build() {
    final service = getIt<LocalPlayerService>();
    final talker = getIt<Talker>();

    final sub = service.durationStream.listen(
      (d) => state = d,
      onError: (Object e, StackTrace st) => talker.error(e, st),
    );

    ref.onDispose(() => sub.cancel());

    return Duration.zero;
  }
}

/// Owns local (just_audio) playback and emits a [PlayerStatus] view of it.
///
/// Returns `null` when the active zone is missing or remote. The unified
/// [Player] provider watches this one for the local/offline branch.
@Riverpod(keepAlive: true)
class LocalPlayer extends _$LocalPlayer implements PlayerController {
  static String _kIndexKey(String zoneId) => 'local_player_${zoneId}_index';
  static String _kPositionMsKey(String zoneId) =>
      'local_player_${zoneId}_position_ms';
  static const _kVolumeKey = 'local_player_volume';

  late LocalPlayerService _service;
  late SharedPreferences _prefs;
  late Talker _talker;

  String _currentZoneId = '';

  bool _isReloading = false;
  bool _reloadRequestedDuringReload = false;

  @override
  FutureOr<PlayerStatus?> build() async {
    _service = getIt<LocalPlayerService>();
    _prefs = getIt<SharedPreferences>();
    _talker = getIt<Talker>();
    final queueRepo = getIt<LocalQueueRepository>();

    final activeZone = ref.watch(activeZoneProvider);
    final String newZoneId;
    if (activeZone == null) {
      newZoneId = 'local';
    } else if (activeZone.isOffline) {
      newZoneId = 'offline';
    } else if (activeZone.isAndroidAuto) {
      newZoneId = 'android-auto';
    } else if (activeZone.isLocal) {
      newZoneId = 'local';
    } else {
      // Remote zone. We don't strictly need to swap, but let's keep 'local'
      // as the default state for the local player.
      newZoneId = 'local';
    }

    _talker.debug(
      '[LocalPlayer] build: activeZone=${activeZone?.name}, newZoneId=$newZoneId, _currentZoneId=$_currentZoneId',
    );

    // Initial load or swap
    if (newZoneId != _currentZoneId) {
      _talker.info(
        '[LocalPlayer] Zone changed from "$_currentZoneId" to "$newZoneId". Swapping queues...',
      );
      _currentZoneId = newZoneId;
      await _loadQueue(_currentZoneId);
    }

    // Register listeners for the CURRENT zone.
    // These will be disposed and recreated if build() re-runs.

    ref.listen(localPlayerSequenceProvider.select((seq) => seq?.currentIndex), (
      prev,
      next,
    ) {
      if (prev != next && next != null) {
        _talker.debug(
          '[LocalPlayer] [$_currentZoneId] Current index changed: $next',
        );
        queueRepo.setCurrentIndex(_currentZoneId, next);
        _prefs.setInt(_kIndexKey(_currentZoneId), next);
        _prefs.setInt(_kPositionMsKey(_currentZoneId), 0);
      }
    });

    final posSub = _service.positionStream.listen((pos) {
      _prefs.setInt(_kPositionMsKey(_currentZoneId), pos.inMilliseconds);
    });
    ref.onDispose(posSub.cancel);

    final volSub = _service.volumeStream.listen((vol) {
      _prefs.setDouble(_kVolumeKey, vol);
    });
    ref.onDispose(volSub.cancel);

    ref.listen(localPlayerSequenceProvider.select((seq) => seq?.sequence), (
      prev,
      next,
    ) {
      if (prev != next && next != null) {
        _talker.debug(
          '[LocalPlayer] [$_currentZoneId] Sequence changed. Saving queue with ${next.length} tracks.',
        );
        _saveQueue(_currentZoneId, next);
      }
    });

    // Listen for quality changes to trigger a reload
    ref.listen(localAudioQualityPrefProvider, (prev, next) {
      if (prev != next && prev != null) {
        _talker.info(
          '[LocalPlayer] [$_currentZoneId] Audio quality changed to ${next.label}. Reloading queue...',
        );
        _reloadWithNewQuality();
      }
    });

    // Listen for downloads-set changes:
    // - Additions: reload so the queue switches to local-file sources.
    // - Removals on the Local zone: reload so the queue swaps the deleted
    //   local files back to streaming URLs (the track stays playable).
    // - Removals on the Offline zone: drop the tracks from the queue —
    //   there is no streaming fallback offline.
    ref.listen(downloadedTracksProvider, (prev, next) {
      final prevTracks = prev?.value ?? const [];
      final nextTracks = next.value ?? const [];

      final prevKeys = prevTracks.map((t) => t.track.fileKey).toSet();
      final nextKeys = nextTracks.map((t) => t.track.fileKey).toSet();

      final addedKeys = nextKeys.difference(prevKeys);
      final removedKeys = prevKeys.difference(nextKeys);

      if (addedKeys.isNotEmpty) {
        // Optimization: only reload if one of the added tracks is in our current queue
        final currentQueueKeys = _service.sequence
            .map((s) => (s.tag as Track).fileKey)
            .toSet();

        final hasRelevantAddition = addedKeys.any(
          (key) => currentQueueKeys.contains(key),
        );

        if (hasRelevantAddition) {
          _talker.info(
            '[LocalPlayer] [$_currentZoneId] ${addedKeys.length} new download(s). '
            'Reloading queue to prefer local files...',
          );
          _reloadWithNewQuality();
          return;
        } else {
          _talker.debug(
            '[LocalPlayer] [$_currentZoneId] ${addedKeys.length} new download(s), '
            'none in current queue. Skipping reload.',
          );
        }
      }

      if (removedKeys.isNotEmpty) {
        if (_currentZoneId == 'offline') {
          _talker.info(
            '[LocalPlayer] [offline] ${removedKeys.length} download(s) '
            'deleted. Removing from queue (no streaming fallback): '
            '$removedKeys',
          );
          _removeTracksByFileKeys(removedKeys);
        } else {
          _talker.info(
            '[LocalPlayer] [$_currentZoneId] ${removedKeys.length} '
            'download(s) deleted. Reloading queue to swap to streaming '
            'URLs: $removedKeys',
          );
          _reloadWithNewQuality();
        }
      }
    });

    // Push status updates whenever local playback state changes. Using
    // `ref.listen` (not `ref.watch`) so position ticks don't re-run build —
    // re-running would re-attach all the listeners above and re-load the
    // queue.
    ref.listen(localPlaybackStateProvider, (_, next) {
      final currentZone = ref.read(activeZoneProvider);
      if (currentZone == null ||
          (!currentZone.isLocal &&
              !currentZone.isOffline &&
              !currentZone.isAndroidAuto)) {
        return;
      }
      state = AsyncData(_calculateStatus(currentZone, next));
    });

    final sub = _service.playbackEventStream.listen(
      (event) {
        final icy = event.icyMetadata;
        final info = icy?.info;
        final headers = icy?.headers;
        _talker.debug(
          '[LocalPlayer] [$_currentZoneId] Playback event details: '
          'processingState: ${event.processingState}, '
          'updatePosition: ${event.updatePosition}, '
          'updateTime: ${event.updateTime}, '
          'bufferedPosition: ${event.bufferedPosition}, '
          'icy.info.title: ${info?.title}, '
          'icy.info.url: ${info?.url}, '
          'icy.headers.name: ${headers?.name}, '
          'icy.headers.genre: ${headers?.genre}, '
          'icy.headers.url: ${headers?.url}, '
          'icy.headers.bitrate: ${headers?.bitrate}, '
          'icy.headers.metadataInterval: ${headers?.metadataInterval}, '
          'icy.headers.isPublic: ${headers?.isPublic}',
        );
      },
      onError: (Object e, StackTrace st) {
        final current = _service.sequence.isNotEmpty
            ? _service.sequence
                  .elementAtOrNull(_service.sequenceState?.currentIndex ?? -1)
                  ?.tag
            : null;
        if (e is PlayerException) {
          _talker.error(
            '[LocalPlayer] [$_currentZoneId] PlayerException code=${e.code} '
            'message=${e.message} currentTag=$current',
            e,
            st,
          );
        } else if (e is PlayerInterruptedException) {
          _talker.error(
            '[LocalPlayer] [$_currentZoneId] PlayerInterruptedException message=${e.message}',
            e,
            st,
          );
        } else {
          _talker.error(
            '[LocalPlayer] [$_currentZoneId] Unknown playback error type=${e.runtimeType} '
            'currentTag=$current',
            e,
            st,
          );
        }
      },
    );
    ref.onDispose(sub.cancel);

    // Initial status snapshot.
    if (activeZone == null ||
        (!activeZone.isLocal &&
            !activeZone.isOffline &&
            !activeZone.isAndroidAuto)) {
      return null;
    }
    return _calculateStatus(activeZone, ref.read(localPlaybackStateProvider));
  }

  PlayerStatus _calculateStatus(
    Zone zone,
    LocalPlaybackState localPlaybackState,
  ) {
    final seqState = localPlaybackState.sequenceState;
    final currentIndex = seqState?.currentIndex ?? -1;
    final sequence = seqState?.sequence ?? Tracks.empty;

    final currentTrack = seqState?.currentTrack;

    final processingState = localPlaybackState.playerState.processingState;
    final playing = localPlaybackState.playerState.playing;

    PlaybackState playbackState;
    if (processingState == ProcessingState.idle) {
      playbackState = PlaybackState.stopped;
    } else if (playing) {
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
      zoneId: zone.id,
      zoneName: zone.name,
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
      shuffleMode: (seqState?.shuffleModeEnabled ?? false)
          ? ShuffleMode.on
          : ShuffleMode.off,
      repeatMode: switch (seqState?.loopMode ?? LoopMode.off) {
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

  Future<void> _loadQueue(String zoneId) async {
    _talker.info('[LocalPlayer] Loading queue for $zoneId');
    final queueRepo = getIt<LocalQueueRepository>();
    final tracks = (await queueRepo.getTracks(
      zoneId,
    )).getOrElse((e) => Tracks.empty);

    // Stop current playback before swapping
    await _service.stop();

    await _service.setTracks(tracks);
    _talker.debug(
      '[LocalPlayer] [$zoneId] Loaded queue with ${tracks.length} tracks',
    );

    final savedIndex = _prefs.getInt(_kIndexKey(zoneId)) ?? -1;
    final savedPosMs = _prefs.getInt(_kPositionMsKey(zoneId)) ?? 0;
    _talker.debug(
      '[LocalPlayer] [$zoneId] Captured saved state: index=$savedIndex, posMs=$savedPosMs',
    );

    if (tracks.isNotEmpty && savedIndex >= 0 && savedIndex < tracks.length) {
      _talker.debug(
        '[LocalPlayer] [$zoneId] Restoring position: index=$savedIndex, posMs=$savedPosMs',
      );
      await _service.seekTo(savedPosMs, index: savedIndex);
    }

    final savedVolume = _prefs.getDouble(_kVolumeKey);
    if (savedVolume != null) {
      await _service.setVolume(savedVolume);
    }
  }

  Future<void> _saveQueue(String zoneId, Tracks tracks) async {
    final queueRepo = getIt<LocalQueueRepository>();
    await queueRepo.setTracks(zoneId, tracks);
    _talker.debug(
      '[LocalPlayer] [$zoneId] Saved queue with ${tracks.length} tracks',
    );
  }

  Future<void> _removeTracksByFileKeys(Set<int> fileKeys) async {
    final sequence = _service.sequence;
    if (sequence.isEmpty) return;

    // Walk in reverse so removals don't shift indices we still need to inspect.
    for (var i = sequence.length - 1; i >= 0; i--) {
      final tag = sequence[i].tag;
      if (tag is Track && fileKeys.contains(tag.fileKey)) {
        await _service.removeTrack(i);
      }
    }
  }

  Future<void> _reloadWithNewQuality() async {
    if (_isReloading) {
      _talker.debug(
        '[LocalPlayer] Reload already in progress. Queueing another...',
      );
      _reloadRequestedDuringReload = true;
      return;
    }

    _isReloading = true;
    try {
      final sequence = ref.read(localPlayerSequenceProvider);
      if (sequence == null) return;

      final wasPlaying = ref.read(localPlayerStateProvider).playing;
      final currentIndex = sequence.currentIndex;
      final currentPositionMs = _service.position.inMilliseconds;

      _talker.debug(
        '[LocalPlayer] [$_currentZoneId] Reloading queue. '
        'currentIndex=$currentIndex, '
        'sequenceLength=${sequence.sequence.length}, '
        'shuffleModeEnabled=${sequence.shuffleModeEnabled}, '
        'shuffleIndices=${sequence.shuffleIndices}, '
        'loopMode=${sequence.loopMode}, '
        'currentTrack=${sequence.currentTrack?.name ?? 'none'}, '
        'position=$currentPositionMs ms, '
        'playing=$wasPlaying',
      );

      // Stop and reload
      await _service.stop();
      await _service.setTracks(sequence.sequence);

      // Restore state
      if (currentIndex >= 0 && currentIndex < sequence.sequence.length) {
        await _service.seekTo(currentPositionMs, index: currentIndex);
      }

      if (wasPlaying) {
        await _service.play();
      }
    } finally {
      _isReloading = false;
      if (_reloadRequestedDuringReload) {
        _talker.debug(
          '[LocalPlayer] [$_currentZoneId] Executing queued reload...',
        );
        _reloadRequestedDuringReload = false;
        // Schedule next reload
        Future.microtask(() => _reloadWithNewQuality());
      }
    }
  }

  // ---- PlayerController surface --------------------------------------------

  @override
  Future<void> playPause() => _service.playPause();

  /// [zoneToRun] is ignored — there's only one local audio service.
  @override
  Future<void> stop({Zone? zoneToRun}) => _service.stop();

  @override
  Future<void> next() async => _service.next();

  @override
  Future<void> previous() async => _service.previous();

  @override
  Future<void> seekTo(int positionMs) => _service.seekTo(positionMs);

  @override
  Future<void> setVolume(double level) => _service.setVolume(level);

  @override
  Future<void> playByIndex(int index) => _service.playByIndex(index);

  @override
  Future<void> toggleMute() async {
    final isMuted = state.asData?.value?.isMuted ?? false;
    await _service.setMute(!isMuted);
  }

  @override
  Future<void> toggleShuffle() async {
    final current = state.asData?.value?.shuffleMode ?? ShuffleMode.off;
    final nextMode = current == ShuffleMode.off
        ? ShuffleMode.on
        : ShuffleMode.off;
    await _service.setShuffle(nextMode);
  }

  @override
  Future<void> cycleRepeat() async {
    final current = state.asData?.value?.repeatMode ?? RepeatMode.off;
    final nextMode = switch (current) {
      RepeatMode.off => RepeatMode.playlist,
      RepeatMode.playlist => RepeatMode.track,
      RepeatMode.track => RepeatMode.off,
    };
    await _service.setRepeat(nextMode);
  }

  @override
  Future<void> playNow(Tracks tracks) => _service.playNow(tracks);

  @override
  Future<void> playNext(Tracks tracks) async {
    final currentIndex = _service.sequenceState?.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await _service.insertTracksAt(tracks: tracks, index: insertIndex);
  }

  @override
  Future<void> addToQueue(Tracks tracks) async {
    await _service.addToQueue(tracks);
  }

  /// State updates push via stream subscriptions, so there's nothing to pull.
  @override
  Future<void> refresh() async {}

  // ---- Queue ops (not part of PlayerController) ----------------------------

  Future<void> setTracks(Tracks tracks) async {
    await _service.setTracks(tracks);
  }

  Future<void> moveTrack(int source, int target) async {
    await _service.moveTrack(source, target);
  }

  Future<void> removeTrack(int index) async {
    await _service.removeTrack(index);
  }
}

@Riverpod(keepAlive: true)
LocalPlaybackState localPlaybackState(Ref ref) {
  final pos = ref.watch(localPlayerPositionProvider);
  final playerState = ref.watch(localPlayerStateProvider);
  final seq = ref.watch(localPlayerSequenceProvider);
  final vol = ref.watch(localPlayerVolumeProvider);
  final dur = ref.watch(localPlayerDurationProvider);

  return LocalPlaybackState(
    position: pos,
    playerState: playerState,
    sequenceState: seq,
    volume: vol,
    duration: dur,
  );
}
