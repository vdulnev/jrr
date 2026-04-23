import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/browse_item.dart';
import '../providers/library_providers.dart';
import 'browse_content.dart';

/// Embedded browse tree (used inside the Library tab).
class BrowseTreeView extends ConsumerWidget {
  const BrowseTreeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stackProvider = browseNavigationStackProvider(BrowseScope.browse);

    final stack = ref.watch(stackProvider);

    void push(BrowseItem item) {
      ref
          .read(stackProvider.notifier)
          .push(BrowseItem(id: item.id, name: item.name));
    }

    return BrowseContent(
      stack: stack,
      onPush: push,
      onTapBreadcrumb: (i) =>
          ref.read(stackProvider.notifier).navigateToBreadcrumb(i),
    );
  }
}
