import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/repositories/connection_repository.dart';
import 'session_provider.dart';

part 'server_setup_provider.g.dart';

/// Holds the submission state for [ServerSetupScreen].
/// null  = idle, AsyncLoading = connecting, AsyncError = failed.
/// Auto-disposed when the screen leaves the tree.
@riverpod
class ServerSetupForm extends _$ServerSetupForm {
  @override
  AsyncValue<void>? build() => null;

  Future<void> connectWithAccessKey({
    required String accessKey,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();

    final lookup = await getIt<ConnectionRepository>().lookupAccessKey(
      accessKey,
    );
    final resolved = lookup.match((_) => null, (r) => r);
    if (resolved == null) {
      state = AsyncValue.error(
        lookup.fold((e) => e, (_) => Exception('lookup failed')),
        StackTrace.current,
      );
      return;
    }

    await _connect(
      host: resolved.host,
      port: resolved.port,
      username: username,
      password: password,
    );
  }

  Future<void> connectWithHost({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    await _connect(
      host: host,
      port: port,
      username: username,
      password: password,
    );
  }

  Future<void> _connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
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
