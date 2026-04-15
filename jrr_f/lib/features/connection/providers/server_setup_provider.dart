import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'session_provider.dart';

part 'server_setup_provider.g.dart';

/// Holds the submission state for [ServerSetupScreen].
/// null  = idle, AsyncLoading = connecting, AsyncError = failed.
/// Auto-disposed when the screen leaves the tree.
@riverpod
class ServerSetupForm extends _$ServerSetupForm {
  @override
  AsyncValue<void>? build() => null;

  Future<void> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final error = await ref
        .read(sessionProvider.notifier)
        .connect(
          host: host,
          port: port,
          username: username,
          password: password,
        );
    state = error != null ? AsyncValue.error(error, StackTrace.current) : null;
  }
}
