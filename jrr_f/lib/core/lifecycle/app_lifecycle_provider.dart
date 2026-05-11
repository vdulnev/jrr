import 'package:flutter/widgets.dart';
import 'package:jrr_f/features/player/providers/player_polling_provider.dart';
import 'package:jrr_f/features/zones/providers/zone_polling_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_lifecycle_provider.g.dart';

@Riverpod(keepAlive: true)
void appLifecycle(Ref ref) {
  final listener = AppLifecycleListener(
    onPause: () {
      ref.read(playerPollingProvider.notifier).pause();
      ref.read(zonePollingProvider.notifier).pause();
    },
    onResume: () {
      ref.read(playerPollingProvider.notifier).resume();
      ref.read(zonePollingProvider.notifier).resume();
    },
  );

  ref.onDispose(listener.dispose);
}
