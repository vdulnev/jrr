import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/repositories/zone_repository.dart';

part 'zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ZoneList extends _$ZoneList {
  @override
  Future<Zones> build() async {
    final session = ref.watch(sessionProvider);
    if (session is Authenticated) {
      final result = await getIt<ZoneRepository>().getZones();
      final zones = result.getOrElse(
        (e) => throw e,
      ); // Try to refresh zones when session becomes available.
      return Zones(zones: zones);
    } else {
      // If session is not authenticated, clear the zones list.
      return const Zones(zones: []);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await getIt<ZoneRepository>().getZones();
      final zones = result.getOrElse((e) => throw e);
      return Zones(zones: zones);
    });
  }
}
