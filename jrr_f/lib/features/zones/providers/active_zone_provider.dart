import 'package:jrr_f/features/zones/data/models/zones.dart';
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
  @override
  Zone? build() {
    ref.listen(zoneListProvider, (previous, next) {
      getIt<Talker>().debug(
        '[activeZoneProvider] zoneListProvider changed: previous=$previous, next=$next',
      );
      if (next case AsyncData(:final value)) {
        final prevValue = switch (previous) {
          AsyncData(:final value) => value,
          AsyncLoading(:final value) => value,
          _ => null,
        };
        getIt<Talker>().debug(
          '[activeZoneProvider] zoneListProvider changed: prevValue=$prevValue, newValue=$value',
        );
        if (prevValue != value) {
          _restoreZone(value);
        } else {
          getIt<Talker>().debug(
            '[activeZoneProvider] zoneListProvider changed but zones are the same, not restoring',
          );
        }
      }
    });
    return null;
  }

  /// Restores the previously saved zone from [zones], falling back to the
  /// first zone if the saved guid is not found.
  void _restoreZone(Zones? zones) {
    getIt<Talker>().debug(
      '[activeZoneProvider] Restoring active zone from SharedPreferences for $zones',
    );
    if (zones == null) return;
    if (zones.zones.isEmpty) {
      clear();
      return;
    }
    final savedGuid = getIt<SharedPreferences>().getString(kActiveZoneGuidKey);
    final zone = savedGuid != null
        ? zones.zones.firstWhere(
            (z) => z.guid == savedGuid,
            orElse: () => zones.zones.first,
          )
        : zones.zones.first;
    getIt<Talker>().debug(
      '[activeZoneProvider] Restored zone: ${zone.name} (savedGuid: $savedGuid)',
    );
    state = zone;
    _saveZone(zone);
  }

  void setZone(Zone zone) {
    // Refresh the zone list when leaving a virtual zone that runs without a
    // live server (Offline / Android Auto) — they suppress MCWS calls, so we
    // need a fresh server-side zone list once they're deactivated.
    final wasServerless =
        state?.isOffline == true || state?.isAndroidAuto == true;
    final isServerless = zone.isOffline || zone.isAndroidAuto;
    state = zone;
    _saveZone(zone);
    if (wasServerless && !isServerless) {
      ref.read(zoneListProvider.notifier).refresh();
    }
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

@riverpod
bool isOfflineActive(Ref ref) {
  final zone = ref.watch(activeZoneProvider);
  return zone?.isOffline == true;
}

@riverpod
bool isAndroidAutoActive(Ref ref) {
  final zone = ref.watch(activeZoneProvider);
  return zone?.isAndroidAuto == true;
}

/// True when the active zone uses downloaded files for library browsing
/// (Offline or Android Auto). Live MCWS library calls should be skipped.
@riverpod
bool isOfflineLikeActive(Ref ref) {
  final zone = ref.watch(activeZoneProvider);
  return zone?.isOffline == true || zone?.isAndroidAuto == true;
}

/// True when the active zone is a virtual (non-MCWS) zone — Local, Offline,
/// or Android Auto. Used to skip server-side zone polling and routing.
@riverpod
bool isVirtualZoneActive(Ref ref) {
  final zone = ref.watch(activeZoneProvider);
  return zone?.isLocal == true ||
      zone?.isOffline == true ||
      zone?.isAndroidAuto == true;
}
