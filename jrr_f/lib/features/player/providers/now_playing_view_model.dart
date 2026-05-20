import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../library/providers/library_providers.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/playback_state.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import 'now_playing_view_state.dart';
import 'player_polling_provider.dart';
import 'player_provider.dart';

part 'now_playing_view_model.g.dart';

@riverpod
class NowPlayingViewModel extends _$NowPlayingViewModel {
  @override
  NowPlayingViewState build() {
    // Keep the player poller running while the screen is mounted.
    ref.watch(playerPollingProvider);

    final activeZone = ref.watch(activeZoneProvider);
    final status = ref.watch(playerProvider).value;
    final fileKey = status?.fileKey ?? -1;
    final track = fileKey >= 0
        ? ref.watch(searchByFileKeyProvider(fileKey)).asData?.value
        : null;

    return NowPlayingViewState(
      activeZone: activeZone,
      fileKey: fileKey,
      track: track,
      name: status?.name ?? '',
      artist: status?.artist ?? '',
      album: status?.album ?? '',
      positionMs: status?.positionMs ?? 0,
      durationMs: status?.durationMs ?? 0,
      volume: status?.volume ?? 0.0,
      isMuted: status?.isMuted ?? false,
      isPlaying: status?.state == PlaybackState.playing,
      repeatMode: status?.repeatMode ?? RepeatMode.off,
      shuffleMode: status?.shuffleMode ?? ShuffleMode.off,
      playingNowPosition: status?.playingNowPosition ?? 0,
      playingNowTracks: status?.playingNowTracks ?? 0,
      fileType: track?.fileType ?? '',
      bitDepth: track?.bitDepth ?? 0,
      sampleRate: track?.sampleRate ?? 0,
    );
  }

  void playPause() => ref.read(playerProvider.notifier).playPause();
  void next() => ref.read(playerProvider.notifier).next();
  void previous() => ref.read(playerProvider.notifier).previous();
  void seekTo(int positionMs) =>
      ref.read(playerProvider.notifier).seekTo(positionMs);
  void setVolume(double level) =>
      ref.read(playerProvider.notifier).setVolume(level);
  void toggleMute() => ref.read(playerProvider.notifier).toggleMute();
  void cycleRepeat() => ref.read(playerProvider.notifier).cycleRepeat();
  void toggleShuffle() => ref.read(playerProvider.notifier).toggleShuffle();
}
