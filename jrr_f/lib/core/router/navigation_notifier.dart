import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigation_notifier.g.dart';

enum AppTab { nowPlaying, queue, library, zones, settings }

@riverpod
class ActiveTab extends _$ActiveTab {
  @override
  AppTab build() => AppTab.nowPlaying;

  void select(AppTab tab) {
    state = tab;
  }
}
