import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../player/providers/player_provider.dart';
import '../../library/data/models/track.dart';
import '../providers/queue_provider.dart';

class QueueItemTile extends ConsumerWidget {
  final Track item;
  final int index;
  final bool isPlaying;

  const QueueItemTile({
    required this.item,
    required this.index,
    required this.isPlaying,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dismissible(
      key: ValueKey(item.fileKey + index.toString()),
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
      onDismissed: (_) => ref.read(queueProvider.notifier).removeItem(index),
      child: ListTile(
        leading: SizedBox(
          width: 32,
          child: isPlaying
              ? Icon(Icons.volume_up, color: colorScheme.primary, size: 20)
              : Text(
                  '${index + 1}',
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
        onTap: () => ref.read(playerProvider.notifier).playByIndex(index),
      ),
    );
  }
}
