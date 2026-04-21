import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../data/models/playback_state.dart';
import '../providers/player_provider.dart';
import 'artwork_widget.dart';

class MiniPlayerPanel extends ConsumerWidget {
  final VoidCallback? onTap;

  const MiniPlayerPanel({this.onTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    return playerState.maybeWhen(
      data: (status) {
        if (status.fileKey < 0) return const SizedBox.shrink();
        final isPlaying = status.state == PlaybackState.playing;
        final progress = status.durationMs > 0
            ? (status.positionMs / status.durationMs).clamp(0.0, 1.0)
            : 0.0;
        return GestureDetector(
          onTap: onTap,
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
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(color: AppColors.accent),
                      ),
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
                            child: ArtworkWidget(
                              imageUrl: status.imageUrl,
                              size: 40,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  status.name,
                                  style: AppTextStyles.labelLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  status.artist,
                                  style: AppTextStyles.itemSubtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TransportButton(
                                size: 36,
                                onPressed: () => ref
                                    .read(playerProvider.notifier)
                                    .previous(),
                                child: const Icon(
                                  Icons.skip_previous_rounded,
                                  size: 20,
                                ),
                              ),
                              TransportButton(
                                size: 36,
                                onPressed: () => ref
                                    .read(playerProvider.notifier)
                                    .playPause(),
                                child: Icon(
                                  isPlaying
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                  size: 20,
                                ),
                              ),
                              TransportButton(
                                size: 36,
                                onPressed: () => ref
                                    .read(playerProvider.notifier)
                                    .next(),
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
                      VolumeSlider(
                        value: status.volume,
                        isMuted: status.isMuted,
                        onChanged: (v) =>
                            ref.read(playerProvider.notifier).setVolume(v),
                        onMuteToggle: () =>
                            ref.read(playerProvider.notifier).toggleMute(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
