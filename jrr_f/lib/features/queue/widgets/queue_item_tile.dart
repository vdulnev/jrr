import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../player/providers/player_provider.dart';
import '../data/models/playing_now_item.dart';
import '../providers/queue_provider.dart';

class QueueItemTile extends ConsumerWidget {
  final PlayingNowItem item;
  final int currentIndex;

  const QueueItemTile({
    required this.item,
    required this.currentIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = item.index == currentIndex;
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(item.fileKey + item.index.toString()),
      direction: DismissDirection.endToStart,
      background: ColoredBox(
        color: colorScheme.errorContainer,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.delete_outline,
              color: colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
      onDismissed: (_) =>
          ref.read(queueProvider.notifier).removeItem(item.index),
      child: ListTile(
        leading: SizedBox(
          width: 32,
          child: isPlaying
              ? Icon(Icons.volume_up, color: colorScheme.primary, size: 20)
              : Text(
                  '${item.index + 1}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
        ),
        title: Text(
          item.name.isNotEmpty ? item.name : 'Unknown',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isPlaying
              ? TextStyle(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                )
              : null,
        ),
        subtitle: Text(
          [item.artist, item.album].where((s) => s.isNotEmpty).join(' · '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () => ref.read(playerProvider.notifier).playByIndex(item.index),
      ),
    );
  }
}
