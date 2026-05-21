import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_polling_provider.dart';
import 'package:talker/talker.dart';

void main() {
  test('does nothing when session is unauthenticated', () {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        sessionProvider.overrideWith(() => _UnauthSession()),
        activeZoneProvider.overrideWith(() => _Active(null)),
      ],
    );
    addTearDown(container.dispose);
    container.read(zonePollingProvider);
    container.read(zonePollingProvider.notifier).pause();
    container.read(zonePollingProvider.notifier).resume();
  });

  test('does nothing for the Offline zone even when authenticated', () {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        sessionProvider.overrideWith(() => _AuthSession()),
        activeZoneProvider.overrideWith(() => _Active(Zone.offline)),
      ],
    );
    addTearDown(container.dispose);
    container.read(zonePollingProvider);
  });

  test('starts polling when authenticated on a remote zone', () {
    const zone = Zone(id: '0', name: 'Player', guid: 'g', isDLNA: false);
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        sessionProvider.overrideWith(() => _AuthSession()),
        activeZoneProvider.overrideWith(() => _Active(zone)),
      ],
    );
    addTearDown(container.dispose);
    container.read(zonePollingProvider);
    container.read(zonePollingProvider.notifier).pause();
    container.read(zonePollingProvider.notifier).resume();
  });
}

class _UnauthSession extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}

class _AuthSession extends Session {
  @override
  SessionState build() =>
      const SessionState.authenticated(serverInfo: ServerInfo.offline);
}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}
