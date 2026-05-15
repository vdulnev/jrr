import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import '../data/repositories/zone_repository.dart';

part 'zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ZoneList extends _$ZoneList {
  @override
  Future<Zones> build() async {
    final session = ref.watch(sessionProvider);
    // Re-fetch whenever the Android Auto session connects/disconnects so
    // the AA zone appears in / disappears from the picker live.
    final isAutoConnected = ref.watch(androidAutoConnectedProvider);

    // In synthetic offline mode (no server info), the address is empty.
    // We skip the repository call as it's already guarded, but this is a
    // secondary guard at the provider level.
    if (session is Authenticated && session.serverInfo.address.isEmpty) {
      final result = await getIt<ZoneRepository>().getZones();
      final rawZones = result.getOrElse((_) => []);
      return Zones(zones: isAutoConnected ? [Zone.androidAuto] : rawZones);
    }

    final result = await getIt<ZoneRepository>().getZones();
    final zones = result.getOrElse(
      (e) => throw e,
    ); // Try to refresh zones when session becomes available.

    return Zones(zones: isAutoConnected ? [Zone.androidAuto] : zones);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final isAutoConnected = ref.read(androidAutoConnectedProvider);
      final result = await getIt<ZoneRepository>().getZones();
      final zones = result.getOrElse((e) => throw e);

      // Re-apply the same strict filtering as in build()
      return Zones(zones: isAutoConnected ? [Zone.androidAuto] : zones);
    });
  }
}
