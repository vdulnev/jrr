import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import '../data/repositories/zone_repository.dart';
import 'active_zone_provider.dart';

part 'zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ZoneList extends _$ZoneList {
  @override
  Future<List<Zone>> build() async {
    final result = await getIt<ZoneRepository>().getZones();
    final zones = result.getOrElse((e) => throw e);

    // Auto-select the first zone if none has been chosen yet.
    if (zones.isNotEmpty && ref.read(activeZoneProvider) == null) {
      Future.microtask(
        () => ref.read(activeZoneProvider.notifier).setZone(zones.first),
      );
    }
    return zones;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await getIt<ZoneRepository>().getZones();
      return result.getOrElse((e) => throw e);
    });
  }
}
