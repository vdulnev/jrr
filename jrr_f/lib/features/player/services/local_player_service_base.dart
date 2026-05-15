import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../../library/data/models/tracks.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';

/// Common interface for local-like playback services (Local and Android Auto).
abstract class LocalPlayerServiceBase extends BaseAudioHandler {
  // just_audio state
  SequenceState? get sequenceState;
  ProcessingState get processingState;
  bool get playing;
  Duration get position;
  bool get shuffleModeEnabled;
  LoopMode get loopMode;
  List<IndexedAudioSource> get sequence;

  // just_audio streams
  Stream<Duration> get positionStream;
  Stream<PlayerState> get playerStateStream;
  Stream<SequenceState?> get sequenceStateStream;
  Stream<PlaybackEvent> get playbackEventStream;
  Stream<double> get volumeStream;
  Stream<Duration?> get durationStream;

  // Transport
  Future<void> setTracks(Tracks tracks);
  Future<void> playNow(Tracks tracks);
  Future<void> playPause();
  Future<void> seekTo(int positionMs, {int? index});
  Future<void> playNext(Tracks tracks);
  Future<void> addToQueue(Tracks tracks);
  Future<void> setVolume(double level);
  Future<void> setMute(bool mute);
  void next();
  void previous();
  Future<void> playByIndex(int index);
  Future<void> insertTracksAt({required Tracks tracks, required int index});
  Future<void> setShuffle(ShuffleMode mode);
  Future<void> setRepeat(RepeatMode mode);
  Future<void> moveTrack(int source, int target);
  Future<void> removeTrack(int index);
}
