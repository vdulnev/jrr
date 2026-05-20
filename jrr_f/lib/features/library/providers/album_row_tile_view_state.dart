import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_row_tile_view_state.freezed.dart';

/// View model state for [AlbumRowTile]. Bundles the offline-mode flag
/// and the per-album download flags so the tile consumes a single
/// (family-keyed) provider.
@freezed
abstract class AlbumRowTileViewState with _$AlbumRowTileViewState {
  const factory AlbumRowTileViewState({
    required bool isOffline,
    required bool showDownload,
    required bool showCancel,
    required bool showDelete,
    required bool showRetry,
    required bool hidden,
  }) = _AlbumRowTileViewState;
}
