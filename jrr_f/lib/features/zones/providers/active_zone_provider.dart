import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import 'zone_provider.dart';

part 'active_zone_provider.g.dart';

const kActiveZoneGuidKey = 'active_zone_guid';

@Riverpod(keepAlive: true)
class ActiveZone extends _$ActiveZone {
  Zone? value;

  @override
  Zone? build() {
    final zones = ref.watch(zoneListProvider).value;
    _restoreZone(zones);
    return value;
  }

  /// Restores the previously saved zone from [zones], falling back to the
  /// first zone if the saved guid is not found.
  void _restoreZone(List<Zone>? zones) {
    getIt<Talker>().debug(
      '[activeZoneProvider] Restoring active zone from SharedPreferences for $zones',
    );
    if (zones == null) return;
    if (zones.isEmpty) {
      clear();
      return;
    }
    final savedGuid = getIt<SharedPreferences>().getString(kActiveZoneGuidKey);
    final zone = savedGuid != null
        ? zones.firstWhere(
            (z) => z.guid == savedGuid,
            orElse: () => zones.first,
          )
        : zones.first;
    if (zone != value) {
      getIt<Talker>().debug(
        '[activeZoneProvider] Restored zone: ${zone.name} (savedGuid: $savedGuid)',
      );
      value = zone; // Ensure the active zone is saved in SharedPreferences.
      state = zone;
      _saveZone(zone);
    }
  }

  void setZone(Zone zone) {
    state = zone;
    _saveZone(zone);
  }

  void _saveZone(Zone zone) {
    getIt<Talker>().debug(
      '[activeZoneProvider] Zone: ${zone.name}, saving to SharedPreferences',
    );
    getIt<SharedPreferences>().setString(kActiveZoneGuidKey, zone.guid);
  }

  void clear() {
    state = null;
    getIt<SharedPreferences>().remove(kActiveZoneGuidKey);
    getIt<Talker>().debug(
      '[activeZoneProvider] Zone is cleared from SharedPreferences',
    );
  }
}
