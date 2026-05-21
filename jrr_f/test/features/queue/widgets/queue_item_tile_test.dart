import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/queue/data/repositories/queue_repository.dart';
import 'package:jrr_f/features/queue/widgets/queue_item_tile.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:mocktail/mocktail.dart';

import '../../../setup/test_player.dart';

class MockQueueRepo extends Mock implements QueueRepository {}

class _Active extends ActiveZone {
  _Active(this._zone);
  final Zone? _zone;
  @override
  Zone? build() => _zone;
}

void main() {
  late MockQueueRepo repo;

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    required Track item,
    required int index,
    bool isPlaying = false,
  }) async {
    repo = MockQueueRepo();
    when(
      () => repo.getQueue(any()),
    ).thenAnswer((_) async => right(Tracks.fromList([item])));
    when(
      () => repo.removeItem(any(), any()),
    ).thenAnswer((_) async => right(unit));

    const remote = Zone(id: '0', name: 'P', guid: 'g', isDLNA: false);
    final container = ProviderContainer(
      overrides: [
        queueRepositoryProvider.overrideWithValue(repo),
        playerProvider.overrideWith(() => TestPlayer()),
        activeZoneProvider.overrideWith(() => _Active(remote)),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: QueueItemTile(item: item, index: index, isPlaying: isPlaying),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('renders 1-based index when not playing', (tester) async {
    await pump(tester, item: const Track(fileKey: 1, name: 'Song'), index: 2);
    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(Icons.volume_up), findsNothing);
  });

  testWidgets('shows speaker icon when isPlaying', (tester) async {
    await pump(
      tester,
      item: const Track(fileKey: 1, name: 'Song'),
      index: 0,
      isPlaying: true,
    );
    expect(find.byIcon(Icons.volume_up), findsOneWidget);
  });

  testWidgets('falls back to "Unknown" when name is empty', (tester) async {
    await pump(tester, item: const Track(fileKey: 1), index: 0);
    expect(find.text('Unknown'), findsOneWidget);
  });

  testWidgets('tapping the tile calls playByIndex on the player notifier', (
    tester,
  ) async {
    final container = await pump(
      tester,
      item: const Track(fileKey: 1, name: 'Song'),
      index: 3,
    );
    await tester.tap(find.byType(ListTile));
    await tester.pumpAndSettle();
    final player = container.read(playerProvider.notifier) as TestPlayer;
    expect(player.calls, ['playByIndex:3']);
  });

  testWidgets('swipe-to-dismiss calls removeItem on the queue notifier', (
    tester,
  ) async {
    await pump(tester, item: const Track(fileKey: 1, name: 'Song'), index: 2);
    await tester.fling(find.byType(Dismissible), const Offset(-500, 0), 1000);
    await tester.pumpAndSettle();
    verify(() => repo.removeItem('0', 2)).called(1);
  });
}
