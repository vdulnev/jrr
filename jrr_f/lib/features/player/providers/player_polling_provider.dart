import 'dart:async';

import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../connection/providers/session_provider.dart';
import '../../connection/providers/session_state.dart';
import '../data/models/playback_state.dart';
import 'player_provider.dart';

part 'player_polling_provider.g.dart';

@Riverpod(keepAlive: true)
class PlayerPolling extends _$PlayerPolling {
  Timer? _timer;

  Talker get _talker => getIt<Talker>();

  @override
  void build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final session = ref.watch(sessionProvider);
    final activeZone = ref.watch(activeZoneProvider);

    if (session is Authenticated && !(activeZone?.isLocal == true)) {
      _talker.debug(
        '[PlayerPolling] Session authenticated & zone is remote — starting player polling',
      );
      _start();
    } else {
      _talker.debug(
        '[PlayerPolling] Session unauthenticated or zone is local — stopping player polling',
      );
      _stop();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer(Duration.zero, _tick);
  }

  void _stop() {
    _timer?.cancel();
  }

  Future<void> _tick() async {
    if (ref.read(sessionProvider) is! Authenticated) return;
    await ref.read(playerProvider.notifier).refresh();

    // Log if the last refresh produced an error.
    final playerState = ref.read(playerProvider);
    if (playerState is AsyncError) {
      _talker.warning(
        '[PlayerPolling] Player refresh error',
        playerState.error,
        playerState.stackTrace,
      );
    }

    _scheduleNext();
  }

  void _scheduleNext() {
    _timer?.cancel();
    final interval =
        ref.read(playerProvider).asData?.value?.state == PlaybackState.playing
        ? const Duration(seconds: 1)
        : const Duration(seconds: 5);
    _timer = Timer(interval, _tick);
  }

  void pause() {
    _talker.debug('[PlayerPolling] Paused');
    _timer?.cancel();
  }

  void resume() {
    if (ref.read(sessionProvider) is Authenticated) {
      _talker.debug('[PlayerPolling] Resumed');
      _start();
    }
  }
}
