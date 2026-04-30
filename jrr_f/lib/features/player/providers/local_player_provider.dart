import 'dart:async';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/player/data/models/local_palyback_state.dart';
import 'package:jrr_f/features/player/services/local_player_service.dart';
import 'package:jrr_f/features/queue/data/repositories/local_queue_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../logging/talker_extensions.dart';

part 'local_player_provider.g.dart';

@Riverpod(keepAlive: true)
class LocalPlayer extends _$LocalPlayer {
  late LocalPlayerService _service;
  late Talker _talker;

  StreamSubscription<Duration>? _posSub;
  StreamSubscription<PlayerState>? _stateSub;
  StreamSubscription<SequenceState?>? _seqSub;
  StreamSubscription<PlaybackEvent>? _eventSub;
  StreamSubscription<double>? _volumeSub;
  StreamSubscription<Duration?>? _durationSub;

  @override
  LocalPlaybackState build() {
    _talker = getIt<Talker>();
    _talker.debug('[localPlayerProvider] Initializing provider');
    _service = getIt<LocalPlayerService>();

    _posSub = _service.positionStream.listen((pos) {
      _talker.debug(
        '[localPlayerProvider] Position updated: ${pos.inSeconds}s',
      );
      state = state.copyWith(position: pos);
    });

    _stateSub = _service.playerStateStream.listen((playerState) {
      _talker.debug(
        '[localPlayerProvider] PlayerState changed: playing=${playerState.playing}, processing=${playerState.processingState}',
      );
      state = state.copyWith(
        processingState: playerState.processingState,
        playing: playerState.playing,
      );
    });

    _seqSub = _service.sequenceStateStream.listen((sequenceState) {
      _talker.sequenceState(sequenceState);
      state = state.copyWith(sequenceState: sequenceState);
      _saveQueue();
    });

    _volumeSub = _service.volumeStream.listen((volume) {
      _talker.debug('[localPlayerProvider] Volume changed: volume=$volume');
      state = state.copyWith(volume: volume);
    });

    _durationSub = _service.durationStream.listen((duration) {
      _talker.debug(
        '[localPlayerProvider] Duration updated: duration=$duration',
      );
      state = state.copyWith(duration: duration);
    });

    _eventSub = _service.playbackEventStream.listen(
      (event) {
        _talker.debug('[localPlayerProvider] Playback event: $event');
      },
      onError: (Object e, StackTrace st) {
        _talker.error('[localPlayerProvider] Playback error stream', e, st);
      },
    );

    ref.onDispose(() {
      _talker.debug('[localPlayerProvider] Disposing provider');
      _posSub?.cancel();
      _stateSub?.cancel();
      _seqSub?.cancel();
      _eventSub?.cancel();
      _volumeSub?.cancel();
      _durationSub?.cancel();
    });

    _loadQueue();

    return const LocalPlaybackState(
      processingState: ProcessingState.idle,
      playing: false,
      position: Duration.zero,
      volume: 0.0,
      shuffleModeEnabled: false,
      loopMode: LoopMode.off,
    );
  }

  Future<void> _loadQueue() async {
    final localQueueRepo = getIt<LocalQueueRepository>();
    final queue = (await localQueueRepo.getTracks()).getOrElse((e) => throw e);
    _talker.debug(
      '[localPlayerProvider] Initial build, queue has ${queue.length} tracks',
    );
    setTracks(queue);
    _talker.debug(
      '[localPlayerProvider] Queue ready during build, set initial tracks: ${queue.length}',
    );
  }

  Future<void> _saveQueue() async {
    final localQueueRepo = getIt<LocalQueueRepository>();
    final queue = state.sequenceState?.sequence.map((e) => e.tag as Track).toList() ?? [];
    _talker.debug(
      '[localPlayerProvider] Saving queue has ${queue.length} tracks',
    );
    localQueueRepo.setTracks(queue);
    _talker.debug(
      '[localPlayerProvider] Queue saved tracks: ${queue.length}',
    );
  }

  // Transport delegates
  Future<void> playPause() {
    _talker.debug('[localPlayerProvider] Command: playPause (current playing=${_service.playing})');
    return _service.playPause();
  }

  Future<void> stop() {
    _talker.debug('[localPlayerProvider] Command: stop');
    return _service.stop();
  }

  Future<void> next() async {
    _talker.debug('[localPlayerProvider] Command: next');
    _service.next();
  }

  Future<void> previous() async {
    _talker.debug('[localPlayerProvider] Command: previous');
    _service.previous();
  }

  Future<void> seekTo(int positionMs) {
    _talker.debug('[localPlayerProvider] Command: seekTo ($positionMs ms)');
    return _service.seekTo(positionMs);
  }

  Future<void> setVolume(double level) {
    _talker.debug('[localPlayerProvider] Command: setVolume ($level)');
    return _service.setVolume(level);
  }

  Future<void> setMute(bool mute) {
    _talker.debug('[localPlayerProvider] Command: setMute ($mute)');
    return _service.setMute(mute);
  }

  Future<void> setShuffle(ShuffleMode mode) {
    _talker.debug('[localPlayerProvider] Command: setShuffle ($mode)');
    throw UnimplementedError('Shuffle mode not implemented for local player');
  }

  Future<void> setRepeat(RepeatMode mode) {
    _talker.debug('[localPlayerProvider] Command: setRepeat ($mode)');
    throw UnimplementedError('Repeat mode not implemented for local player');
  }

  Future<void> playByIndex(int index) async {
    _talker.debug('[localPlayerProvider] Command: playByIndex ($index)');
    await _service.playByIndex(index: index);
  }

  Future<void> setTracks(List<Track> tracks) async {
    _talker.info('[localPlayerProvider] Command: setTracks (${tracks.length} tracks)');
    await _service.setTracks(tracks);
  }

  Future<void> playNow(List<Track> tracks) async {
    _talker.info('[localPlayerProvider] Command: playNow (${tracks.length} tracks)');
    await _service.playNow(tracks);
  }

  Future<void> playNext(List<Track> tracks) async {
    _talker.info(
      '[localPlayerProvider] Command: playNext (${tracks.length} tracks)',
    );
    _service.insertTracksAt(tracks);
  }

  Future<void> addToQueue(List<Track> tracks) async {
    _talker.info('[localPlayerProvider] Command: addToQueue (${tracks.length} tracks)');
    await _service.addToQueue(tracks);
  }

  Future<void> moveTrack(int source, int target) async {
    throw UnimplementedError();
  }

  Future<void> removeTrack(int index) async {
    throw UnimplementedError();
  }
}
