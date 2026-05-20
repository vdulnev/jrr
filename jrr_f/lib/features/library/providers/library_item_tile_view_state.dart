import 'package:freezed_annotation/freezed_annotation.dart';

import '../../offline/data/models/download_state.dart';

part 'library_item_tile_view_state.freezed.dart';

/// View model state for [LibraryItemTile]. Bundles the offline-mode flag
/// and the per-file download status so the tile consumes a single
/// (family-keyed) provider.
@freezed
abstract class LibraryItemTileViewState with _$LibraryItemTileViewState {
  const factory LibraryItemTileViewState({
    required bool isOffline,
    required DownloadState downloadState,
  }) = _LibraryItemTileViewState;

  const LibraryItemTileViewState._();

  /// Hide the popup menu when we're offline and the track isn't downloaded
  /// — there's no actionable operation to surface.
  bool get hideMenu => isOffline && downloadState != DownloadState.downloaded;
}
