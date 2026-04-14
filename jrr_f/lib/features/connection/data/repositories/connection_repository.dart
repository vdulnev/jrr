import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_factory.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../../core/network/mcws_xml_parser.dart';
import '../models/server_info.dart';

class ConnectionRepository {
  final AppDatabase _db;
  final FlutterSecureStorage _secureStorage;
  final McwsXmlParser _parser;
  final Talker _talker;
  final McwsClient Function(String baseUrl, String? Function() tokenGetter)?
  _clientFactory;

  McwsClient? _client;
  String? _token;

  ConnectionRepository({
    required AppDatabase db,
    required FlutterSecureStorage secureStorage,
    required McwsXmlParser parser,
    required Talker talker,
    McwsClient Function(String baseUrl, String? Function() tokenGetter)?
    clientFactory,
  }) : _db = db,
       _secureStorage = secureStorage,
       _parser = parser,
       _talker = talker,
       _clientFactory = clientFactory;

  String? get token => _token;
  McwsClient? get client => _client;

  Future<Either<AppException, ServerInfo>> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    final baseUrl = 'http://$host:$port/MCWS/v1/';
    final factory = _clientFactory;
    final client = factory != null
        ? factory(baseUrl, () => _token)
        : McwsClient(
            dio: createDio(
              baseUrl: baseUrl,
              tokenGetter: () => _token,
              talker: _talker,
            ),
            parser: _parser,
          );

    final authResult = await client.authenticate(
      username: username,
      password: password,
    );
    if (authResult.isLeft()) {
      return left(authResult.getLeft().toNullable()!);
    }
    final token = authResult.getRight().toNullable()!;

    _token = token;
    _client = client;

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

    unawaited(
      _persistServer(host, port, username, password, name).catchError(
        (Object e) => _talker.warning('Failed to persist server: $e'),
      ),
    );

    return right(serverInfo);
  }

  void clearSession() {
    _token = null;
    _client = null;
  }

  Future<List<SavedServer>> getSavedServers() async {
    return (_db.select(
      _db.savedServers,
    )..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])).get();
  }

  Future<void> _persistServer(
    String host,
    int port,
    String username,
    String password,
    String friendlyName,
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
            ),
          );
    }
  }
}
