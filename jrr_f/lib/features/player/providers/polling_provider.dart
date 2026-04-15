import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
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

  Talker get _talker => getIt<Talker>();

  @override
  void build() {
    ref.onDispose(() {
      _playerTimer?.cancel();
      _zoneTimer?.cancel();
    });

    final session = ref.watch(sessionProvider);
    if (session is Authenticated) {
      _talker.debug('[Polling] Session authenticated — starting polling');
      _start();
    } else {
      _talker.debug('[Polling] Session unauthenticated — stopping polling');
      _stop();
    }
  }

  void _start() {
    _playerTimer?.cancel();
    _zoneTimer?.cancel();

    _playerTimer = Timer(Duration.zero, _tickPlayer);

    _zoneTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _talker.debug('[Polling] Refreshing zone list');
      ref.read(zoneListProvider.notifier).refresh();
    });
  }

  void _stop() {
    _playerTimer?.cancel();
    _zoneTimer?.cancel();
  }

  Future<void> _tickPlayer() async {
    if (ref.read(sessionProvider) is! Authenticated) return;
    await ref.read(playerProvider.notifier).refresh();

    // Log if the last refresh produced an error.
    final playerState = ref.read(playerProvider);
    if (playerState is AsyncError) {
      _talker.warning(
        '[Polling] Player refresh error',
        playerState.error,
        playerState.stackTrace,
      );
    }

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
    _talker.debug('[Polling] Paused');
    _playerTimer?.cancel();
    _zoneTimer?.cancel();
  }

  void resume() {
    if (ref.read(sessionProvider) is Authenticated) {
      _talker.debug('[Polling] Resumed');
      _start();
    }
  }
}
