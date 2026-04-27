import 'dart:async';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/player/data/models/local_palyback_state.dart';
import 'package:jrr_f/features/queue/providers/local_queue_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';

part 'local_player_provider.g.dart';

@Riverpod(keepAlive: true)
class LocalPlayer extends _$LocalPlayer {
  late AudioPlayer _player;
  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<SequenceState?>? _seqSub;
  StreamSubscription<PlaybackEvent>? _eventSub;

  @override
  LocalPlaybackState build() {
    _player = getIt<AudioPlayer>();

    _posSub = _player.positionStream.listen((_) => _updateState());
    _stateSub = _player.playerStateStream.listen((state) {
      getIt<Talker>().debug(
        '[LocalPlayer] PlayerState: ${state.processingState}, playing: ${state.playing}',
      );
      _updateState();
    });
    _seqSub = _player.sequenceStateStream.listen((state) {
      getIt<Talker>().debug(
        '[LocalPlayer] SequenceState updated: ${state.currentIndex}',
      );
      _updateState();
    });

    _eventSub = _player.playbackEventStream.listen(
      (event) {
        getIt<Talker>().debug(
          '[LocalPlayer] PlaybackEvent: ${event.processingState}',
        );
      },
      onError: (Object e, StackTrace st) {
        getIt<Talker>().error('[LocalPlayer] Playback error', e, st);
      },
    );

    ref.onDispose(() {
      _posSub?.cancel();
      _stateSub?.cancel();
      _seqSub?.cancel();
      _eventSub?.cancel();
    });

    return LocalPlaybackState(
      sequenceState: _player.sequenceState,
      processingState: _player.processingState,
      playing: _player.playing,
      position: _player.position,
      duration: _player.duration,
      volume: _player.volume,
      shuffleModeEnabled: _player.shuffleModeEnabled,
      loopMode: _player.loopMode,
    );
  }

  void _updateState() {
    state = LocalPlaybackState(
      sequenceState: _player.sequenceState,
      processingState: _player.processingState,
      playing: _player.playing,
      position: _player.position,
      duration: _player.duration,
      volume: _player.volume,
      shuffleModeEnabled: _player.shuffleModeEnabled,
      loopMode: _player.loopMode,
    );
  }

  // Transport delegates
  Future<void> playPause() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> stop() => _player.stop();
  Future<void> next() => _player.seekToNext();
  Future<void> previous() => _player.seekToPrevious();
  Future<void> seekTo(int positionMs) =>
      _player.seek(Duration(milliseconds: positionMs));
  Future<void> setVolume(double level) => _player.setVolume(level / 100);
  Future<void> setMute(bool mute) => _player.setVolume(mute ? 0 : 1.0);
  Future<void> setShuffle(ShuffleMode mode) =>
      _player.setShuffleModeEnabled(mode == ShuffleMode.on);
  Future<void> setRepeat(RepeatMode mode) => _player.setLoopMode(switch (mode) {
    RepeatMode.off => LoopMode.off,
    RepeatMode.track => LoopMode.one,
    RepeatMode.playlist => LoopMode.all,
  });

  Future<void> playByIndex(int index) async {
    final track = ref.read(localQueueProvider).value?[index];
    getIt<Talker>().debug(
      '[LocalPlayer] playByIndex: index=$index, track=$track',
    );
    if (track == null) return;
    return playByKey(track.fileKey);
  }

  Future<void> playByKey(int fileKey) =>
      throw UnimplementedError('playByKey is not implemented for LocalPlayer');

  Future<void> playNow(List<Track> tracks) async {
    await stop();
    final localQueue = ref.read(localQueueProvider.notifier);
    await localQueue.clear();
    await localQueue.addTracks(tracks);
    playByIndex(0);
  }

  Future<void> playNext(List<Track> tracks) async {}

  Future<void> addToQueue(List<Track> tracks) async {}
}
