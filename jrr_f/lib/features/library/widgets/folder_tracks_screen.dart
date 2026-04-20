import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/library_providers.dart';
import 'track_list_scaffold.dart';

@RoutePage()
class FolderTracksScreen extends ConsumerWidget {
  final String folderPath;

  const FolderTracksScreen({required this.folderPath, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TrackListScaffold(
      title: Text(folderPath, style: Theme.of(context).textTheme.bodySmall),
      tracksState: ref.watch(folderTracksProvider(folderPath)),
      onRetry: () => ref.invalidate(folderTracksProvider(folderPath)),
      actionSheetTitle: folderPath,
      addedSnackbarLabel: folderPath,
    );
  }
}
