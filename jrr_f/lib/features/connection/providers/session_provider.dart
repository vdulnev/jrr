import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/router/navigation_notifier.dart';
import '../data/repositories/connection_repository.dart';
import 'session_state.dart';

part 'session_provider.g.dart';

@riverpod
class Session extends _$Session {
  @override
  SessionState build() {
    // Attempt silent reconnect on initial build
    _attemptSilentReconnect();
    return const SessionState.unauthenticated();
  }

  Future<void> _attemptSilentReconnect() async {
    final repo = getIt<ConnectionRepository>();
    final server = await repo.getLastServerWithToken();

    if (server == null) return;

    final password = await repo.getPassword(server.passwordKey);
    if (password == null) return;

    // Try to connect silently
    final result = await repo.connect(
      host: server.host,
      port: server.port,
      username: server.username,
      password: password,
    );

    result.fold(
      (e) {
        // Silent fail - keep state as unauthenticated
      },
      (info) {
        state = SessionState.authenticated(serverInfo: info);
      },
    );
  }

  /// Returns null on success, AppException on failure.
  Future<AppException?> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    final result = await getIt<ConnectionRepository>().connect(
      host: host,
      port: port,
      username: username,
      password: password,
    );
    return result.fold((e) => e, (info) {
      state = SessionState.authenticated(serverInfo: info);
      return null;
    });
  }

  Future<void> logout() async {
    await getIt<ConnectionRepository>().clearSession();
    state = const SessionState.unauthenticated();
    ref.read(navigationProvider.notifier).clear();
  }
}
