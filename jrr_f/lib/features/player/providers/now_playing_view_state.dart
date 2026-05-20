import 'package:freezed_annotation/freezed_annotation.dart';

import '../../library/data/models/track.dart';
import '../../zones/data/models/zone.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';

part 'now_playing_view_state.freezed.dart';

/// View model state for [NowPlayingScreen]. Bundles every slice the screen
/// and its children render today so the widget tree watches a single
/// provider instead of N selectors against the underlying providers.
@freezed
abstract class NowPlayingViewState with _$NowPlayingViewState {
  const factory NowPlayingViewState({
    required Zone? activeZone,
    required int fileKey,
    required Track? track,
    required String name,
    required String artist,
    required String album,
    required int positionMs,
    required int durationMs,
    required double volume,
    required bool isMuted,
    required bool isPlaying,
    required RepeatMode repeatMode,
    required ShuffleMode shuffleMode,
    required int playingNowPosition,
    required int playingNowTracks,
    required String fileType,
    required int bitDepth,
    required int sampleRate,
  }) = _NowPlayingViewState;

  const NowPlayingViewState._();

  /// True when there is an active zone and a real track is loaded.
  bool get hasTrack => activeZone != null && fileKey >= 0;
}
