import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/browse_item.dart';
import '../providers/library_providers.dart';
import 'browse_files_screen.dart';

@RoutePage()
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final List<_BrowseLevel> _stack = [
    const _BrowseLevel(id: '-1', name: 'Browse'),
  ];

  _BrowseLevel get _current => _stack.last;

  void _push(BrowseItem item) {
    setState(() {
      _stack.add(_BrowseLevel(id: item.id, name: item.name));
    });
  }

  void _pop() {
    if (_stack.length > 1) {
      setState(() => _stack.removeLast());
    } else {
      ref.read(navigationProvider.notifier).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final childrenState = ref.watch(browseChildrenProvider(_current.id));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _pop,
        ),
        title: Text(_current.name),
      ),
      body: childrenState.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(browseChildrenProvider(_current.id)),
        ),
        data: (children) {
          if (children.isEmpty) {
            // Leaf node — show files
            return BrowseFilesView(id: _current.id, title: _current.name);
          }
          return ListView.builder(
            itemCount: children.length,
            itemBuilder: (_, i) {
              final item = children[i];
              return ListTile(
                leading: const Icon(Icons.folder_outlined),
                title: Text(item.name),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _push(item),
              );
            },
          );
        },
      ),
    );
  }
}

class _BrowseLevel {
  final String id;
  final String name;

  const _BrowseLevel({required this.id, required this.name});
}
