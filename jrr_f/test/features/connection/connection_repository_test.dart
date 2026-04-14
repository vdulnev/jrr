import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockMcwsClient extends Mock implements McwsClient {}

class MockAppDatabase extends Mock implements AppDatabase {}

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockMcwsClient mockClient;
  late ConnectionRepository repo;

  const host = 'localhost';
  const port = 52199;
  const username = 'testuser';
  const password = 'testpass';

  const validServerInfo = ServerInfo(
    id: 'guid-123',
    name: 'Test Server',
    version: '33.0.0',
    platform: 'Windows',
    address: 'http://$host:$port',
  );

  final aliveFields = {
    'RuntimeGUID': 'guid-123',
    'FriendlyName': 'Test Server',
    'ProgramVersion': '33.0.0',
    'Platform': 'Windows',
  };

  setUp(() {
    mockClient = MockMcwsClient();

    repo = ConnectionRepository(
      db: MockAppDatabase(),
      secureStorage: MockFlutterSecureStorage(),
      parser: McwsXmlParser(),
      talker: Talker(),
      clientFactory: (baseUrl, tokenGetter) => mockClient,
    );
  });

  group('connect()', () {
    test('success: returns Right<ServerInfo> and sets token', () async {
      when(
        () => mockClient.authenticate(username: username, password: password),
      ).thenAnswer((_) async => right('token-abc'));

      when(
        () => mockClient.alive(),
      ).thenAnswer((_) async => right(aliveFields));

      final result = await repo.connect(
        host: host,
        port: port,
        username: username,
        password: password,
      );

      expect(result.isRight(), true);
      result.fold((_) => fail('Expected Right'), (info) {
        expect(info.id, validServerInfo.id);
        expect(info.name, validServerInfo.name);
        expect(info.address, validServerInfo.address);
      });
      expect(repo.token, 'token-abc');
    });

    test('auth failure: returns Left<AppException.unauthorized>', () async {
      when(
        () => mockClient.authenticate(username: username, password: password),
      ).thenAnswer((_) async => left(const AppException.unauthorized()));

      final result = await repo.connect(
        host: host,
        port: port,
        username: username,
        password: password,
      );

      expect(result.isLeft(), true);
      result.fold(
        (e) => expect(e, isA<UnauthorizedException>()),
        (_) => fail('Expected Left'),
      );
      expect(repo.token, isNull);
    });

    test(
      'server unreachable: returns Left<AppException.connectionRefused>',
      () async {
        when(
          () => mockClient.authenticate(username: username, password: password),
        ).thenAnswer(
          (_) async => left(
            const AppException.connectionRefused(address: 'localhost:52199'),
          ),
        );

        final result = await repo.connect(
          host: host,
          port: port,
          username: username,
          password: password,
        );

        expect(result.isLeft(), true);
        result.fold(
          (e) => expect(e, isA<ConnectionRefusedException>()),
          (_) => fail('Expected Left'),
        );
      },
    );
  });

  group('clearSession()', () {
    test('sets token to null', () async {
      when(
        () => mockClient.authenticate(username: username, password: password),
      ).thenAnswer((_) async => right('token-abc'));

      when(
        () => mockClient.alive(),
      ).thenAnswer((_) async => right(aliveFields));

      await repo.connect(
        host: host,
        port: port,
        username: username,
        password: password,
      );

      expect(repo.token, isNotNull);

      repo.clearSession();

      expect(repo.token, isNull);
      expect(repo.client, isNull);
    });
  });
}
