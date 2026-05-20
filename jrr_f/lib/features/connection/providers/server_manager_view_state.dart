import 'package:freezed_annotation/freezed_annotation.dart';

import '../../offline/data/models/download_job.dart';
import '../data/models/server_info.dart';

part 'server_manager_view_state.freezed.dart';

/// View model state for [ServerManagerScreen]. Bundles the active server
/// info, offline-storage stats, and the failed-download list so the
/// screen consumes a single provider.
@freezed
abstract class ServerManagerViewState with _$ServerManagerViewState {
  const factory ServerManagerViewState({
    required ServerInfo? serverInfo,
    required int downloadedTracksCount,
    required int downloadedTotalBytes,
    required List<DownloadJob> failedJobs,
  }) = _ServerManagerViewState;

  const ServerManagerViewState._();

  bool get isAuthenticated => serverInfo != null;

  /// True when the session is the synthetic offline placeholder (no live
  /// server). Used to flip the logout button into a "Setup Server" CTA.
  bool get isSyntheticOffline => serverInfo?.id == 'offline';
}
