import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/core/di/injection.dart';
import 'package:talker/talker.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../data/models/playback_state.dart';
import '../providers/player_provider.dart';
import '../../../shared/widgets/artwork_widget.dart';

class MiniPlayerPanel extends ConsumerWidget {
  final VoidCallback? onItemTap;

  const MiniPlayerPanel({this.onItemTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Data(
      onItemTap: onItemTap,
      onPreviousTap: () => ref.read(playerProvider.notifier).previous(),
      onPlayPauseTap: () => ref.read(playerProvider.notifier).playPause(),
      onNextTap: () => ref.read(playerProvider.notifier).next(),
      onSetVolumeTap: (v) => ref.read(playerProvider.notifier).setVolume(v),
      onMuteToggleTap: () => ref.read(playerProvider.notifier).toggleMute(),
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.onItemTap,
    required this.onPreviousTap,
    required this.onPlayPauseTap,
    required this.onNextTap,
    required this.onSetVolumeTap,
    required this.onMuteToggleTap,
  });

  final VoidCallback? onItemTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onNextTap;
  final ValueChanged<double> onSetVolumeTap;
  final VoidCallback onMuteToggleTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            SizedBox(
              height: 2,
              child: Stack(
                children: [
                  Container(color: AppColors.bg4),
                  const _ProgressBar(),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: const _Cover(),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [_Name(), SizedBox(height: 1), _Artist()],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransportButton(
                            size: 36,
                            onPressed: onPreviousTap,
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 20,
                            ),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: onPlayPauseTap,
                            child: const _PlayIcon(),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: onNextTap,
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  _Volume(
                    onSetVolumeTap: onSetVolumeTap,
                    onMuteToggleTap: onMuteToggleTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Volume extends ConsumerWidget {
  const _Volume({required this.onSetVolumeTap, required this.onMuteToggleTap});

  final ValueChanged<double> onSetVolumeTap;
  final VoidCallback onMuteToggleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();
    final volume = ref.watch(
      playerProvider.select((status) => status.value?.volume ?? 1.0),
    );
    final isMuted = ref.watch(
      playerProvider.select((status) => status.value?.isMuted ?? false),
    );
    talker.debug('[MiniPlayerPanel] Volume: $volume, isMuted: $isMuted');
    return VolumeSlider(
      value: volume,
      isMuted: isMuted,
      onChanged: onSetVolumeTap,
      onMuteToggle: onMuteToggleTap,
    );
  }
}

class _PlayIcon extends ConsumerWidget {
  const _PlayIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(
      playerProvider.select(
        (status) => status.value?.state == PlaybackState.playing,
      ),
    );
    return Icon(
      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      size: 20,
    );
  }
}

class _Artist extends ConsumerWidget {
  const _Artist();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artist = ref.watch(
      playerProvider.select(
        (status) => status.value?.artist ?? 'Unknown Artist',
      ),
    );
    return Text(
      artist,
      style: AppTextStyles.itemSubtitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Name extends ConsumerWidget {
  const _Name();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(
      playerProvider.select((status) => status.value?.name ?? 'Unknown Track'),
    );
    return Text(
      name,
      style: AppTextStyles.labelLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Cover extends ConsumerWidget {
  const _Cover();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();
    final imageUrl = ref.watch(
      playerProvider.select((status) => status.value?.imageUrl),
    );
    talker.debug('[MiniPlayerPanel] Final imageUrl: $imageUrl');
    return ArtworkWidget(imageUrl: imageUrl, size: 40);
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();
    final progress = ref.watch(
      playerProvider.select((status) {
        final double progress;
        if (status.hasValue) {
          final durationMs = status.value?.durationMs ?? 0;
          final positionMs = status.value?.positionMs ?? 0;
          progress = (durationMs) > 0
              ? (positionMs / durationMs).clamp(0.0, 1.0)
              : 0.0;
          talker.debug(
            '[MiniPlayerPanel] Calculated progress: $progress (position: $positionMs ms, duration: $durationMs ms)',
          );
        } else {
          progress = 0.0;
          talker.debug(
            '[MiniPlayerPanel] Player status has no value, setting progress to 0',
          );
        }
        return progress;
      }),
    );
    return FractionallySizedBox(
      widthFactor: progress,
      child: Container(color: AppColors.accent),
    );
  }
}
