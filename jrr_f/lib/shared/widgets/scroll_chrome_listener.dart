import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/library/providers/library_providers.dart';

/// Listens to scroll on its child and toggles
/// [libraryChromeVisibleProvider] to hide chrome (parent header + mini
/// player) on scroll-down and show it on scroll-up.
///
/// Resets chrome to visible when removed from the tree so screens that are
/// torn down don't leave chrome hidden for the next screen.
class ScrollChromeListener extends ConsumerStatefulWidget {
  final Widget child;

  const ScrollChromeListener({required this.child, super.key});

  @override
  ConsumerState<ScrollChromeListener> createState() =>
      _ScrollChromeListenerState();
}

class _ScrollChromeListenerState extends ConsumerState<ScrollChromeListener> {
  late final LibraryChromeVisibleNotifier _chromeNotifier;

  @override
  void initState() {
    super.initState();
    _chromeNotifier = ref.read(libraryChromeVisibleProvider.notifier);
  }

  @override
  void dispose() {
    _chromeNotifier.set(true);
    super.dispose();
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is! UserScrollNotification) return false;

    switch (notification.direction) {
      case ScrollDirection.reverse:
        ref.read(libraryChromeVisibleProvider.notifier).set(false);
      case ScrollDirection.forward:
        ref.read(libraryChromeVisibleProvider.notifier).set(true);
      case ScrollDirection.idle:
        // When the gesture ends at (or above) the top, ensure chrome is
        // visible. Otherwise leave state as-is so a hidden header stays
        // hidden after a fling settles partway down.
        if (notification.metrics.pixels <= 0) {
          ref.read(libraryChromeVisibleProvider.notifier).set(true);
        }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: widget.child,
    );
  }
}
