import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../../core/network/mcws_xml_parser.dart';
import '../models/server_info.dart';
import 'connection_repository.dart';

const _sessionScopeName = 'session';

class ConnectionRepositoryImpl implements ConnectionRepository {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;
  final McwsXmlParser _parser;
  final Talker _talker;

  String? _token;
  bool _hasSessionScope = false;

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
        tokenGetter: tokenGetter,
        talker: _talker,
      );

  @override
  Future<Either<AppException, ServerInfo>> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    await clearSession();

    final baseUrl = 'http://$host:$port/MCWS/v1/';
    final client = buildClient(baseUrl, () => _token);

    final authResult = await client.authenticate(
      username: username,
      password: password,
    );
    if (authResult.isLeft()) {
      return left(authResult.getLeft().toNullable()!);
    }
    _token = authResult.getRight().toNullable()!;

    final aliveResult = await client.alive();
    if (aliveResult.isLeft()) {
      return left(aliveResult.getLeft().toNullable()!);
    }
    final fields = aliveResult.getRight().toNullable()!;

    final id = fields['RuntimeGUID'];
    final name = fields['FriendlyName'];
    final version = fields['ProgramVersion'];
    final platform = fields['Platform'];

    if (id == null || name == null || version == null || platform == null) {
      return left(
        const AppException.parseError(
          details: 'Missing fields in Alive response',
        ),
      );
    }

    final serverInfo = ServerInfo(
      id: id,
      name: name,
      version: version,
      platform: platform,
      address: 'http://$host:$port',
    );

    getIt.pushNewScope(
      scopeName: _sessionScopeName,
      init: (gi) => gi.registerSingleton<McwsClient>(client),
    );
    _hasSessionScope = true;

    try {
      await _persistServer(host, port, username, password, name, _token);
    } catch (e) {
      _talker.warning('Failed to persist server: $e');
    }

    return right(serverInfo);
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

    if (_hasSessionScope) {
      _hasSessionScope = false;
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
    if (server.authToken == null || server.authToken!.isEmpty) {
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
    String? authToken,
  ) async {
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
            ),
          );
    }
  }
}
