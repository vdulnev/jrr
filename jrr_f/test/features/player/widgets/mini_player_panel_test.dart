import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/player/widgets/mini_player_panel.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup/test_player.dart';

class MockConnectionRepo extends Mock implements ConnectionRepository {}

class _Session extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required TestPlayer player,
    VoidCallback? onItemTap,
  }) async {
    final repo = MockConnectionRepo();
    when(() => repo.currentToken).thenReturn(null);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          playerProvider.overrideWith(() => player),
          sessionProvider.overrideWith(() => _Session()),
          connectionRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          home: Scaffold(body: MiniPlayerPanel(onItemTap: onItemTap)),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows fallback labels and disables transport when no tracks', (
    tester,
  ) async {
    await pump(tester, player: TestPlayer());
    expect(find.text('Unknown Track'), findsOneWidget);
    expect(find.text('Unknown Artist'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });

  testWidgets('reflects an active playing status', (tester) async {
    await pump(
      tester,
      player: TestPlayer(
        status: stoppedStatus(
          state: PlaybackState.playing,
          fileKey: 5,
          name: 'Hello',
          artist: 'World',
          playingNowTracks: 3,
          volume: 0.5,
        ),
      ),
    );
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('World'), findsOneWidget);
    expect(find.byIcon(Icons.pause_rounded), findsOneWidget);
  });

  testWidgets('tapping the panel invokes onItemTap', (tester) async {
    var taps = 0;
    await pump(
      tester,
      player: TestPlayer(status: stoppedStatus(playingNowTracks: 1)),
      onItemTap: () => taps++,
    );
    // Tap somewhere on the cover/text area (not on a transport button).
    await tester.tap(find.text('Unknown Track'));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('next button forwards to player notifier', (tester) async {
    final player = TestPlayer(status: stoppedStatus(playingNowTracks: 1));
    await pump(tester, player: player);
    await tester.tap(find.byIcon(Icons.skip_next_rounded));
    await tester.pumpAndSettle();
    expect(player.calls, ['next']);
  });
}
