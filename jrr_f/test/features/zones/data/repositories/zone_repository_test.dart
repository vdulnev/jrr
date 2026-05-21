import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/data/repositories/zone_repository_impl.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/services/android_auto_session_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

class MockMcwsClient extends Mock implements McwsClient {}

class MockConnectionRepository extends Mock implements ConnectionRepository {}

/// Stand-in that exposes [isConnected] without touching MethodChannels.
class FakeAutoSession implements AndroidAutoSessionService {
  @override
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  @override
  void markActive({bool isDirectSignal = false}) => isConnected.value = true;
  @override
  void markInactive() => isConnected.value = false;
  @override
  void dispose() => isConnected.dispose();
}

void main() {
  late MockMcwsClient client;
  late MockConnectionRepository connectionRepo;
  late SharedPreferences prefs;
  late FakeAutoSession autoSession;
  late ZoneRepositoryImpl repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    client = MockMcwsClient();
    connectionRepo = MockConnectionRepository();
    autoSession = FakeAutoSession();
    repo = ZoneRepositoryImpl(
      client: () => client,
      connectionRepository: connectionRepo,
      prefs: prefs,
      autoSession: autoSession,
    );
    // Silence Talker prints leaking from concrete deps if any.
    Talker();
  });

  group('getZones', () {
    test('without a session returns only the offline zone', () async {
      when(() => connectionRepo.currentToken).thenReturn(null);
      final result = await repo.getZones();
      expect(result.getOrElse((_) => []), [Zone.offline]);
    });

    test(
      'when the saved zone is offline returns local + offline only',
      () async {
        when(() => connectionRepo.currentToken).thenReturn('tok');
        await prefs.setString(kActiveZoneGuidKey, 'offline-zone-guid');
        final result = await repo.getZones();
        final zones = result.getOrElse((_) => []);
        expect(zones, [Zone.local, Zone.offline]);
        verifyNever(() => client.getZones());
      },
    );

    test(
      'with a session fetches server zones and appends local/offline',
      () async {
        when(() => connectionRepo.currentToken).thenReturn('tok');
        const remote = Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false);
        when(() => client.getZones()).thenAnswer((_) async => right([remote]));
        final result = await repo.getZones();
        expect(result.getOrElse((_) => []), [remote, Zone.local, Zone.offline]);
      },
    );

    test(
      'falls back to local/offline when the client reports an error',
      () async {
        when(() => connectionRepo.currentToken).thenReturn('tok');
        when(
          () => client.getZones(),
        ).thenAnswer((_) async => left(const AppException.unauthorized()));
        final result = await repo.getZones();
        expect(result.getOrElse((_) => []), [Zone.local, Zone.offline]);
      },
    );

    test('falls back to local/offline when the client throws', () async {
      when(() => connectionRepo.currentToken).thenReturn('tok');
      when(() => client.getZones()).thenThrow(StateError('boom'));
      final result = await repo.getZones();
      expect(result.getOrElse((_) => []), [Zone.local, Zone.offline]);
    });

    test('appends Android Auto when the session is connected', () async {
      when(() => connectionRepo.currentToken).thenReturn(null);
      autoSession.markActive();
      final result = await repo.getZones();
      expect(result.getOrElse((_) => []), [Zone.offline, Zone.androidAuto]);
    });
  });

  group('setActiveZone', () {
    for (final id in ['local', 'offline', 'android-auto']) {
      test('virtual zone "$id" skips the server call', () async {
        final result = await repo.setActiveZone(id);
        expect(result.isRight(), isTrue);
        verifyNever(() => client.setActiveZone(any()));
      });
    }

    test('forwards a real zone id to the client', () async {
      when(
        () => client.setActiveZone('42'),
      ).thenAnswer((_) async => right(unit));
      final result = await repo.setActiveZone('42');
      expect(result.isRight(), isTrue);
      verify(() => client.setActiveZone('42')).called(1);
    });

    test('maps client throw to AppException.unknown', () async {
      when(() => client.setActiveZone('42')).thenThrow(StateError('boom'));
      final result = await repo.setActiveZone('42');
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<UnknownException>()),
        (_) => fail('expected left'),
      );
    });
  });
}
