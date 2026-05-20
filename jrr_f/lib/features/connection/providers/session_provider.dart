import 'package:jrr_f/core/db/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/providers.dart';
import '../../../core/error/app_exception.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/server_info.dart';
import 'session_state.dart';

part 'session_provider.g.dart';

@riverpod
class Session extends _$Session {
  Talker get _talker => ref.read(talkerProvider);

  @override
  SessionState build() {
    // Attempt silent reconnect on initial build.
    _attemptSilentReconnect();
    return const SessionState.restoring();
  }

  Future<void> _attemptSilentReconnect() async {
    _talker.info('[Session] Attempting silent reconnect');
    final repo = ref.read(connectionRepositoryProvider);
    final server = await getServerInfo();

    final prefs = ref.read(sharedPreferencesProvider);
    final lastZoneGuid = prefs.getString(kActiveZoneGuidKey);

    if (server == null) {
      if (lastZoneGuid == 'offline-zone-guid') {
        _talker.info(
          '[Session] No server but last zone was Offline — entering Offline Mode',
        );
        state = const SessionState.authenticated(
          serverInfo: ServerInfo.offline,
        );
      } else {
        _talker.debug('[Session] No saved server with token — showing login');
        state = const SessionState.unauthenticated();
      }
      return;
    }

    // NEW: If the last active zone was "offline", skip network reconnect
    // and enter Authenticated state immediately using the cached info.
    if (lastZoneGuid == 'offline-zone-guid') {
      _talker.info('[Session] Last zone was Offline — skipping reconnect');
      await repo.restoreSession(server);
      final scheme = server.useSsl ? 'https' : 'http';
      final activePort = server.useSsl ? server.sslPort : server.port;
      state = SessionState.authenticated(
        serverInfo: ServerInfo(
          id: 'offline-cached-server',
          name: server.friendlyName ?? 'JRiver (${server.host})',
          version: 'offline',
          platform: 'offline',
          address: '$scheme://${server.host}:$activePort',
        ),
      );
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
      useSsl: server.useSsl,
      sslPort: server.sslPort,
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

  Future<void> enterOfflineMode() async {
    _talker.info('[Session] Entering Offline Mode manually');

    // Set the pref so ActiveZone picks it up when it rebuilds in response
    // to the session state change below.
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(kActiveZoneGuidKey, 'offline-zone-guid');

    state = const SessionState.authenticated(serverInfo: ServerInfo.offline);
  }

  Future<String?> getPassword() async {
    final repo = ref.read(connectionRepositoryProvider);
    final server = await getServerInfo();
    if (server == null) return null;
    final password = await repo.getPassword(server.passwordKey);
    return password;
  }

  Future<SavedServer?> getServerInfo() async {
    final repo = ref.read(connectionRepositoryProvider);
    return await repo.getLastServerWithToken();
  }

  /// Attempts a manual connect. Returns null on success, [AppException] on failure.
  Future<AppException?> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    int sslPort = 52200,
  }) async {
    _talker.info(
      '[Session] Connecting to $host:$port as $username '
      '(ssl=$useSsl, sslPort=$sslPort)',
    );
    final result = await ref
        .read(connectionRepositoryProvider)
        .connect(
          host: host,
          port: port,
          username: username,
          password: password,
          useSsl: useSsl,
          sslPort: sslPort,
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
    await ref.read(connectionRepositoryProvider).clearSession();
    state = const SessionState.unauthenticated();
  }
}
