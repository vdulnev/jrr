import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/queue/data/repositories/queue_repository.dart';
import 'package:jrr_f/features/queue/providers/queue_provider.dart';
import 'package:jrr_f/features/queue/widgets/queue_item_tile.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../setup/test_player.dart';

class _MockQueueRepo extends Mock implements QueueRepository {}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}

const _zone = Zone(id: '7', name: 'Living Room', guid: 'z7', isDLNA: false);

const _t0 = Track(
  fileKey: 1,
  name: 'Track One',
  artist: 'Artist A',
  album: 'Album X',
  duration: 200,
);
const _t1 = Track(
  fileKey: 2,
  name: 'Track Two',
  artist: 'Artist B',
  album: 'Album X',
  duration: 220,
);
const _t2 = Track(
  fileKey: 3,
  name: 'Track Three',
  artist: 'Artist B',
  album: 'Album Y',
  duration: 180,
);

/// Composes a small "queue list" view from QueueItemTile widgets so we can
/// drive the user journey without bringing in ScrollChromeListener (which
/// has a known dispose-after-teardown issue tracked elsewhere).
class _QueueList extends ConsumerWidget {
  const _QueueList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracks = ref.watch(queueProvider).value?.tracks ?? const <Track>[];
    return Scaffold(
      backgroundColor: AppColors.bg1,
      body: SafeArea(
        child: ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (_, i) =>
              QueueItemTile(item: tracks[i], index: i, isPlaying: i == 0),
        ),
      ),
    );
  }
}

void main() {
  late _MockQueueRepo repo;
  late TestPlayer player;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required List<Track> initial,
  }) async {
    repo = _MockQueueRepo();
    when(
      () => repo.getQueue(any()),
    ).thenAnswer((_) async => right(Tracks.fromList(initial)));
    when(
      () => repo.removeItem(any(), any()),
    ).thenAnswer((_) async => right(unit));

    player = TestPlayer();
    final container = ProviderContainer(
      overrides: [
        queueRepositoryProvider.overrideWithValue(repo),
        playerProvider.overrideWith(() => player),
        activeZoneProvider.overrideWith(() => _Active(_zone)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: buildAppTheme(), home: const _QueueList()),
      ),
    );
    // Resolve the Queue.build() future and paint.
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('queue journey: render → tap to play → swipe to remove', (
    tester,
  ) async {
    final container = await pump(tester, initial: [_t0, _t1, _t2]);

    // All three rows are visible.
    expect(find.text('Track One'), findsOneWidget);
    expect(find.text('Track Two'), findsOneWidget);
    expect(find.text('Track Three'), findsOneWidget);

    // Row 0 is the playing one and renders the volume_up indicator.
    expect(find.byIcon(Icons.volume_up), findsOneWidget);

    // Tap Track Two — should dispatch playByIndex(1) to the player notifier.
    await tester.tap(find.text('Track Two'));
    await tester.pumpAndSettle();
    expect(player.calls, contains('playByIndex:1'));

    // Swipe Track Three to dismiss (remove from queue).
    await tester.fling(find.text('Track Three'), const Offset(-500, 0), 1000);
    await tester.pumpAndSettle();

    // QueueProvider.removeItem reaches the repo with the right index.
    verify(() => repo.removeItem(_zone.id, 2)).called(1);

    // Container is still usable — no provider teardown errors.
    expect(container.read(queueProvider).hasError, isFalse);
  });

  testWidgets('queue journey: empty queue renders no tiles', (tester) async {
    await pump(tester, initial: const []);
    expect(find.byType(QueueItemTile), findsNothing);
  });

  testWidgets(
    'queue journey: tap on a non-playing item still dispatches playByIndex',
    (tester) async {
      await pump(tester, initial: [_t0, _t1]);

      // Verify the second tile is not marked as playing (uses Text "2" lead).
      expect(find.text('2'), findsOneWidget);

      await tester.tap(find.text('Track Two'));
      await tester.pumpAndSettle();
      expect(player.calls.last, 'playByIndex:1');
    },
  );
}
