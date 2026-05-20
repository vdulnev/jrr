import 'package:jrr_f/features/zones/data/models/zones.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../data/models/zone.dart';
import 'zone_provider.dart';

part 'active_zone_provider.g.dart';

const kActiveZoneGuidKey = 'active_zone_guid';

@Riverpod(keepAlive: true)
class ActiveZone extends _$ActiveZone {
  @override
  Zone? build() {
    ref.listen(zoneListProvider, (previous, next) {
      ref
          .read(talkerProvider)
          .debug(
            '[activeZoneProvider] zoneListProvider changed: previous=$previous, next=$next',
          );
      if (next case AsyncData(:final value)) {
        final prevValue = switch (previous) {
          AsyncData(:final value) => value,
          AsyncLoading(:final value) => value,
          _ => null,
        };
        ref
            .read(talkerProvider)
            .debug(
              '[activeZoneProvider] zoneListProvider changed: prevValue=$prevValue, newValue=$value',
            );
        if (prevValue != value) {
          _restoreZone(value);
        } else {
          ref
              .read(talkerProvider)
              .debug(
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
    ref
        .read(talkerProvider)
        .debug(
          '[activeZoneProvider] Restoring active zone from SharedPreferences for $zones',
        );
    if (zones == null) return;
    if (zones.zones.isEmpty) {
      clear();
      return;
    }
    final savedGuid = ref
        .read(sharedPreferencesProvider)
        .getString(kActiveZoneGuidKey);
    final zone = savedGuid != null
        ? zones.zones.firstWhere(
            (z) => z.guid == savedGuid,
            orElse: () => zones.zones.first,
          )
        : zones.zones.first;
    ref
        .read(talkerProvider)
        .debug(
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
    ref
        .read(talkerProvider)
        .debug(
          '[activeZoneProvider] Zone: ${zone.name}, saving to SharedPreferences',
        );
    ref
        .read(sharedPreferencesProvider)
        .setString(kActiveZoneGuidKey, zone.guid);
  }

  void clear() {
    state = null;
    ref.read(sharedPreferencesProvider).remove(kActiveZoneGuidKey);
    ref
        .read(talkerProvider)
        .debug('[activeZoneProvider] Zone is cleared from SharedPreferences');
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

/// Reactive mirror of [AndroidAutoSessionService.isConnected]. The zone
/// repository surfaces the AA zone only while this is `true`; the zone
/// list provider invalidates itself whenever this flips so the picker
/// updates on connect/disconnect.
@Riverpod(keepAlive: true)
class AndroidAutoConnected extends _$AndroidAutoConnected {
  @override
  bool build() {
    final service = ref.read(androidAutoSessionServiceProvider);
    void listener() => state = service.isConnected.value;
    service.isConnected.addListener(listener);
    ref.onDispose(() => service.isConnected.removeListener(listener));
    return service.isConnected.value;
  }
}
