import 'package:freezed_annotation/freezed_annotation.dart';

import 'playback_state.dart';
import 'repeat_mode.dart';
import 'shuffle_mode.dart';

part 'player_status.freezed.dart';

@freezed
abstract class PlayerStatus with _$PlayerStatus {
  const factory PlayerStatus({
    required String zoneId,
    required String zoneName,
    required PlaybackState state,
    @Default(-1) int fileKey,
    @Default(-1) int nextFileKey,
    required int positionMs,
    required int durationMs,
    @Default('') String elapsedTimeDisplay,
    @Default('') String remainingTimeDisplay,
    @Default('') String totalTimeDisplay,
    required String positionDisplay,
    required int playingNowPosition,
    required int playingNowTracks,
    required String playingNowPositionDisplay,
    required int playingNowChangeCounter,
    @Default(0) int bitrate,
    @Default(0) int bitDepth,
    @Default(0) int sampleRate,
    @Default(0) int channels,
    @Default(0) int chapter,
    String? chapterList,
    required double volume,
    required String volumeDisplay,
    @Default('') String imageUrl,
    @Default('') String artist,
    @Default('') String album,
    @Default('') String name,
    @Default(0) int rating,
    @Default('') String status,
    String? linkedZones,

    // Internal fields not in the requested list but useful for current UI
    @Default(false) bool isMuted,
    @Default(ShuffleMode.off) ShuffleMode shuffleMode,
    @Default(RepeatMode.off) RepeatMode repeatMode,
  }) = _PlayerStatus;
}
