import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../data/models/track.dart';
import '../providers/library_providers.dart';
import 'track_list_scaffold.dart';

@RoutePage()
class FolderTracksScreen extends ConsumerStatefulWidget {
  final String folderPath;

  const FolderTracksScreen({required this.folderPath, super.key});

  @override
  ConsumerState<FolderTracksScreen> createState() => _FolderTracksScreenState();
}

class _FolderTracksScreenState extends ConsumerState<FolderTracksScreen> {
  late String _currentPath;
  final List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _currentPath = widget.folderPath;
  }

  bool get _canGoUp {
    final parent = Track.parentPath(_currentPath);
    return parent.isNotEmpty && parent != _currentPath;
  }

  bool get _canGoBack => _history.isNotEmpty;

  void _goUp() {
    final parent = Track.parentPath(_currentPath);
    if (parent.isNotEmpty && parent != _currentPath) {
      setState(() {
        _history.add(_currentPath);
        _currentPath = parent;
      });
    }
  }

  void _goBack() {
    if (_history.isNotEmpty) {
      setState(() {
        _currentPath = _history.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tracksState = ref.watch(folderTracksProvider(_currentPath));

    return TrackListScaffold(
      subtitle: 'Folder',
      title: Text(_currentPath, style: AppTextStyles.subScreenTitle),
      headerContent: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_downward, size: 20),
            tooltip: 'Back to child folder',
            visualDensity: VisualDensity.compact,
            onPressed: _canGoBack ? _goBack : null,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_upward, size: 20),
            tooltip: 'Go to parent folder',
            visualDensity: VisualDensity.compact,
            onPressed: _canGoUp ? _goUp : null,
          ),
        ],
      ),
      tracksState: tracksState,
      onRetry: () => ref.invalidate(folderTracksProvider(_currentPath)),
      actionSheetTitle: _currentPath,
      addedSnackbarLabel: _currentPath,
    );
  }
}
