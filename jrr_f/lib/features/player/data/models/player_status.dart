import 'package:freezed_annotation/freezed_annotation.dart';

import 'playback_state.dart';
import 'repeat_mode.dart';
import 'shuffle_mode.dart';
import '../../../library/data/models/track.dart';

part 'player_status.freezed.dart';

@freezed
abstract class PlayerStatus with _$PlayerStatus {
  const factory PlayerStatus({
    required String zoneId,
    required String zoneName,
    required PlaybackState state,
    Track? trackInfo,
    required int positionMs,
    required int durationMs,
    required String positionDisplay,
    required double volume,
    required String volumeDisplay,
    required bool isMuted,
    @Default(ShuffleMode.off) ShuffleMode shuffleMode,
    @Default(RepeatMode.off) RepeatMode repeatMode,
    required int playingNowPosition,
    required int playingNowTracks,
    required String playingNowPositionDisplay,
    required int playingNowChangeCounter,
  }) = _PlayerStatus;
}
