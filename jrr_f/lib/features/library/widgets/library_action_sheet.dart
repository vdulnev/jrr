import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/track.dart';
import '../../player/providers/player_provider.dart';

Future<void> showLibraryActionSheet(
  BuildContext context,
  WidgetRef ref, {
  required List<Track> tracks,
  String? title,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (_) => _LibraryActionSheet(title: title, tracks: tracks, ref: ref),
  );

  // Refresh player state after any queue action.
  if (context.mounted) {
    ref.read(playerProvider.notifier).refresh();
  }
}

class _LibraryActionSheet extends StatelessWidget {
  final WidgetRef ref;
  final String? title;
  final List<Track> tracks;

  const _LibraryActionSheet({
    required this.ref,
    this.title,
    required this.tracks,
  });

  @override
  Widget build(BuildContext context) {
    final currentTitle = title;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (currentTitle != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                currentTitle,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text('Play now'),
            onTap: () {
              ref.read(playerProvider.notifier).playNow(tracks);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.queue_play_next),
            title: const Text('Play next'),
            onTap: () {
              ref.read(playerProvider.notifier).playNext(tracks);
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_to_queue),
            title: const Text('Add to queue'),
            onTap: () {
              ref.read(playerProvider.notifier).addToQueue(tracks);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
