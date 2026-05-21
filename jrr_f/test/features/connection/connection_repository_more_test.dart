import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/core/network/models/auth_result.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockMcwsClient extends Mock implements McwsClient {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _TestConnectionRepository extends ConnectionRepositoryImpl {
  final McwsClient _mockClient;
  _TestConnectionRepository({
    required super.db,
    required super.secureStorage,
    required super.parser,
    required super.talker,
    required McwsClient mockClient,
  }) : _mockClient = mockClient;

  @override
  McwsClient buildClient(String baseUrl, String? Function() tokenGetter) =>
      _mockClient;
}

void main() {
  late MockMcwsClient client;
  late MockSecureStorage storage;
  late AppDatabase db;
  late _TestConnectionRepository repo;

  setUp(() {
    client = MockMcwsClient();
    storage = MockSecureStorage();
    db = AppDatabase(NativeDatabase.memory());
    repo = _TestConnectionRepository(
      db: db,
      secureStorage: storage,
      parser: McwsXmlParser(),
      talker: Talker(),
      mockClient: client,
    );

    when(
      () => storage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() async {
    await db.close();
  });

  group('lookupAccessKey', () {
    test('empty key returns parseError without hitting the network', () async {
      final result = await repo.lookupAccessKey('   ');
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<ParseErrorException>()),
        (_) => fail('expected left'),
      );
    });
  });

  group('getPassword', () {
    test('delegates to secure storage', () async {
      when(() => storage.read(key: 'k')).thenAnswer((_) async => 'pw');
      expect(await repo.getPassword('k'), 'pw');
    });
  });

  group('restoreSession', () {
    test(
      'binds an McwsClient on the listenable and stores the token',
      () async {
        // We need a SavedServer row; insert one and fetch.
        await _insertServer(
          db,
          host: 'h',
          port: 52199,
          username: 'u',
          token: 'tok-xyz',
        );
        final saved = (await repo.getSavedServers()).single;

        expect(repo.clientListenable.value, isNull);
        await repo.restoreSession(saved);
        expect(repo.currentToken, 'tok-xyz');
        expect(repo.clientListenable.value, isNotNull);
      },
    );

    test('uses SSL when the saved server flagged useSsl', () async {
      await _insertServer(
        db,
        host: 'h',
        port: 52199,
        username: 'u',
        token: 'tok',
        useSsl: true,
        sslPort: 52200,
      );
      final saved = (await repo.getSavedServers()).single;
      await repo.restoreSession(saved);
      expect(repo.clientListenable.value, isNotNull);
    });
  });

  group('getSavedServers', () {
    test('returns rows sorted by lastUsedAt descending', () async {
      await _insertServer(db, host: 'old', username: 'u', lastUsedAt: 100);
      await _insertServer(db, host: 'new', username: 'u', lastUsedAt: 200);
      final servers = await repo.getSavedServers();
      expect(servers.map((s) => s.host), ['new', 'old']);
    });
  });

  group('getLastServerWithToken', () {
    test('returns null when no servers exist', () async {
      expect(await repo.getLastServerWithToken(), isNull);
    });

    test('returns null when the most recent server has no token', () async {
      await _insertServer(db, host: 'h', username: 'u', token: null);
      expect(await repo.getLastServerWithToken(), isNull);
    });

    test('returns null when the most recent token is empty', () async {
      await _insertServer(db, host: 'h', username: 'u', token: '');
      expect(await repo.getLastServerWithToken(), isNull);
    });

    test(
      'returns the most recent server when it has a non-empty token',
      () async {
        await _insertServer(
          db,
          host: 'old',
          username: 'u',
          token: 'tok-old',
          lastUsedAt: 100,
        );
        await _insertServer(
          db,
          host: 'new',
          username: 'u',
          token: 'tok-new',
          lastUsedAt: 200,
        );
        final last = await repo.getLastServerWithToken();
        expect(last?.host, 'new');
        expect(last?.authToken, 'tok-new');
      },
    );
  });

  group('clearSession', () {
    test(
      'clears the authToken on all saved servers and detaches the client',
      () async {
        // Connect once so there's a token & client to clear.
        when(
          () => client.authenticate(username: 'u', password: 'p'),
        ).thenAnswer((_) async => right(const AuthResult(token: 'live')));
        when(() => client.alive()).thenAnswer((_) async => right(unit));
        final connectResult = await repo.connect(
          host: 'h',
          port: 52199,
          username: 'u',
          password: 'p',
        );
        expect(connectResult.isRight(), isTrue);
        expect(repo.currentToken, 'live');

        await repo.clearSession();

        expect(repo.currentToken, isNull);
        expect(repo.clientListenable.value, isNull);
        final servers = await repo.getSavedServers();
        expect(servers, isNotEmpty);
        expect(servers.every((s) => s.authToken == null), isTrue);
      },
    );
  });

  group('connect — persistence', () {
    test(
      'updates the existing row instead of inserting on reconnect',
      () async {
        when(
          () => client.authenticate(username: 'u', password: 'p'),
        ).thenAnswer((_) async => right(const AuthResult(token: 't1')));
        when(() => client.alive()).thenAnswer((_) async => right(unit));

        await repo.connect(
          host: 'h',
          port: 52199,
          username: 'u',
          password: 'p',
        );
        expect((await repo.getSavedServers()), hasLength(1));

        when(
          () => client.authenticate(username: 'u', password: 'p'),
        ).thenAnswer((_) async => right(const AuthResult(token: 't2')));
        await repo.connect(
          host: 'h',
          port: 52199,
          username: 'u',
          password: 'p',
        );

        final servers = await repo.getSavedServers();
        expect(servers, hasLength(1));
        expect(servers.single.authToken, 't2');
      },
    );
  });
}

Future<void> _insertServer(
  AppDatabase db, {
  required String host,
  int port = 52199,
  required String username,
  String? token,
  int? lastUsedAt,
  bool useSsl = false,
  int sslPort = 52200,
}) async {
  await db
      .into(db.savedServers)
      .insert(
        SavedServersCompanion.insert(
          host: host,
          port: Value(port),
          username: username,
          passwordKey: 'k-$host-$username',
          friendlyName: const Value('Friendly'),
          lastUsedAt: Value(
            lastUsedAt ?? DateTime.now().millisecondsSinceEpoch,
          ),
          authToken: Value(token),
          useSsl: Value(useSsl),
          sslPort: Value(sslPort),
        ),
      );
}
