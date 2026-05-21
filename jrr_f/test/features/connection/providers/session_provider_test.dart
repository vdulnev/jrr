import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MockConnectionRepository extends Mock implements ConnectionRepository {}

class MockClientNotifier extends ValueNotifier<McwsClient?> {
  MockClientNotifier() : super(null);
}

void main() {
  late MockConnectionRepository repo;
  late ProviderContainer container;
  late SharedPreferences prefs;

  Future<void> openContainer({Map<String, Object> seed = const {}}) async {
    SharedPreferences.setMockInitialValues(seed);
    prefs = await SharedPreferences.getInstance();
    container = ProviderContainer(
      overrides: [
        connectionRepositoryProvider.overrideWithValue(repo),
        sharedPreferencesProvider.overrideWithValue(prefs),
        talkerProvider.overrideWithValue(Talker()),
        appDatabaseProvider.overrideWithValue(
          AppDatabase(NativeDatabase.memory()),
        ),
      ],
    );
    addTearDown(container.dispose);
  }

  setUp(() {
    repo = MockConnectionRepository();
    when(() => repo.clientListenable).thenReturn(MockClientNotifier());
  });

  Future<SessionState> waitFor(
    bool Function(SessionState) predicate, {
    Duration timeout = const Duration(seconds: 2),
  }) async {
    final completer = Completer<SessionState>();
    final sub = container.listen<SessionState>(sessionProvider, (_, next) {
      if (!completer.isCompleted && predicate(next)) {
        completer.complete(next);
      }
    }, fireImmediately: true);
    addTearDown(sub.close);
    return completer.future.timeout(timeout);
  }

  group('silent reconnect on build()', () {
    test('no saved server → unauthenticated', () async {
      await openContainer();
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);

      final state = await waitFor((s) => s is Unauthenticated);
      expect(state, isA<Unauthenticated>());
    });

    test(
      'no server but last zone was offline → authenticated(offline)',
      () async {
        await openContainer(seed: {kActiveZoneGuidKey: 'offline-zone-guid'});
        when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);

        final state = await waitFor((s) => s is Authenticated);
        expect((state as Authenticated).serverInfo, ServerInfo.offline);
      },
    );

    test('saved server but no password → unauthenticated', () async {
      await openContainer();
      const server = SavedServer(
        id: 1,
        host: 'h',
        port: 52199,
        username: 'u',
        passwordKey: 'k',
        useSsl: false,
        sslPort: 52200,
      );
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => server);
      when(() => repo.getPassword('k')).thenAnswer((_) async => null);

      final state = await waitFor((s) => s is Unauthenticated);
      expect(state, isA<Unauthenticated>());
    });

    test(
      'saved server with offline last-zone reuses the cached info',
      () async {
        await openContainer(seed: {kActiveZoneGuidKey: 'offline-zone-guid'});
        const server = SavedServer(
          id: 1,
          host: 'host',
          port: 52199,
          username: 'u',
          passwordKey: 'k',
          friendlyName: 'Home',
          useSsl: false,
          sslPort: 52200,
        );
        when(
          () => repo.getLastServerWithToken(),
        ).thenAnswer((_) async => server);
        when(() => repo.restoreSession(server)).thenAnswer((_) async {});

        final state = await waitFor((s) => s is Authenticated);
        final auth = state as Authenticated;
        expect(auth.serverInfo.id, 'offline-cached-server');
        expect(auth.serverInfo.address, 'http://host:52199');
      },
    );

    test('silent reconnect succeeds → authenticated(serverInfo)', () async {
      await openContainer();
      const server = SavedServer(
        id: 1,
        host: 'h',
        port: 52199,
        username: 'u',
        passwordKey: 'k',
        useSsl: false,
        sslPort: 52200,
      );
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => server);
      when(() => repo.getPassword('k')).thenAnswer((_) async => 'pw');
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

      final state = await waitFor((s) => s is Authenticated);
      expect((state as Authenticated).serverInfo, info);
    });

    test('silent reconnect fails → unauthenticated', () async {
      await openContainer();
      const server = SavedServer(
        id: 1,
        host: 'h',
        port: 52199,
        username: 'u',
        passwordKey: 'k',
        useSsl: false,
        sslPort: 52200,
      );
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => server);
      when(() => repo.getPassword('k')).thenAnswer((_) async => 'pw');
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

      final state = await waitFor((s) => s is Unauthenticated);
      expect(state, isA<Unauthenticated>());
    });
  });

  group('enterOfflineMode', () {
    test(
      'writes the offline zone pref and flips state to authenticated',
      () async {
        await openContainer();
        when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);
        await waitFor((s) => s is Unauthenticated);

        await container.read(sessionProvider.notifier).enterOfflineMode();

        expect(prefs.getString(kActiveZoneGuidKey), 'offline-zone-guid');
        expect(container.read(sessionProvider), isA<Authenticated>());
      },
    );
  });

  group('connect (manual)', () {
    test('returns null and flips to authenticated on success', () async {
      await openContainer();
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);
      await waitFor((s) => s is Unauthenticated);

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

      final error = await container
          .read(sessionProvider.notifier)
          .connect(host: 'h', port: 52199, username: 'u', password: 'p');

      expect(error, isNull);
      expect(container.read(sessionProvider), isA<Authenticated>());
    });

    test(
      'returns the AppException on failure and leaves state unchanged',
      () async {
        await openContainer();
        when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);
        await waitFor((s) => s is Unauthenticated);

        const failure = AppException.unauthorized();
        when(
          () => repo.connect(
            host: any(named: 'host'),
            port: any(named: 'port'),
            username: any(named: 'username'),
            password: any(named: 'password'),
            useSsl: any(named: 'useSsl'),
            sslPort: any(named: 'sslPort'),
          ),
        ).thenAnswer((_) async => left(failure));

        final error = await container
            .read(sessionProvider.notifier)
            .connect(host: 'h', port: 52199, username: 'u', password: 'p');

        expect(error, isA<UnauthorizedException>());
        expect(container.read(sessionProvider), isA<Unauthenticated>());
      },
    );
  });

  group('logout', () {
    test('clears the session and flips state to unauthenticated', () async {
      await openContainer();
      when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);
      await waitFor((s) => s is Unauthenticated);

      when(() => repo.clearSession()).thenAnswer((_) async {});

      await container.read(sessionProvider.notifier).logout();

      verify(() => repo.clearSession()).called(1);
      expect(container.read(sessionProvider), isA<Unauthenticated>());
    });
  });
}
