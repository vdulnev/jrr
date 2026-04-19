import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../data/models/playback_state.dart';
import '../providers/player_provider.dart';
import 'artwork_widget.dart';

class MiniPlayerPanel extends ConsumerWidget {
  const MiniPlayerPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    return playerState.maybeWhen(
      data: (status) {
        final track = status.trackInfo;
        if (track == null) return const SizedBox.shrink();
        final isPlaying = status.state == PlaybackState.playing;
        return GestureDetector(
          onTap: () => ref.read(navigationProvider.notifier).clear(),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(
                    value: status.durationMs > 0
                        ? (status.positionMs / status.durationMs).clamp(
                            0.0,
                            1.0,
                          )
                        : 0.0,
                    minHeight: 2,
                    backgroundColor: Colors.transparent,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        ArtworkWidget(imageUrl: track.imageUrl, size: 48),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                track.name,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                track.artist,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous),
                          onPressed: () =>
                              ref.read(playerProvider.notifier).previous(),
                        ),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () =>
                              ref.read(playerProvider.notifier).playPause(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next),
                          onPressed: () =>
                              ref.read(playerProvider.notifier).next(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
