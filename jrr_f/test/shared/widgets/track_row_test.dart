import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/shared/widgets/track_row.dart';

import '../../setup/test_player.dart';

void main() {
  Future<void> pump(WidgetTester tester, Track track, {int index = 1}) =>
      tester.pumpWidget(
        ProviderScope(
          overrides: [playerProvider.overrideWith(() => TestPlayer())],
          child: MaterialApp(
            home: Scaffold(
              body: TrackRow(track: track, index: index),
            ),
          ),
        ),
      );

  testWidgets('renders track name and formatted duration', (tester) async {
    await pump(tester, const Track(fileKey: 1, name: 'Hello', duration: 125));
    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('2:05'), findsOneWidget);
  });

  testWidgets('renders index and falls back to "Unknown" for empty name', (
    tester,
  ) async {
    await pump(tester, const Track(fileKey: 1), index: 7);
    expect(find.text('7'), findsOneWidget);
    expect(find.text('Unknown'), findsOneWidget);
  });

  testWidgets('tapping the row expands metadata', (tester) async {
    await pump(
      tester,
      const Track(
        fileKey: 1,
        name: 'Song',
        artist: 'Artist',
        album: 'Album',
        dateReadable: '2020',
        duration: 10,
      ),
    );
    expect(find.textContaining('Artist'), findsNothing);
    await tester.tap(find.text('Song'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Artist'), findsOneWidget);
  });

  testWidgets('popup-menu Play forwards playNow to the player notifier', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [playerProvider.overrideWith(() => TestPlayer())],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: TrackRow(
              track: Track(fileKey: 9, name: 'S', duration: 10),
              index: 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    final player = container.read(playerProvider.notifier) as TestPlayer;
    expect(player.calls, ['playNow:1']);
  });
}
