import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracks_popup_menu_view_state.freezed.dart';

/// View model state for [TracksPopupMenu]. Pre-computes the visibility
/// flags for each download-related popup item so the widget consumes a
/// single (family-keyed) provider.
@freezed
abstract class TracksPopupMenuViewState with _$TracksPopupMenuViewState {
  const factory TracksPopupMenuViewState({
    required bool isOffline,
    required bool hidden,
    required bool showDownload,
    required bool showCancel,
    required bool showDelete,
    required bool showRetry,
  }) = _TracksPopupMenuViewState;
}
