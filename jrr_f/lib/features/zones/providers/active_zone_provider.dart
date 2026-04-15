import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import 'zone_provider.dart';

part 'active_zone_provider.g.dart';

const kActiveZoneGuidKey = 'active_zone_guid';

@Riverpod(keepAlive: true)
class ActiveZone extends _$ActiveZone {
  @override
  Zone? build() {
    ref.listen<AsyncValue<List<Zone>>>(zoneListProvider, (_, next) {
      if (state != null) return;
      final zones = next.asData?.value;
      if (zones == null || zones.isEmpty) return;
      _restoreZone(zones);
    });
    return null;
  }

  void setZone(Zone zone) {
    state = zone;
    getIt<SharedPreferences>().setString(kActiveZoneGuidKey, zone.guid);
  }

  /// Restores the previously saved zone from [zones], falling back to the
  /// first zone if the saved guid is not found.
  void _restoreZone(List<Zone> zones) {
    final savedGuid = getIt<SharedPreferences>().getString(kActiveZoneGuidKey);
    final zone = savedGuid != null
        ? zones.firstWhere(
            (z) => z.guid == savedGuid,
            orElse: () => zones.first,
          )
        : zones.first;
    setZone(zone);
  }

  void clear() {
    state = null;
    getIt<SharedPreferences>().remove(kActiveZoneGuidKey);
  }
}
