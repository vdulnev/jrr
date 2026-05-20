import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../player/providers/player_provider.dart';
import '../data/models/zone.dart';
import 'active_zone_provider.dart';
import 'zone_list_view_state.dart';
import 'zone_provider.dart';

part 'zone_list_view_model.g.dart';

@riverpod
class ZoneListViewModel extends _$ZoneListViewModel {
  @override
  ZoneListViewState build() {
    final zonesAsync = ref.watch(zoneListProvider);
    final activeZone = ref.watch(activeZoneProvider);
    // Watching the full status here is fine: this VM exposes only `state`,
    // so the produced ZoneListViewState compares equal across polls when
    // only positionMs changes, and Riverpod short-circuits the notification.
    final status = ref.watch(playerProvider).value;
    return ZoneListViewState(
      zones: zonesAsync.value,
      error: zonesAsync.error,
      activeZone: activeZone,
      activePlaybackState: status?.state,
    );
  }

  void refresh() => ref.invalidate(zoneListProvider);

  void setZone(Zone zone) =>
      ref.read(activeZoneProvider.notifier).setZone(zone);
}
