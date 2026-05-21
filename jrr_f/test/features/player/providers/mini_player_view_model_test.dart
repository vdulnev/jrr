import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/providers/mini_player_view_model.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';

import '../../../setup/test_player.dart';

void main() {
  TestPlayer last(ProviderContainer c) =>
      c.read(playerProvider.notifier) as TestPlayer;

  ProviderContainer open(TestPlayer player) {
    final container = ProviderContainer(
      overrides: [playerProvider.overrideWith(() => player)],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('build()', () {
    test('falls back to defaults when no status is available', () async {
      final c = open(TestPlayer());
      // Force the build to settle before reading state.
      await c.read(playerProvider.future);
      final s = c.read(miniPlayerViewModelProvider);
      expect(s.fileKey, isNull);
      expect(s.name, 'Unknown Track');
      expect(s.artist, 'Unknown Artist');
      expect(s.volume, 1.0);
      expect(s.isMuted, isFalse);
      expect(s.isPlaying, isFalse);
      expect(s.progress, 0.0);
      expect(s.hasTracks, isFalse);
    });

    test('reflects an active playing status', () async {
      final status = stoppedStatus(
        state: PlaybackState.playing,
        fileKey: 42,
        name: 'Hello',
        artist: 'World',
        positionMs: 50_000,
        durationMs: 200_000,
        volume: 0.6,
        playingNowTracks: 3,
      );
      final c = open(TestPlayer(status: status));
      await c.read(playerProvider.future);
      final s = c.read(miniPlayerViewModelProvider);
      expect(s.fileKey, 42);
      expect(s.name, 'Hello');
      expect(s.artist, 'World');
      expect(s.isPlaying, isTrue);
      expect(s.progress, 0.25);
      expect(s.hasTracks, isTrue);
      expect(s.volume, 0.6);
    });

    test('clamps progress to [0, 1] when position exceeds duration', () async {
      final status = stoppedStatus(positionMs: 500, durationMs: 100);
      final c = open(TestPlayer(status: status));
      await c.read(playerProvider.future);
      final s = c.read(miniPlayerViewModelProvider);
      expect(s.progress, 1.0);
    });

    test('reports 0 progress when duration is 0', () async {
      final status = stoppedStatus(positionMs: 100, durationMs: 0);
      final c = open(TestPlayer(status: status));
      await c.read(playerProvider.future);
      final s = c.read(miniPlayerViewModelProvider);
      expect(s.progress, 0.0);
    });
  });

  group('action delegation', () {
    test('every command forwards to the playerProvider notifier', () async {
      final c = open(TestPlayer());
      await c.read(playerProvider.future);
      final vm = c.read(miniPlayerViewModelProvider.notifier);

      vm.playPause();
      vm.next();
      vm.previous();
      vm.setVolume(0.4);
      vm.toggleMute();

      expect(last(c).calls, [
        'playPause',
        'next',
        'previous',
        'setVolume:0.4',
        'toggleMute',
      ]);
    });
  });
}
