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

const _track = Track(
  fileKey: 42,
  name: 'Wish You Were Here',
  artist: 'Pink Floyd',
  album: 'Wish You Were Here',
  duration: 334,
);

Widget _harness({required Widget child, double width = 360}) {
  final repo = _MockQueueRepo();
  when(
    () => repo.getQueue(any()),
  ).thenAnswer((_) async => right(Tracks.fromList([_track])));
  return ProviderScope(
    overrides: [
      queueRepositoryProvider.overrideWithValue(repo),
      playerProvider.overrideWith(() => TestPlayer()),
      activeZoneProvider.overrideWith(
        () => _Active(const Zone(id: '0', name: 'P', guid: 'g', isDLNA: false)),
      ),
    ],
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

void main() {
  testWidgets('QueueItemTile — queued (not playing)', (tester) async {
    await tester.pumpWidget(
      _harness(
        child: const QueueItemTile(item: _track, index: 3, isPlaying: false),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(QueueItemTile),
      matchesGoldenFile('goldens/queue_item_queued.png'),
    );
  });

  testWidgets('QueueItemTile — playing indicator', (tester) async {
    await tester.pumpWidget(
      _harness(
        child: const QueueItemTile(item: _track, index: 0, isPlaying: true),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(QueueItemTile),
      matchesGoldenFile('goldens/queue_item_playing.png'),
    );
  });

  testWidgets('QueueItemTile — unknown name fallback', (tester) async {
    await tester.pumpWidget(
      _harness(
        child: const QueueItemTile(
          item: Track(fileKey: 9, name: '', artist: '', album: ''),
          index: 5,
          isPlaying: false,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(QueueItemTile),
      matchesGoldenFile('goldens/queue_item_unknown.png'),
    );
  });
}
