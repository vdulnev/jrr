import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/shared/widgets/track_row.dart';

import '../setup/test_player.dart';

Widget _harness({required Widget child, double width = 360}) {
  return ProviderScope(
    overrides: [playerProvider.overrideWith(() => TestPlayer())],
    child: MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bg1,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    ),
  );
}

const _track = Track(
  fileKey: 101,
  name: 'Comfortably Numb',
  artist: 'Pink Floyd',
  album: 'The Wall',
  duration: 382.5,
  trackNumber: 6,
  bitrate: 1411,
  bitDepth: 24,
  sampleRate: 96000,
  dateReadable: '1979',
);

void main() {
  testWidgets('TrackRow — collapsed', (tester) async {
    await tester.pumpWidget(
      _harness(child: const TrackRow(track: _track, index: 6)),
    );
    await tester.pump();
    await expectLater(
      find.byType(TrackRow),
      matchesGoldenFile('goldens/track_row_collapsed.png'),
    );
  });

  testWidgets('TrackRow — expanded metadata', (tester) async {
    await tester.pumpWidget(
      _harness(child: const TrackRow(track: _track, index: 6)),
    );
    await tester.tap(find.byType(TrackRow), warnIfMissed: false);
    await tester.pump();
    await expectLater(
      find.byType(TrackRow),
      matchesGoldenFile('goldens/track_row_expanded.png'),
    );
  });

  testWidgets('TrackRow — unknown title falls back', (tester) async {
    const empty = Track(fileKey: 7, name: '', duration: 200);
    await tester.pumpWidget(
      _harness(child: const TrackRow(track: empty, index: 1)),
    );
    await tester.pump();
    await expectLater(
      find.byType(TrackRow),
      matchesGoldenFile('goldens/track_row_unknown.png'),
    );
  });
}
