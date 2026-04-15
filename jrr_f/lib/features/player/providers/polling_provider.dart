import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../connection/providers/session_provider.dart';
import '../../connection/providers/session_state.dart';
import '../../zones/providers/zone_provider.dart';
import '../data/models/playback_state.dart';
import 'player_provider.dart';

part 'polling_provider.g.dart';

@Riverpod(keepAlive: true)
class Polling extends _$Polling {
  Timer? _playerTimer;
  Timer? _zoneTimer;

  @override
  void build() {
    ref.onDispose(() {
      _playerTimer?.cancel();
      _zoneTimer?.cancel();
    });

    final session = ref.watch(sessionProvider);
    if (session is Authenticated) {
      _start();
    } else {
      _stop();
    }
  }

  void _start() {
    _playerTimer?.cancel();
    _zoneTimer?.cancel();

    // Kick off an immediate player poll via timer so build() can return first.
    _playerTimer = Timer(Duration.zero, _tickPlayer);

    // Zone list refresh every 30 seconds.
    _zoneTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => ref.read(zoneListProvider.notifier).refresh(),
    );
  }

  void _stop() {
    _playerTimer?.cancel();
    _zoneTimer?.cancel();
  }

  Future<void> _tickPlayer() async {
    if (ref.read(sessionProvider) is! Authenticated) return;
    await ref.read(playerProvider.notifier).refresh();
    _scheduleNextPlayerPoll();
  }

  void _scheduleNextPlayerPoll() {
    _playerTimer?.cancel();
    final interval =
        ref.read(playerProvider).asData?.value.state == PlaybackState.playing
        ? const Duration(seconds: 1)
        : const Duration(seconds: 5);
    _playerTimer = Timer(interval, _tickPlayer);
  }

  void pause() {
    _playerTimer?.cancel();
    _zoneTimer?.cancel();
  }

  void resume() {
    if (ref.read(sessionProvider) is Authenticated) {
      _start();
    }
  }
}
