import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/error/app_exception.dart';
import '../../library/data/models/tracks.dart';

part 'queue_view_state.freezed.dart';

/// View model state for [QueueScreen]. Bundles the queue tracks, the
/// currently-playing index, and the loading/error envelope so the
/// screen consumes a single provider.
@freezed
abstract class QueueViewState with _$QueueViewState {
  const factory QueueViewState({
    required Tracks? tracks,
    required Object? error,
    required int currentIndex,
  }) = _QueueViewState;

  const QueueViewState._();

  bool get isLoading => tracks == null && error == null;
  bool get hasError => error != null;
  bool get isEmpty => tracks?.isEmpty ?? false;

  /// Convenience: the error coerced to [AppException] when present.
  AppException? get appException =>
      error is AppException ? error as AppException : null;
}
