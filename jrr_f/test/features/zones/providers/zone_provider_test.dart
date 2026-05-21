import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/repositories/zone_repository.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_provider.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockZoneRepo extends Mock implements ZoneRepository {}

void main() {
  late MockZoneRepo zoneRepo;

  ProviderContainer open({
    SessionState session = const SessionState.unauthenticated(),
    bool androidAutoConnected = false,
  }) {
    zoneRepo = MockZoneRepo();
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        zoneRepositoryProvider.overrideWithValue(zoneRepo),
        sessionProvider.overrideWith(() => _StaticSession(session)),
        androidAutoConnectedProvider.overrideWith(
          () => _StaticAndroidAuto(androidAutoConnected),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'returns repository zones when session authenticated & AA disconnected',
    () async {
      const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
      final container = open(
        session: const SessionState.authenticated(
          serverInfo: ServerInfo(
            id: 'a',
            name: 'A',
            version: 'v',
            platform: 'p',
            address: 'http://h',
          ),
        ),
      );
      when(() => zoneRepo.getZones()).thenAnswer((_) async => right([zone]));

      final result = await container.read(zoneListProvider.future);
      expect(result.zones, [zone]);
    },
  );

  test('replaces zones with [AndroidAuto] when AA is connected', () async {
    const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
    final container = open(
      session: const SessionState.authenticated(
        serverInfo: ServerInfo(
          id: 'a',
          name: 'A',
          version: 'v',
          platform: 'p',
          address: 'http://h',
        ),
      ),
      androidAutoConnected: true,
    );
    when(() => zoneRepo.getZones()).thenAnswer((_) async => right([zone]));

    final result = await container.read(zoneListProvider.future);
    expect(result.zones, [Zone.androidAuto]);
  });

  test(
    'handles synthetic-offline auth (empty address) without throwing',
    () async {
      final container = open(
        session: const SessionState.authenticated(
          serverInfo: ServerInfo(
            id: 'offline',
            name: 'Offline',
            version: '',
            platform: '',
            address: '',
          ),
        ),
      );
      when(() => zoneRepo.getZones()).thenAnswer((_) async => right(const []));

      final result = await container.read(zoneListProvider.future);
      expect(result.zones, isEmpty);
    },
  );

  test('refresh() re-fetches zones', () async {
    const zone = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
    final container = open(
      session: const SessionState.authenticated(
        serverInfo: ServerInfo(
          id: 'a',
          name: 'A',
          version: 'v',
          platform: 'p',
          address: 'http://h',
        ),
      ),
    );
    when(() => zoneRepo.getZones()).thenAnswer((_) async => right([zone]));
    await container.read(zoneListProvider.future);

    await container.read(zoneListProvider.notifier).refresh();
    verify(() => zoneRepo.getZones()).called(2);
  });

  test('propagates repository errors as AsyncError', () async {
    final container = open(
      session: const SessionState.authenticated(
        serverInfo: ServerInfo(
          id: 'a',
          name: 'A',
          version: 'v',
          platform: 'p',
          address: 'http://h',
        ),
      ),
    );
    when(
      () => zoneRepo.getZones(),
    ).thenAnswer((_) async => left(const AppException.unauthorized()));

    final emissions = <AsyncValue<dynamic>>[];
    final sub = container.listen(
      zoneListProvider,
      (_, next) => emissions.add(next),
      fireImmediately: true,
    );
    addTearDown(sub.close);

    for (var i = 0; i < 20; i++) {
      if (emissions.any((e) => e.hasError)) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    expect(emissions.last.hasError, isTrue);
    expect(emissions.last.error, isA<UnauthorizedException>());
  });
}

class _StaticSession extends Session {
  _StaticSession(this._state);
  final SessionState _state;
  @override
  SessionState build() => _state;
}

class _StaticAndroidAuto extends AndroidAutoConnected {
  _StaticAndroidAuto(this._value);
  final bool _value;
  @override
  bool build() => _value;
}
