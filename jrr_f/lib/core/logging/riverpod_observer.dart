import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talker/talker.dart';

/// Logs Riverpod provider errors to Talker.
///
/// Only errors are logged (provider failures and AsyncError state transitions).
/// Add/dispose lifecycle events are intentionally omitted to keep logs readable.
base class AppRiverpodObserver extends ProviderObserver {
  final Talker _talker;

  const AppRiverpodObserver(this._talker);

  /// Fires when a provider throws synchronously during build.
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    _talker.error(
      '[Riverpod] ${_name(context)} build failed',
      error,
      stackTrace,
    );
  }

  /// Fires on every state update — we only care about transitions into AsyncError.
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (newValue is AsyncError) {
      _talker.error(
        '[Riverpod] ${_name(context)} → AsyncError',
        newValue.error,
        newValue.stackTrace,
      );
    }
  }

  String _name(ProviderObserverContext context) =>
      context.provider.name ?? context.provider.runtimeType.toString();
}
