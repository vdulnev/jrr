import 'package:freezed_annotation/freezed_annotation.dart';

import '../../player/data/models/playback_state.dart';
import '../data/models/zone.dart';
import '../data/models/zones.dart';

part 'zone_list_view_state.freezed.dart';

/// View model state for [ZoneListScreen]. Bundles the zones list, the
/// active zone, and the active zone's playback state (for the inline
/// play/pause indicator) so the screen consumes a single provider.
@freezed
abstract class ZoneListViewState with _$ZoneListViewState {
  const factory ZoneListViewState({
    required Zones? zones,
    required Object? error,
    required Zone? activeZone,
    required PlaybackState? activePlaybackState,
  }) = _ZoneListViewState;

  const ZoneListViewState._();

  bool get isLoading => zones == null && error == null;
  bool get hasError => error != null;
}
