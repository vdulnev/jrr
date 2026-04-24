import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/browse_item.dart';
import '../providers/library_providers.dart';
import 'browse_breadcrumb.dart';
import 'browse_files_screen.dart';
import 'browse_item_list.dart';

/// Reusable browse content UI with breadcrumbs, folder list, and files view.
/// Used by BrowseScreen, BrowseTreeView, and FavoritesScreen.
class BrowseContent extends ConsumerWidget {
  /// Current navigation stack for breadcrumbs
  final List<BrowseItem> stack;

  /// Callback to navigate into a folder
  final ValueChanged<BrowseItem> onPush;

  /// Callback to navigate back through the stack
  final ValueChanged<int> onTapBreadcrumb;

  /// Optional header title shown above breadcrumbs
  final String? headerTitle;

  /// Optional breadcrumb prefix (e.g., "Favorites" for favorites navigation)
  final String? breadcrumbPrefix;

  const BrowseContent({
    super.key,
    required this.stack,
    required this.onPush,
    required this.onTapBreadcrumb,
    this.headerTitle,
    this.breadcrumbPrefix,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (stack.isEmpty) {
      return const SizedBox.shrink();
    }

    final current = stack.last;
    final childrenState = ref.watch(browseChildrenProvider(current.id));

    return Column(
      children: [
        if (headerTitle != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(headerTitle!, style: AppTextStyles.screenTitle),
          ),
        BrowseBreadcrumb(
          stack: stack,
          onTap: onTapBreadcrumb,
          prefix: breadcrumbPrefix,
        ),
        Expanded(
          child: childrenState.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () => ref.invalidate(browseChildrenProvider(current.id)),
            ),
            data: (children) {
              if (children.isEmpty) {
                return BrowseFilesView(id: current.id, title: current.name);
              }
              return BrowseItemList(items: children, onTap: onPush);
            },
          ),
        ),
      ],
    );
  }
}
