import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_setup_view_state.freezed.dart';

/// Pre-fill payload pulled from the most recently used saved server.
/// Mirrors the record returned by `lastServerProvider` so the view model
/// can hand it to the screen as a strongly-typed value.
@freezed
abstract class ServerSetupPrefill with _$ServerSetupPrefill {
  const factory ServerSetupPrefill({
    required String host,
    required int port,
    required String username,
    required String? password,
    required bool useSsl,
    required int sslPort,
  }) = _ServerSetupPrefill;
}

/// View model state for [ServerSetupScreen]. The form's connect status
/// (idle / loading / error) and the pre-fill payload are bundled so the
/// screen consumes a single provider.
@freezed
abstract class ServerSetupViewState with _$ServerSetupViewState {
  const factory ServerSetupViewState({
    required bool isConnecting,
    required Object? connectError,
    required ServerSetupPrefill? prefill,
  }) = _ServerSetupViewState;

  const ServerSetupViewState._();

  bool get hasError => connectError != null;
}
