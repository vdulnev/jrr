import 'package:jrr_f/core/db/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../data/repositories/connection_repository.dart';
import 'session_state.dart';

part 'session_provider.g.dart';

@riverpod
class Session extends _$Session {
  Talker get _talker => getIt<Talker>();

  @override
  SessionState build() {
    // Attempt silent reconnect on initial build.
    _attemptSilentReconnect();
    return const SessionState.restoring();
  }

  Future<void> _attemptSilentReconnect() async {
    _talker.info('[Session] Attempting silent reconnect');
    final repo = getIt<ConnectionRepository>();
    final server = await getServerInfo();

    if (server == null) {
      _talker.debug('[Session] No saved server with token — showing login');
      state = const SessionState.unauthenticated();
      return;
    }

    final password = await getPassword();
    if (password == null) {
      _talker.debug('[Session] Saved server has no password — showing login');
      state = const SessionState.unauthenticated();
      return;
    }

    _talker.info('[Session] Reconnecting to ${server.host}:${server.port}');
    final result = await repo.connect(
      host: server.host,
      port: server.port,
      username: server.username,
      password: password,
    );

    result.fold(
      (e) {
        _talker.warning('[Session] Silent reconnect failed: $e');
        state = const SessionState.unauthenticated();
      },
      (info) {
        _talker.info(
          '[Session] Silent reconnect succeeded: ${info.name} '
          '(${info.version} on ${info.platform})',
        );
        state = SessionState.authenticated(serverInfo: info);
      },
    );
  }

  Future<String?> getPassword() async {
    final repo = getIt<ConnectionRepository>();
    final server = await getServerInfo();
    if (server == null) return null;
    final password = await repo.getPassword(server.passwordKey);
    return password;
  }

  Future<SavedServer?> getServerInfo() async {
    final repo = getIt<ConnectionRepository>();
    return await repo.getLastServerWithToken();
  }

  /// Attempts a manual connect. Returns null on success, [AppException] on failure.
  Future<AppException?> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    _talker.info('[Session] Connecting to $host:$port as $username');
    final result = await getIt<ConnectionRepository>().connect(
      host: host,
      port: port,
      username: username,
      password: password,
    );
    return result.fold(
      (e) {
        _talker.error('[Session] Connect failed', e);
        return e;
      },
      (info) {
        _talker.info(
          '[Session] Connected to ${info.name} '
          '(${info.version} on ${info.platform})',
        );
        state = SessionState.authenticated(serverInfo: info);
        return null;
      },
    );
  }

  Future<void> logout() async {
    _talker.info('[Session] Logout');
    await getIt<ConnectionRepository>().clearSession();
    state = const SessionState.unauthenticated();
  }
}
