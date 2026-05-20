import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/playback_state.dart';
import 'mini_player_view_state.dart';
import 'player_provider.dart';

part 'mini_player_view_model.g.dart';

@riverpod
class MiniPlayerViewModel extends _$MiniPlayerViewModel {
  @override
  MiniPlayerViewState build() {
    final status = ref.watch(playerProvider).value;
    final durationMs = status?.durationMs ?? 0;
    final positionMs = status?.positionMs ?? 0;
    final progress = durationMs > 0
        ? (positionMs / durationMs).clamp(0.0, 1.0)
        : 0.0;

    final rawName = status?.name ?? '';
    final rawArtist = status?.artist ?? '';

    return MiniPlayerViewState(
      fileKey: status?.fileKey,
      name: rawName.isNotEmpty ? rawName : 'Unknown Track',
      artist: rawArtist.isNotEmpty ? rawArtist : 'Unknown Artist',
      volume: status?.volume ?? 1.0,
      isMuted: status?.isMuted ?? false,
      isPlaying: status?.state == PlaybackState.playing,
      progress: progress,
      hasTracks: (status?.playingNowTracks ?? 0) > 0,
    );
  }

  void playPause() => ref.read(playerProvider.notifier).playPause();
  void next() => ref.read(playerProvider.notifier).next();
  void previous() => ref.read(playerProvider.notifier).previous();
  void setVolume(double level) =>
      ref.read(playerProvider.notifier).setVolume(level);
  void toggleMute() => ref.read(playerProvider.notifier).toggleMute();
}
