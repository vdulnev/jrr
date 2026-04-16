import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../zones/providers/active_zone_provider.dart';
import '../data/models/library_item.dart';
import '../data/repositories/library_repository.dart';
import '../../../core/di/injection.dart';
import '../../player/providers/player_provider.dart';

Future<void> showLibraryActionSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<LibraryItem> items,
  String? title,
}) async {
  final zone = ref.read(activeZoneProvider);
  if (zone == null) return;
  final keys = items.map((i) => i.fileKey).toList();

  await showModalBottomSheet<void>(
    context: context,
    builder: (_) =>
        _LibraryActionSheet(title: title, zoneId: zone.id, fileKeys: keys),
  );

  // Refresh player state after any queue action.
  if (context.mounted) {
    ref.read(playerProvider.notifier).refresh();
  }
}

class _LibraryActionSheet extends StatelessWidget {
  final String? title;
  final String zoneId;
  final List<String> fileKeys;

  const _LibraryActionSheet({
    this.title,
    required this.zoneId,
    required this.fileKeys,
  });

  @override
  Widget build(BuildContext context) {
    final repo = getIt<LibraryRepository>();

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                title!,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Divider(height: 1),
          ],
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Play now'),
            onTap: () {
              repo.playNow(zoneId, fileKeys);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_play_next),
            title: const Text('Play next'),
            onTap: () {
              repo.playNext(zoneId, fileKeys);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_to_queue),
            title: const Text('Add to queue'),
            onTap: () {
              repo.addToQueue(zoneId, fileKeys);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
