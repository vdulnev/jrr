import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/server_setup_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MockConnectionRepo extends Mock implements ConnectionRepository {}

class MockClientNotifier extends ValueNotifier<McwsClient?> {
  MockClientNotifier() : super(null);
}

void main() {
  late MockConnectionRepo repo;
  late ProviderContainer container;

  setUp(() async {
    repo = MockConnectionRepo();
    when(() => repo.clientListenable).thenReturn(MockClientNotifier());
    when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    container = ProviderContainer(
      overrides: [
        connectionRepositoryProvider.overrideWithValue(repo),
        sharedPreferencesProvider.overrideWithValue(prefs),
        talkerProvider.overrideWithValue(Talker()),
      ],
    );
    addTearDown(container.dispose);
  });

  group('connectWithHost', () {
    test('null state on success', () async {
      const info = ServerInfo(
        id: 'srv',
        name: 'Home',
        version: '32',
        platform: 'win',
        address: 'http://h:52199',
      );
      when(
        () => repo.connect(
          host: any(named: 'host'),
          port: any(named: 'port'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          useSsl: any(named: 'useSsl'),
          sslPort: any(named: 'sslPort'),
        ),
      ).thenAnswer((_) async => right(info));

      await container
          .read(serverSetupFormProvider.notifier)
          .connectWithHost(
            host: 'h',
            port: 52199,
            username: 'u',
            password: 'p',
          );

      expect(container.read(serverSetupFormProvider), isNull);
    });

    test('AsyncError state on failure', () async {
      when(
        () => repo.connect(
          host: any(named: 'host'),
          port: any(named: 'port'),
          username: any(named: 'username'),
          password: any(named: 'password'),
          useSsl: any(named: 'useSsl'),
          sslPort: any(named: 'sslPort'),
        ),
      ).thenAnswer((_) async => left(const AppException.unauthorized()));

      await container
          .read(serverSetupFormProvider.notifier)
          .connectWithHost(
            host: 'h',
            port: 52199,
            username: 'u',
            password: 'p',
          );

      final form = container.read(serverSetupFormProvider);
      expect(form, isA<AsyncError<void>>());
      expect(form!.error, isA<UnauthorizedException>());
    });
  });

  group('connectWithAccessKey', () {
    test('AsyncError when lookup fails', () async {
      when(() => repo.lookupAccessKey('XX')).thenAnswer(
        (_) async => left(const AppException.parseError(details: 'bad')),
      );

      await container
          .read(serverSetupFormProvider.notifier)
          .connectWithAccessKey(accessKey: 'XX', username: 'u', password: 'p');

      final form = container.read(serverSetupFormProvider);
      expect(form, isA<AsyncError<void>>());
      expect(form!.error, isA<ParseErrorException>());
    });

    test('proceeds with resolved host/port on lookup success', () async {
      when(() => repo.lookupAccessKey('ABCD12')).thenAnswer(
        (_) async => right(
          const AccessKeyLookupResult(host: 'h', port: 52199, httpsPort: 52200),
        ),
      );
      when(
        () => repo.connect(
          host: 'h',
          port: 52199,
          username: 'u',
          password: 'p',
          useSsl: true,
          sslPort: 52200,
        ),
      ).thenAnswer(
        (_) async => right(
          const ServerInfo(
            id: 's',
            name: 'n',
            version: '32',
            platform: 'p',
            address: 'a',
          ),
        ),
      );

      await container
          .read(serverSetupFormProvider.notifier)
          .connectWithAccessKey(
            accessKey: 'ABCD12',
            username: 'u',
            password: 'p',
            useSsl: true,
          );

      expect(container.read(serverSetupFormProvider), isNull);
      verify(
        () => repo.connect(
          host: 'h',
          port: 52199,
          username: 'u',
          password: 'p',
          useSsl: true,
          sslPort: 52200,
        ),
      ).called(1);
    });

    test(
      'falls back to default SSL port when lookup omits httpsport',
      () async {
        when(() => repo.lookupAccessKey('ABCD12')).thenAnswer(
          (_) async =>
              right(const AccessKeyLookupResult(host: 'h', port: 52199)),
        );
        when(
          () => repo.connect(
            host: any(named: 'host'),
            port: any(named: 'port'),
            username: any(named: 'username'),
            password: any(named: 'password'),
            useSsl: any(named: 'useSsl'),
            sslPort: any(named: 'sslPort'),
          ),
        ).thenAnswer(
          (_) async => right(
            const ServerInfo(
              id: 's',
              name: 'n',
              version: '32',
              platform: 'p',
              address: 'a',
            ),
          ),
        );

        await container
            .read(serverSetupFormProvider.notifier)
            .connectWithAccessKey(
              accessKey: 'ABCD12',
              username: 'u',
              password: 'p',
              useSsl: true,
            );

        verify(
          () => repo.connect(
            host: 'h',
            port: 52199,
            username: 'u',
            password: 'p',
            useSsl: true,
            sslPort: 52200,
          ),
        ).called(1);
      },
    );
  });
}
