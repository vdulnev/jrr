import 'package:freezed_annotation/freezed_annotation.dart';

part 'downloaded_artists_view_state.freezed.dart';

/// View model state for [DownloadedArtistsScreen]. Wraps the downloaded
/// artists list with the loading/error envelope so the screen consumes a
/// single provider.
@freezed
abstract class DownloadedArtistsViewState with _$DownloadedArtistsViewState {
  const factory DownloadedArtistsViewState({
    required List<String>? artists,
    required Object? error,
  }) = _DownloadedArtistsViewState;

  const DownloadedArtistsViewState._();

  bool get isLoading => artists == null && error == null;
  bool get hasError => error != null;
  bool get isEmpty => artists?.isEmpty ?? false;
}
