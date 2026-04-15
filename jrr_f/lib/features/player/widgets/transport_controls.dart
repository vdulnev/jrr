import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/playback_state.dart';
import '../data/models/player_status.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../providers/player_provider.dart';

class TransportControls extends ConsumerWidget {
  final PlayerStatus status;

  const TransportControls({super.key, required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playerProvider.notifier);
    final isPlaying = status.state == PlaybackState.playing;
    final colorScheme = Theme.of(context).colorScheme;

    final shuffleColor = status.shuffleMode != ShuffleMode.off
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final repeatColor = status.repeatMode != RepeatMode.off
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    final repeatIcon = status.repeatMode == RepeatMode.track
        ? Icons.repeat_one
        : Icons.repeat;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle, color: shuffleColor),
          tooltip: 'Shuffle',
          onPressed: notifier.toggleShuffle,
        ),
        IconButton(
          icon: const Icon(Icons.skip_previous),
          iconSize: 36,
          onPressed: notifier.previous,
        ),
        FilledButton(
          onPressed: notifier.playPause,
          style: FilledButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 32),
        ),
        IconButton(
          icon: const Icon(Icons.skip_next),
          iconSize: 36,
          onPressed: notifier.next,
        ),
        IconButton(
          icon: Icon(repeatIcon, color: repeatColor),
          tooltip: 'Repeat',
          onPressed: notifier.cycleRepeat,
        ),
      ],
    );
  }
}
