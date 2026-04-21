import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/transport_button.dart';
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
        final track = status.trackInfo;
        if (track == null) return const SizedBox.shrink();
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ArtworkWidget(
                          imageUrl: track.imageUrl,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.name,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              track.artist,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.text3,
                              ),
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
                            onPressed: () =>
                                ref.read(playerProvider.notifier).previous(),
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 20,
                            ),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: () =>
                                ref.read(playerProvider.notifier).playPause(),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 20,
                            ),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: () =>
                                ref.read(playerProvider.notifier).next(),
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 20,
                            ),
                          ),
                        ],
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
