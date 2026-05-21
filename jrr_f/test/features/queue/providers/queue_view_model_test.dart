import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/queue/providers/queue_provider.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/queue/providers/queue_view_model.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

void main() {
  ProviderContainer open({
    AsyncValue<Tracks> queue = const AsyncValue.loading(),
    int currentIndex = -1,
  }) {
    final container = ProviderContainer(
      overrides: [
        talkerProvider.overrideWithValue(Talker()),
        queueProvider.overrideWith(() => _StaticQueue(queue)),
        playerProvider.overrideWith(
          () => TestPlayer(
            status: stoppedStatus(playingNowPosition: currentIndex),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('exposes tracks, error, currentIndex from upstream providers', () async {
    final c = open(
      queue: AsyncValue.data(Tracks.fromList(const [Track(fileKey: 1)])),
      currentIndex: 7,
    );
    // Listen to keep the view model alive while playerProvider settles.
    final sub = c.listen(queueViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    await c.read(playerProvider.future);
    final state = c.read(queueViewModelProvider);
    expect(state.tracks?.length, 1);
    expect(state.error, isNull);
    expect(state.currentIndex, 7);
    expect(state.isLoading, isFalse);
    expect(state.hasError, isFalse);
  });

  test('isLoading is true while the queue is loading', () {
    final c = open();
    final state = c.read(queueViewModelProvider);
    expect(state.isLoading, isTrue);
  });

  test('surfaces queue errors via QueueViewState.error', () async {
    final c = open(
      queue: const AsyncValue<Tracks>.error(
        AppException.unauthorized(),
        StackTrace.empty,
      ),
    );
    final sub = c.listen(queueViewModelProvider, (_, _) {});
    addTearDown(sub.close);
    for (var i = 0; i < 20; i++) {
      if (c.read(queueViewModelProvider).error != null) break;
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
    final state = c.read(queueViewModelProvider);
    expect(state.hasError, isTrue);
    expect(state.appException, isA<UnauthorizedException>());
  });

  test('playByIndex forwards to playerProvider notifier', () async {
    final c = open();
    c.read(queueViewModelProvider.notifier).playByIndex(4);
    final player = c.read(playerProvider.notifier) as TestPlayer;
    expect(player.calls, ['playByIndex:4']);
  });
}

class _StaticQueue extends Queue {
  _StaticQueue(this._value);
  final AsyncValue<Tracks> _value;
  @override
  Future<Tracks> build() async {
    return _value.maybeWhen(
      data: (t) => t,
      orElse: () => throw _value.error ?? StateError('loading'),
    );
  }
}
