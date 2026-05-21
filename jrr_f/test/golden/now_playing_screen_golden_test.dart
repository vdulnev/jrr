import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/player/providers/now_playing_view_model.dart';
import 'package:jrr_f/features/player/providers/now_playing_view_state.dart';
import 'package:jrr_f/features/player/widgets/now_playing_screen.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';

class _Session extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}

class _StubVm extends NowPlayingViewModel {
  _StubVm(this._state);
  final NowPlayingViewState _state;
  @override
  NowPlayingViewState build() => _state;
}

const _zone = Zone(id: '0', name: 'Main Listening', guid: 'g', isDLNA: false);

const _track = Track(
  fileKey: 42,
  name: 'Comfortably Numb',
  artist: 'Pink Floyd',
  album: 'The Wall',
  duration: 382.5,
  dateReadable: '1979',
  bitDepth: 24,
  sampleRate: 96000,
  fileType: 'flac',
);

Widget _harness({
  required NowPlayingViewState state,
  Size size = const Size(390, 844),
}) {
  return ProviderScope(
    overrides: [
      sessionProvider.overrideWith(() => _Session()),
      nowPlayingViewModelProvider.overrideWith(() => _StubVm(state)),
    ],
    child: MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(size: size),
        child: const NowPlayingScreen(),
      ),
    ),
  );
}

void main() {
  testWidgets('NowPlayingScreen — playing without artwork', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _harness(
        state: const NowPlayingViewState(
          activeZone: _zone,
          fileKey: 42,
          track: _track,
          name: 'Comfortably Numb',
          artist: 'Pink Floyd',
          album: 'The Wall',
          positionMs: 120000,
          durationMs: 380000,
          volume: 0.65,
          isMuted: false,
          isPlaying: true,
          repeatMode: RepeatMode.off,
          shuffleMode: ShuffleMode.off,
          playingNowPosition: 3,
          playingNowTracks: 11,
          fileType: 'flac',
          bitDepth: 24,
          sampleRate: 96000,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(NowPlayingScreen),
      matchesGoldenFile('goldens/now_playing_playing.png'),
    );
  });

  testWidgets('NowPlayingScreen — paused with shuffle & repeat on', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _harness(
        state: const NowPlayingViewState(
          activeZone: _zone,
          fileKey: 42,
          track: _track,
          name: 'Wish You Were Here',
          artist: 'Pink Floyd',
          album: 'Wish You Were Here',
          positionMs: 30000,
          durationMs: 334000,
          volume: 0.3,
          isMuted: true,
          isPlaying: false,
          repeatMode: RepeatMode.playlist,
          shuffleMode: ShuffleMode.on,
          playingNowPosition: 5,
          playingNowTracks: 5,
          fileType: 'flac',
          bitDepth: 24,
          sampleRate: 96000,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(NowPlayingScreen),
      matchesGoldenFile('goldens/now_playing_paused.png'),
    );
  });

  testWidgets('NowPlayingScreen — empty state (no track loaded)', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _harness(
        state: const NowPlayingViewState(
          activeZone: _zone,
          fileKey: -1,
          track: null,
          name: '',
          artist: '',
          album: '',
          positionMs: 0,
          durationMs: 0,
          volume: 0.5,
          isMuted: false,
          isPlaying: false,
          repeatMode: RepeatMode.off,
          shuffleMode: ShuffleMode.off,
          playingNowPosition: 0,
          playingNowTracks: 0,
          fileType: '',
          bitDepth: 0,
          sampleRate: 0,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(NowPlayingScreen),
      matchesGoldenFile('goldens/now_playing_empty.png'),
    );
  });
}
