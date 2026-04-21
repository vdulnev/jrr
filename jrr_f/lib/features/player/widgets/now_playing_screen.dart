import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../../zones/providers/zone_provider.dart';
import '../../queue/providers/queue_provider.dart';
import '../data/models/playback_state.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../../library/data/models/track.dart';
import '../providers/player_provider.dart';
import '../providers/polling_provider.dart';
import 'artwork_widget.dart';

@RoutePage()
class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(pollingProvider);
    ref.watch(zoneListProvider);
    ref.watch(queueProvider);

    final activeZone = ref.watch(activeZoneProvider);
    if (activeZone == null) {
      return const Scaffold(body: LoadingView());
    }

    final playerState = ref.watch(playerProvider);

    return Scaffold(
      body: playerState.when(
        loading: () => const LoadingView(),
        error: (e, _) =>
            ErrorView(error: e, onRetry: () => ref.invalidate(playerProvider)),
        data: (status) {
          final progress = status.durationMs > 0
              ? status.positionMs / status.durationMs
              : 0.0;
          final elapsed = status.positionMs ~/ 1000;
          final remaining = (status.durationMs - status.positionMs) ~/ 1000;

          return SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 88),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'NOW PLAYING',
                                style: AppTextStyles.sectionLabel,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${activeZone.name}'
                                '${_formatQuality(status.trackInfo)}',
                                style: AppTextStyles.itemSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Album art
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 280,
                              maxHeight: 280,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.line2),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0xCC000000),
                                  blurRadius: 60,
                                  offset: Offset(0, 16),
                                ),
                              ],
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ArtworkWidget(
                              imageUrl: status.trackInfo?.imageUrl,
                              size: 280,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Track info + controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // Track info
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                status.trackInfo?.name ?? 'Nothing playing',
                                style: AppTextStyles.nowPlayingTitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (status.trackInfo != null) ...[
                                const SizedBox(height: 3),
                                Text(
                                  [
                                    status.trackInfo?.dateReadable,
                                    status.trackInfo?.album
                                  ]
                                      .where((s) => s != null && s.isNotEmpty)
                                      .join(' · '),
                                  style: AppTextStyles.nowPlayingArtist,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  status.trackInfo?.artist ?? '',
                                  style: AppTextStyles.nowPlayingArtist.copyWith(
                                    color: AppColors.text3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                                ],
                                ),
                                ),

                                // Progress bar
                                const SizedBox(height: 16),
                                AppProgressBar(
                                progress: progress,
                                onChanged: (v) {
                                final ms = (v * status.durationMs).round();
                                ref.read(playerProvider.notifier).seekTo(ms);
                                },
                                ),
                                Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                Text(
                                _fmt(elapsed),
                                style: AppTextStyles.monoLabel,
                                ),
                                Text(
                                '-${_fmt(remaining)}',
                                style: AppTextStyles.monoLabel,
                                ),
                                ],
                                ),
                                ),
                        // Transport controls
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TransportButton(
                              size: 40,
                              color: status.shuffleMode != ShuffleMode.off
                                  ? AppColors.accent
                                  : AppColors.text3,
                              onPressed: () => ref
                                  .read(playerProvider.notifier)
                                  .toggleShuffle(),
                              child: const Icon(Icons.shuffle, size: 18),
                            ),
                            TransportButton(
                              size: 44,
                              onPressed: () =>
                                  ref.read(playerProvider.notifier).previous(),
                              child: const Icon(
                                Icons.skip_previous_rounded,
                                size: 28,
                              ),
                            ),
                            TransportButton(
                              size: 60,
                              accent: true,
                              onPressed: () =>
                                  ref.read(playerProvider.notifier).playPause(),
                              child: Icon(
                                status.state == PlaybackState.playing
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                size: 32,
                              ),
                            ),
                            TransportButton(
                              size: 44,
                              onPressed: () =>
                                  ref.read(playerProvider.notifier).next(),
                              child: const Icon(
                                Icons.skip_next_rounded,
                                size: 28,
                              ),
                            ),
                            TransportButton(
                              size: 40,
                              color: status.repeatMode != RepeatMode.off
                                  ? AppColors.accent
                                  : AppColors.text3,
                              onPressed: () => ref
                                  .read(playerProvider.notifier)
                                  .cycleRepeat(),
                              child: const Icon(Icons.repeat, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        VolumeSlider(
                          value: status.volume,
                          isMuted: status.isMuted,
                          onChanged: (v) =>
                              ref.read(playerProvider.notifier).setVolume(v),
                          onMuteToggle: () =>
                              ref.read(playerProvider.notifier).toggleMute(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmt(int seconds) {
    if (seconds < 0) seconds = 0;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String _formatQuality(Track? trackInfo) {
    if (trackInfo == null) return '';
    if (trackInfo.bitDepth > 0 && trackInfo.sampleRate > 0) {
      final sr = trackInfo.sampleRate >= 1000
          ? '${(trackInfo.sampleRate / 1000).round()}'
          : '${trackInfo.sampleRate}';
      return ' \u00b7 FLAC ${trackInfo.bitDepth}/$sr';
    }
    if (trackInfo.bitrate > 0) return ' \u00b7 ${trackInfo.bitrate} kbps';
    return '';
  }
}
