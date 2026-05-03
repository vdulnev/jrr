import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';
import '../../../library/data/models/track.dart';
import '../../../library/data/models/tracks.dart';

part 'sequence_state_data.freezed.dart';

@freezed
abstract class SequenceStateData with _$SequenceStateData {
  const SequenceStateData._();

  const factory SequenceStateData({
    required Tracks sequence,
    required int currentIndex,
    required List<int> shuffleIndices,
    required bool shuffleModeEnabled,
    required LoopMode loopMode,
  }) = _SequenceStateData;

  Track? get currentTrack {
    if (currentIndex >= 0 && currentIndex < sequence.length) {
      return sequence[currentIndex];
    }
    return null;
  }
}
