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
import 'package:jrr_f/features/connection/providers/server_setup_view_model.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MockConnectionRepo extends Mock implements ConnectionRepository {}

class MockClientNotifier extends ValueNotifier<McwsClient?> {
  MockClientNotifier() : super(null);
}

const _serverRow = SavedServer(
  id: 1,
  host: 'h',
  port: 52199,
  username: 'u',
  passwordKey: 'k',
  friendlyName: 'Home',
  lastUsedAt: 200,
  useSsl: false,
  sslPort: 52200,
);

void main() {
  late MockConnectionRepo repo;
  late ProviderContainer container;
  late SharedPreferences prefs;

  Future<void> openContainer({SavedServer? saved, String? password}) async {
    repo = MockConnectionRepo();
    when(() => repo.clientListenable).thenReturn(MockClientNotifier());
    when(
      () => repo.getSavedServers(),
    ).thenAnswer((_) async => saved == null ? <SavedServer>[] : [saved]);
    when(() => repo.getPassword(any())).thenAnswer((_) async => password);
    when(() => repo.getLastServerWithToken()).thenAnswer((_) async => null);

    SharedPreferences.setMockInitialValues({});
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

  test('isConnecting flips while the form provider is loading', () async {
    await openContainer();
    // Keep the upstream providers alive across the connect call.
    final keepAlive = container.listen(serverSetupViewModelProvider, (_, _) {});
    addTearDown(keepAlive.close);
    final sessionSub = container.listen(sessionProvider, (_, _) {});
    addTearDown(sessionSub.close);
    final completer = Completer<Either<AppException, ServerInfo>>();
    when(
      () => repo.connect(
        host: any(named: 'host'),
        port: any(named: 'port'),
        username: any(named: 'username'),
        password: any(named: 'password'),
        useSsl: any(named: 'useSsl'),
        sslPort: any(named: 'sslPort'),
      ),
    ).thenAnswer((_) => completer.future);

    expect(container.read(serverSetupViewModelProvider).isConnecting, isFalse);

    final future = container
        .read(serverSetupViewModelProvider.notifier)
        .connectWithHost(host: 'h', port: 52199, username: 'u', password: 'p');

    await Future<void>.delayed(Duration.zero);
    expect(container.read(serverSetupViewModelProvider).isConnecting, isTrue);

    completer.complete(left(const AppException.unauthorized()));
    await future;
    final state = container.read(serverSetupViewModelProvider);
    expect(state.isConnecting, isFalse);
    expect(state.connectError, isA<UnauthorizedException>());
  });

  test('prefill is populated from lastServerProvider when present', () async {
    await openContainer(saved: _serverRow, password: 'pw');
    final sub = container.listen(serverSetupViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    // sessionProvider is async-notifier; keep it pinned so the fire-and-
    // forget silent reconnect can finish before any other call into it.
    final sessionSub = container.listen(sessionProvider, (_, _) {});
    addTearDown(sessionSub.close);
    for (var i = 0; i < 20; i++) {
      final state = container.read(serverSetupViewModelProvider);
      if (state.prefill != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    final state = container.read(serverSetupViewModelProvider);
    expect(state.prefill, isNotNull);
    expect(state.prefill!.host, 'h');
    expect(state.prefill!.username, 'u');
    expect(state.prefill!.password, 'pw');
  });

  test('enterOfflineMode delegates to the session notifier', () async {
    await openContainer();
    final sub = container.listen(serverSetupViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    // sessionProvider is async-notifier; keep it pinned so the fire-and-
    // forget silent reconnect can finish before any other call into it.
    final sessionSub = container.listen(sessionProvider, (_, _) {});
    addTearDown(sessionSub.close);
    await container
        .read(serverSetupViewModelProvider.notifier)
        .enterOfflineMode();
    expect(prefs.getString('active_zone_guid'), 'offline-zone-guid');
  });
}
