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
import '../data/models/local_palyback_state.dart';
import '../data/models/player_state_data.dart';
import '../data/models/sequence_state_data.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../services/local_player_service.dart';

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
        state = null;
        return;
      }
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

@Riverpod(keepAlive: true)
class LocalPlayer extends _$LocalPlayer {
  static const _kIndexKey = 'local_player_index';
  static const _kPositionMsKey = 'local_player_position_ms';

  late final LocalPlayerService _service;
  late final SharedPreferences _prefs;
  late final Talker _talker;
  bool _restored = false;

  @override
  void build() {
    _service = getIt<LocalPlayerService>();
    _prefs = getIt<SharedPreferences>();
    _talker = getIt<Talker>();
    final queueRepo = getIt<LocalQueueRepository>();

    _loadQueue();

    // Persist currentIndex on changes
    ref.listen(localPlayerSequenceProvider.select((seq) => seq?.currentIndex), (
      prev,
      next,
    ) {
      if (!_restored) return;
      if (prev != next && next != null) {
        _talker.debug('[LocalPlayer] Current index changed: $next');
        queueRepo.setCurrentIndex(next);
        _prefs.setInt(_kIndexKey, next);
        _prefs.setInt(_kPositionMsKey, 0);
      }
    });

    // Track latest position; persist periodically so restart can resume.
    final posSub = _service.positionStream.listen((pos) {
      if (!_restored) return;
      _prefs.setInt(_kPositionMsKey, pos.inMilliseconds);
      _talker.debug('[LocalPlayer] Position saved: $pos');
    });

    ref.onDispose(() {
      posSub.cancel();
    });

    // Persist queue changes
    ref.listen(localPlayerSequenceProvider.select((seq) => seq?.sequence), (
      prev,
      next,
    ) {
      if (prev != next && next != null) {
        _talker.debug(
          '[LocalPlayer] Sequence changed. Saving queue with ${next.length} tracks.',
        );
        _saveQueue(next);
      }
    });

    final sub = _service.playbackEventStream.listen(
      // Playback events
      (event) {
        final icy = event.icyMetadata;
        final info = icy?.info;
        final headers = icy?.headers;
        _talker.debug(
          '[LocalPlayer] Playback event details: '
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
            '[LocalPlayer] PlayerException code=${e.code} '
            'message=${e.message} currentTag=$current',
            e,
            st,
          );
        } else if (e is PlayerInterruptedException) {
          _talker.error(
            '[LocalPlayer] PlayerInterruptedException message=${e.message}',
            e,
            st,
          );
        } else {
          _talker.error(
            '[LocalPlayer] Unknown playback error type=${e.runtimeType} '
            'currentTag=$current',
            e,
            st,
          );
        }
      },
    );
    ref.onDispose(() => sub.cancel());
  }

  Future<void> _loadQueue() async {
    final queueRepo = getIt<LocalQueueRepository>();
    final tracks = (await queueRepo.getTracks()).getOrElse((e) => Tracks.empty);

    await _service.setTracks(tracks);
    _talker.debug('[LocalPlayer] Loaded queue with ${tracks.length} tracks');
    
    final savedIndex = _prefs.getInt(_kIndexKey) ?? -1;
    final savedPosMs = _prefs.getInt(_kPositionMsKey) ?? 0;
    _talker.debug(
      '[LocalPlayer] Captured saved state: index=$savedIndex, posMs=$savedPosMs',
    );

    if (tracks.isNotEmpty && savedIndex >= 0 && savedIndex < tracks.length) {
      _talker.debug(
        '[LocalPlayer] Restoring position: index=$savedIndex, posMs=$savedPosMs',
      );
      await _service.seekTo(savedPosMs, index: savedIndex);
    }
    _restored = true;
  }

  Future<void> _saveQueue(Tracks tracks) async {
    final queueRepo = getIt<LocalQueueRepository>();
    await queueRepo.setTracks(tracks);
    _talker.debug('[LocalPlayer] Saved queue with ${tracks.length} tracks');
  }

  // Actions only
  Future<void> playPause() => _service.playPause();
  Future<void> stop() => _service.stop();
  Future<void> next() async => _service.next();
  Future<void> previous() async => _service.previous();
  Future<void> seekTo(int positionMs) => _service.seekTo(positionMs);
  Future<void> setVolume(double level) => _service.setVolume(level);
  Future<void> setMute(bool mute) => _service.setMute(mute);
  Future<void> setShuffle(ShuffleMode mode) => _service.setShuffle(mode);
  Future<void> setRepeat(RepeatMode mode) => _service.setRepeat(mode);
  Future<void> playByIndex(int index) => _service.playByIndex(index);

  Future<void> playNow(Tracks tracks) async {
    await _service.playNow(tracks);
  }

  Future<void> playNext(Tracks tracks) async {
    final currentIndex = _service.sequenceState?.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    _service.insertTracksAt(tracks: tracks, index: insertIndex);
  }

  Future<void> addToQueue(Tracks tracks) async {
    _service.addToQueue(tracks);
  }

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
