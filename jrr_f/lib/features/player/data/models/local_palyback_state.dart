import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../library/data/models/track.dart';

part 'local_palyback_state.freezed.dart';

@freezed
abstract class LocalPlaybackState with _$LocalPlaybackState {
  const LocalPlaybackState._();

  const factory LocalPlaybackState({
    SequenceState? sequenceState,
    required ProcessingState processingState,
    required bool playing,
    required Duration position,
    Duration? duration,
    required double volume,
    required bool shuffleModeEnabled,
    required LoopMode loopMode,
  }) = _LocalPlaybackState;

  @override
  String toString() {
    final ss = sequenceState;
    final track = ss?.currentSource?.tag as Track?;
    final trackName = track?.name ?? 'None';

    String fmt(Duration? d) {
      if (d == null) return '00:00:00';
      final h = d.inHours.toString().padLeft(2, '0');
      final m = (d.inMinutes % 60).toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }
    
    return 'LocalPlaybackState(\n'
           '  playing: $playing, state: $processingState\n'
           '  pos: ${fmt(position)} / ${fmt(duration)}\n'
           '  vol: ${(volume * 100).toInt()}%\n'
           '  shuffle: $shuffleModeEnabled, repeat: $loopMode\n'
           '  track: $trackName, FileKey: ${track?.fileKey}\n'
           '  index: ${ss?.currentIndex}, queue: ${ss?.sequence.length}\n'
           '  sequence: ${ss?.sequence.map((e) => (e.tag as Track?)?.fileKey ?? 'None').toList()}\n'
           '  uris: ${ss?.sequence.map((e) => (e as UriAudioSource).uri.toString()).toList()}\n'
           ')';
  }
}
