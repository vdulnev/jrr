import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/injection.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/track.dart';
import '../data/repositories/library_repository.dart';
import 'library_action_sheet.dart';

class LibraryItemTile extends ConsumerStatefulWidget {
  final Track item;
  final int? trackNumber;
  final bool collapsedByDefault;

  const LibraryItemTile({
    required this.item,
    this.trackNumber,
    this.collapsedByDefault = false,
    super.key,
  });

  @override
  ConsumerState<LibraryItemTile> createState() => _LibraryItemTileState();
}

class _LibraryItemTileState extends ConsumerState<LibraryItemTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final displayTrackNumber =
        widget.trackNumber ?? (item.trackNumber > 0 ? item.trackNumber : null);
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
      subtitle: _expanded || !widget.collapsedByDefault
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  [
                    item.artist,
                    item.album,
                    item.dateReadable,
                  ].where((s) => s.isNotEmpty).join(' \u00b7 '),
                ),
                if (_expanded && item.filePath.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      item.filePath,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            )
          : null,
      onTap: () => setState(() => _expanded = !_expanded),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow_outlined),
            tooltip: 'Play',
            onPressed: () async {
              final zone = ref.read(activeZoneProvider);
              if (zone == null) return;
              getIt<LibraryRepository>().playNow(zone.id, [item.fileKey]);
              ref.read(playerProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.queue_play_next),
            tooltip: 'Play next',
            onPressed: () async {
              final zone = ref.read(activeZoneProvider);
              if (zone == null) return;
              getIt<LibraryRepository>().playNext(zone.id, [item.fileKey]);
              ref.read(playerProvider.notifier).refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add to playing now',
            onPressed: () async {
              final zone = ref.read(activeZoneProvider);
              if (zone == null) return;
              getIt<LibraryRepository>().addToQueue(zone.id, [item.fileKey]);
              ref.read(playerProvider.notifier).refresh();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to playing now'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        ],
      ),
      onLongPress: () =>
          showLibraryActionSheet(context, ref, items: [item], title: item.name),
    );
  }
}
