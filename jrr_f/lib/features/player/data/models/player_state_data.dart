import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'player_state_data.freezed.dart';

@freezed
abstract class PlayerStateData with _$PlayerStateData {
  const PlayerStateData._();

  const factory PlayerStateData({
    required bool playing,
    required ProcessingState processingState,
  }) = _PlayerStateData;
}
