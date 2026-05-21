import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

void main() {
  ProviderContainer open(TestPlayer player) {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        playerProvider.overrideWith(() => player),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('PlayingNowPosition', () {
    test('returns -1 while playerProvider is loading', () {
      final c = open(TestPlayer());
      // No awaiting — playerProvider hasn't settled, so the provider should
      // report -1 via the loading branch.
      expect(c.read(playingNowPositionProvider), -1);
    });

    test('mirrors playingNowPosition once the player resolves', () async {
      final c = open(TestPlayer(status: stoppedStatus(playingNowPosition: 7)));
      await c.read(playerProvider.future);
      expect(c.read(playingNowPositionProvider), 7);
    });

    test('treats a null status as position -1', () async {
      final c = open(TestPlayer());
      await c.read(playerProvider.future);
      expect(c.read(playingNowPositionProvider), -1);
    });
  });
}
