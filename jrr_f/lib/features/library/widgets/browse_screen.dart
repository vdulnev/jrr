import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/sub_screen_header.dart';
import '../data/models/browse_item.dart';
import '../providers/library_providers.dart';
import 'browse_files_screen.dart';

/// Full-screen browse with its own back button (used as a pushed route).
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SubScreenHeader(
              title: _current.name,
              subtitle: 'Browse Tree',
              onBack: _pop,
            ),
            // Breadcrumb
            if (_stack.length > 1)
              _Breadcrumb(
                stack: _stack,
                onTap: (i) =>
                    setState(() => _stack.removeRange(i + 1, _stack.length)),
              ),
            Expanded(
              child: childrenState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () =>
                      ref.invalidate(browseChildrenProvider(_current.id)),
                ),
                data: (children) {
                  if (children.isEmpty) {
                    return BrowseFilesView(
                      id: _current.id,
                      title: _current.name,
                    );
                  }
                  return _BrowseNodeList(children: children, onTap: _push);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Embedded browse tree (used inside the Library tab).
class BrowseTreeView extends ConsumerStatefulWidget {
  const BrowseTreeView({super.key});

  @override
  ConsumerState<BrowseTreeView> createState() => _BrowseTreeViewState();
}

class _BrowseTreeViewState extends ConsumerState<BrowseTreeView> {
  final List<_BrowseLevel> _stack = [
    const _BrowseLevel(id: '-1', name: 'Browse'),
  ];

  _BrowseLevel get _current => _stack.last;

  void _push(BrowseItem item) {
    setState(() {
      _stack.add(_BrowseLevel(id: item.id, name: item.name));
    });
  }

  @override
  Widget build(BuildContext context) {
    final childrenState = ref.watch(browseChildrenProvider(_current.id));

    return Column(
      children: [
        // Breadcrumb
        if (_stack.length > 1)
          _Breadcrumb(
            stack: _stack,
            onTap: (i) =>
                setState(() => _stack.removeRange(i + 1, _stack.length)),
          ),
        Expanded(
          child: childrenState.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorView(
              error: e,
              onRetry: () =>
                  ref.invalidate(browseChildrenProvider(_current.id)),
            ),
            data: (children) {
              if (children.isEmpty) {
                return BrowseFilesView(id: _current.id, title: _current.name);
              }
              return _BrowseNodeList(children: children, onTap: _push);
            },
          ),
        ),
      ],
    );
  }
}

class _Breadcrumb extends StatelessWidget {
  final List<_BrowseLevel> stack;
  final ValueChanged<int> onTap;

  const _Breadcrumb({required this.stack, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          for (var i = 0; i < stack.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: AppColors.text3,
                ),
              ),
            GestureDetector(
              onTap: i < stack.length - 1 ? () => onTap(i) : null,
              child: Text(
                stack[i].name,
                style: TextStyle(
                  fontFamily: AppFonts.mono,
                  fontSize: 10,
                  color: i < stack.length - 1
                      ? AppColors.text3
                      : AppColors.accent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrowseNodeList extends StatelessWidget {
  final List<BrowseItem> children;
  final ValueChanged<BrowseItem> onTap;

  const _BrowseNodeList({required this.children, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 148),
      itemCount: children.length,
      itemBuilder: (_, i) {
        final item = children[i];
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTap(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.bg3,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.folder_outlined,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppColors.text3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrowseLevel {
  final String id;
  final String name;

  const _BrowseLevel({required this.id, required this.name});
}
