import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/player/providers/player_polling_provider.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

void main() {
  test('does not throw when zone is virtual or session is unauthenticated', () {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        sessionProvider.overrideWith(() => _UnauthSession()),
        playerProvider.overrideWith(() => TestPlayer()),
        // The polling provider watches isVirtualZoneActiveProvider; force it
        // to true so the polling loop short-circuits to "stop".
        isVirtualZoneActiveProvider.overrideWith((ref) => true),
      ],
    );
    addTearDown(container.dispose);

    container.read(playerPollingProvider);
    // pause/resume are no-ops here but exercise the public surface.
    container.read(playerPollingProvider.notifier).pause();
    container.read(playerPollingProvider.notifier).resume();
  });

  test(
    'starts polling when session is authenticated and zone is remote',
    () async {
      final container = ProviderContainer(
        overrides: [
          talkerProvider.overrideWithValue(Talker()),
          sessionProvider.overrideWith(() => _AuthSession()),
          isVirtualZoneActiveProvider.overrideWith((ref) => false),
          playerProvider.overrideWith(() => TestPlayer()),
        ],
      );
      addTearDown(container.dispose);
      container.read(playerPollingProvider);

      // Let the first scheduled tick fire and call refresh.
      await Future<void>.delayed(const Duration(milliseconds: 30));
      final player = container.read(playerProvider.notifier) as TestPlayer;
      expect(player.calls, contains('refresh'));

      // pause() cancels the timer so no further refresh fires.
      container.read(playerPollingProvider.notifier).pause();
    },
  );
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
