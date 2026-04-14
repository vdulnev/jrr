import 'package:auto_route/auto_route.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_notifier.g.dart';

@riverpod
class NavigationNotifier extends _$NavigationNotifier {
  @override
  List<PageRouteInfo> build() => [];

  void push(PageRouteInfo route) {
    state = [...state, route];
  }

  void pop() {
    if (state.isEmpty) return;
    state = state.sublist(0, state.length - 1);
  }

  void replace(PageRouteInfo route) {
    state = [...state.sublist(0, state.length - 1), route];
  }

  /// Resets the stack to a single root route (used on logout).
  void clear([PageRouteInfo? root]) {
    state = root != null ? [root] : [];
  }
}
