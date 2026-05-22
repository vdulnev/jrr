import 'package:freezed_annotation/freezed_annotation.dart';

part 'mini_player_view_state.freezed.dart';

/// View model state for [MiniPlayerPanel]. Bundles every slice the panel
/// renders so the widget watches a single provider instead of multiple
/// `playerProvider.select(...)` calls.
@freezed
abstract class MiniPlayerViewState with _$MiniPlayerViewState {
  const factory MiniPlayerViewState({
    required int? fileKey,
    required String name,
    required String artist,
    required double volume,
    required bool isMuted,
    required bool isPlaying,
    required double progress,
    required bool hasTracks,
  }) = _MiniPlayerViewState;

  const MiniPlayerViewState._();

  /// MCWS reports `Volume = -1` for streams where the server can't apply
  /// software volume (e.g. DSD bit-stream playback). Hide the slider in
  /// that case rather than render a slider whose value is meaningless.
  bool get hasVolumeControl => volume >= 0;
}
