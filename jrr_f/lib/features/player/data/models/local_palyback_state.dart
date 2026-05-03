import 'package:freezed_annotation/freezed_annotation.dart';
import 'player_state_data.dart';
import 'sequence_state_data.dart';

part 'local_palyback_state.freezed.dart';

@freezed
abstract class LocalPlaybackState with _$LocalPlaybackState {
  const LocalPlaybackState._();

  const factory LocalPlaybackState({
    SequenceStateData? sequenceState,
    required PlayerStateData playerState,
    required Duration position,
    Duration? duration,
    required double volume,
  }) = _LocalPlaybackState;

  @override
  String toString() {
    final ss = sequenceState;
    final track = ss?.currentTrack;
    final trackName = track?.name ?? 'None';

    String fmt(Duration? d) {
      if (d == null) return '00:00:00';
      final h = d.inHours.toString().padLeft(2, '0');
      final m = (d.inMinutes % 60).toString().padLeft(2, '0');
      final s = (d.inSeconds % 60).toString().padLeft(2, '0');
      return '$h:$m:$s';
    }

    return 'LocalPlaybackState(\n'
        '  playing: ${playerState.playing}, state: ${playerState.processingState}\n'
        '  pos: ${fmt(position)} / ${fmt(duration)}\n'
        '  vol: ${(volume * 100).toInt()}%\n'
        '  shuffle: ${ss?.shuffleModeEnabled}, repeat: ${ss?.loopMode}\n'
        '  track: $trackName, FileKey: ${track?.fileKey}\n'
        '  index: ${ss?.currentIndex}, queue: ${ss?.sequence.length}\n'
        ')';
  }
}
