import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../connection/providers/session_provider.dart';
import '../../connection/providers/session_state.dart';
import 'zone_provider.dart';

part 'zone_polling_provider.g.dart';

@Riverpod(keepAlive: true)
class ZonePolling extends _$ZonePolling {
  Timer? _timer;

  Talker get _talker => getIt<Talker>();

  @override
  void build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final session = ref.watch(sessionProvider);
    if (session is Authenticated) {
      _talker.debug(
        '[ZonePolling] Session authenticated — starting zone polling',
      );
      _start();
    } else {
      _talker.debug(
        '[ZonePolling] Session unauthenticated — stopping zone polling',
      );
      _stop();
    }
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _talker.debug('[ZonePolling] Refreshing zone list');
      ref.read(zoneListProvider.notifier).refresh();
    });
  }

  void _stop() {
    _timer?.cancel();
  }

  void pause() {
    _talker.debug('[ZonePolling] Paused');
    _timer?.cancel();
  }

  void resume() {
    if (ref.read(sessionProvider) is Authenticated) {
      _talker.debug('[ZonePolling] Resumed');
      _start();
    }
  }
}
