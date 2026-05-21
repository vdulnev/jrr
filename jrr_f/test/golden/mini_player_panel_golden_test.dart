import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/player/widgets/mini_player_panel.dart';
import 'package:mocktail/mocktail.dart';

import '../setup/test_player.dart';

class _MockConnectionRepo extends Mock implements ConnectionRepository {}

class _Session extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}

Widget _harness({required TestPlayer player, double width = 380}) {
  final repo = _MockConnectionRepo();
  when(() => repo.currentToken).thenReturn(null);
  return ProviderScope(
    overrides: [
      playerProvider.overrideWith(() => player),
      sessionProvider.overrideWith(() => _Session()),
      connectionRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bg1,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(width: width, child: const MiniPlayerPanel()),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('MiniPlayerPanel — empty (no tracks loaded)', (tester) async {
    await tester.pumpWidget(_harness(player: TestPlayer()));
    await tester.pump();
    await expectLater(
      find.byType(MiniPlayerPanel),
      matchesGoldenFile('goldens/mini_player_empty.png'),
    );
  });

  testWidgets('MiniPlayerPanel — playing', (tester) async {
    await tester.pumpWidget(
      _harness(
        player: TestPlayer(
          status: stoppedStatus(
            state: PlaybackState.playing,
            fileKey: 5,
            name: 'Comfortably Numb',
            artist: 'Pink Floyd',
            volume: 0.6,
            positionMs: 60000,
            durationMs: 240000,
            playingNowTracks: 8,
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MiniPlayerPanel),
      matchesGoldenFile('goldens/mini_player_playing.png'),
    );
  });

  testWidgets('MiniPlayerPanel — paused with muted volume', (tester) async {
    await tester.pumpWidget(
      _harness(
        player: TestPlayer(
          status: stoppedStatus(
            state: PlaybackState.paused,
            fileKey: 5,
            name: 'Wish You Were Here',
            artist: 'Pink Floyd',
            volume: 0.3,
            isMuted: true,
            positionMs: 30000,
            durationMs: 200000,
            playingNowTracks: 3,
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(MiniPlayerPanel),
      matchesGoldenFile('goldens/mini_player_paused_muted.png'),
    );
  });
}
