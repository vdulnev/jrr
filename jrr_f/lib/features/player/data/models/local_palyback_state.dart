import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'local_palyback_state.freezed.dart';

@freezed
abstract class LocalPlaybackState with _$LocalPlaybackState {
  const factory LocalPlaybackState({
    required SequenceState sequenceState,
    required ProcessingState processingState,
    required bool playing,
    required Duration position,
    Duration? duration,
    required double volume,
    required bool shuffleModeEnabled,
    required LoopMode loopMode,
  }) = _LocalPlaybackState;
}
