import 'dart:async';

import 'package:dio/dio.dart' show DioException;
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/jriver_lookup_api.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../../core/network/mcws_xml_parser.dart';
import '../../../../core/network/ssl_trust.dart';
import '../models/server_info.dart';
import 'connection_repository.dart';

const _sessionScopeName = 'session';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;
  final McwsXmlParser _parser;
  final Talker _talker;

  String? _token;

  ConnectionRepositoryImpl({
    required AppDatabase db,
    required FlutterSecureStorage secureStorage,
    required McwsXmlParser parser,
    required Talker talker,
  }) : _db = db,
       _secureStorage = secureStorage,
       _parser = parser,
       _talker = talker;

  @override
  String? get currentToken => _token;

  @override
  Future<String?> getPassword(String key) => _secureStorage.read(key: key);

  /// Override in tests to inject a mock [McwsClient].
  @visibleForTesting
  McwsClient buildClient(String baseUrl, String? Function() tokenGetter) =>
      McwsClient(
        dio: createDio(
          baseUrl: baseUrl,
          tokenGetter: tokenGetter,
          talker: _talker,
        ),
        parser: _parser,
      );

  String _buildBaseUrl({
    required String host,
    required int port,
    required bool useSsl,
    required int sslPort,
    required bool includeMcwsPath,
  }) {
    final scheme = useSsl ? 'https' : 'http';
    final effectivePort = useSsl ? sslPort : port;
    final suffix = includeMcwsPath ? '/MCWS/v1/' : '';
    return '$scheme://$host:$effectivePort$suffix';
  }

  @override
  Future<Either<AppException, AccessKeyLookupResult>> lookupAccessKey(
    String accessKey,
  ) async {
    final key = accessKey.trim();
    if (key.isEmpty) {
      return left(
        const AppException.parseError(details: 'Access key is empty'),
      );
    }
    try {
      // Public JRiver registry — separate retrofit api with no auth.
      final dio = createPublicDio(talker: _talker);
      final body = await JRiverLookupApi(dio).lookup(key);
      _talker.debug('[ConnectionRepo] Access key lookup raw body: $body');

      // The lookup endpoint uses plain XML elements (<ip>…</ip>,
      // <port>…</port>, <localiplist>…</localiplist>) rather than the
      // MCWS <Item Name="…"> format, so the shared MCWS parser doesn't
      // apply. Extract the few fields we need with a small regex.
      String? element(String tag) {
        final m = RegExp(
          '<$tag>([^<]*)</$tag>',
          caseSensitive: false,
        ).firstMatch(body);
        return m?.group(1)?.trim();
      }

      String? firstNonEmpty(List<String?> candidates) {
        for (final v in candidates) {
          final t = v?.trim();
          if (t != null && t.isNotEmpty) return t;
        }
        return null;
      }

      final host = firstNonEmpty([
        element('localiplist')?.split(',').firstOrNull,
        element('ip'),
      ]);
      final port = int.tryParse(element('port') ?? '');
      final httpsPort = int.tryParse(element('httpsport') ?? '');
      if (host == null || port == null) {
        return left(
          const AppException.parseError(
            details: 'Lookup response missing IP/Port',
          ),
        );
      }
      return right(
        AccessKeyLookupResult(host: host, port: port, httpsPort: httpsPort),
      );
    } on DioException catch (e) {
      _talker.warning('[ConnectionRepo] Access key lookup failed: $e');
      return left(
        AppException.connectionRefused(
          address: e.requestOptions.uri.toString(),
        ),
      );
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, ServerInfo>> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    int sslPort = 52200,
  }) async {
    await clearSession();

    if (useSsl) {
      JRiverHttpOverrides.instance.trustHost(host);
    }

    final baseUrl = _buildBaseUrl(
      host: host,
      port: port,
      useSsl: useSsl,
      sslPort: sslPort,
      includeMcwsPath: true,
    );
    final client = buildClient(baseUrl, () => _token);

    final authResult = await client.authenticate(
      username: username,
      password: password,
    );
    final token = authResult.match((e) => null, (r) => r.token);

    if (token == null) {
      return left(
        authResult.match((e) => e, (_) => const AppException.unauthorized()),
      );
    }
    _token = token;

    final aliveResult = await client.alive();
    if (aliveResult.isLeft()) {
      return left(aliveResult.match((e) => e, (_) => throw Exception()));
    }

    final serverInfo = ServerInfo(
      id: 'server-${host.replaceAll('.', '-')}',
      name: 'JRiver ($host)',
      version: 'unknown',
      platform: 'unknown',
      address: _buildBaseUrl(
        host: host,
        port: port,
        useSsl: useSsl,
        sslPort: sslPort,
        includeMcwsPath: false,
      ),
    );

    getIt.pushNewScope(
      scopeName: _sessionScopeName,
      init: (gi) => gi.registerSingleton<McwsClient>(client),
    );

    try {
      await _persistServer(
        host,
        port,
        username,
        password,
        serverInfo.name,
        _token,
        useSsl: useSsl,
        sslPort: sslPort,
      );
    } catch (e) {
      _talker.warning('Failed to persist server: $e');
    }

    return right(serverInfo);
  }

  @override
  Future<void> restoreSession(SavedServer server) async {
    await _popScope();

    if (server.useSsl) {
      JRiverHttpOverrides.instance.trustHost(server.host);
    }

    final baseUrl = _buildBaseUrl(
      host: server.host,
      port: server.port,
      useSsl: server.useSsl,
      sslPort: server.sslPort,
      includeMcwsPath: true,
    );
    _token = server.authToken;
    final client = buildClient(baseUrl, () => _token);

    getIt.pushNewScope(
      scopeName: _sessionScopeName,
      init: (gi) => gi.registerSingleton<McwsClient>(client),
    );
  }

  @override
  Future<void> clearSession() async {
    _token = null;

    // Clear the persisted auth token from all saved servers
    try {
      await (_db.update(
        _db.savedServers,
      )).write(const SavedServersCompanion(authToken: Value(null)));
    } catch (_) {
      // Ignore database errors (e.g., in tests with mocks)
    }

    await _popScope();
  }

  FutureOr<void> _popScope() async {
    if (getIt.currentScopeName == _sessionScopeName) {
      await getIt.popScope();
    }
  }

  @override
  Future<List<SavedServer>> getSavedServers() async {
    return (_db.select(
      _db.savedServers,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])).get();
  }

  @override
  Future<SavedServer?> getLastServerWithToken() async {
    final servers =
        await (_db.select(_db.savedServers)
              ..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])
              ..limit(1))
            .get();

    if (servers.isEmpty) return null;

    final server = servers.first;
    // Only return if it has a non-null, non-empty token
    final token = server.authToken;
    if (token == null || token.isEmpty) {
      return null;
    }

    return server;
  }

  Future<void> _persistServer(
    String host,
    int port,
    String username,
    String password,
    String friendlyName,
    String? authToken, {
    required bool useSsl,
    required int sslPort,
  }) async {
    final key = 'server_${host}_${port}_$username';
    await _secureStorage.write(key: key, value: password);

    final existing =
        await (_db.select(_db.savedServers)..where(
              (t) =>
                  t.host.equals(host) &
                  t.port.equals(port) &
                  t.username.equals(username),
            ))
            .getSingleOrNull();

    final now = DateTime.now().millisecondsSinceEpoch;

    if (existing != null) {
      await (_db.update(
        _db.savedServers,
      )..where((t) => t.id.equals(existing.id))).write(
        SavedServersCompanion(
          friendlyName: Value(friendlyName),
          lastUsedAt: Value(now),
          authToken: Value(authToken),
          useSsl: Value(useSsl),
          sslPort: Value(sslPort),
        ),
      );
    } else {
      await _db
          .into(_db.savedServers)
          .insert(
            SavedServersCompanion.insert(
              host: host,
              port: Value(port),
              username: username,
              passwordKey: key,
              friendlyName: Value(friendlyName),
              lastUsedAt: Value(now),
              authToken: Value(authToken),
              useSsl: Value(useSsl),
              sslPort: Value(sslPort),
            ),
          );
    }
  }
}
