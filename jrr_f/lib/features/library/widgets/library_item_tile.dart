import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/track.dart';
import 'library_action_sheet.dart';

class LibraryItemTile extends ConsumerWidget {
  final Track item;
  final int? trackNumber;

  const LibraryItemTile({required this.item, this.trackNumber, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayTrackNumber = trackNumber ?? (item.trackNumber > 0 ? item.trackNumber : null);
    return ListTile(
      leading: displayTrackNumber != null
          ? SizedBox(
              width: 32,
              child: Text(
                '$displayTrackNumber',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : null,
      title: Text(
        item.name.isNotEmpty ? item.name : 'Unknown',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        [item.artist, item.album].where((s) => s.isNotEmpty).join(' · '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert),
        onPressed: () => showLibraryActionSheet(
          context,
          ref,
          items: [item],
          title: item.name,
        ),
      ),
      onTap: () =>
          showLibraryActionSheet(context, ref, items: [item], title: item.name),
    );
  }
}
