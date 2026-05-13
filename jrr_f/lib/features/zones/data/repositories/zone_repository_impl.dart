import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../connection/data/repositories/connection_repository.dart';
import '../../providers/active_zone_provider.dart';
import '../models/zone.dart';
import 'zone_repository.dart';

const offlineZone = Zone(
  id: 'offline',
  name: 'Offline',
  guid: 'offline-zone-guid',
  isDLNA: false,
  isLocal: false,
  isOffline: true,
);

const localZone = Zone(
  id: 'local',
  name: 'Local',
  guid: 'local-zone-guid',
  isDLNA: false,
  isLocal: true,
);

const androidAutoZone = Zone(
  id: 'android-auto',
  name: 'Android Auto',
  guid: 'android-auto-zone-guid',
  isDLNA: false,
  isAndroidAuto: true,
);

const _localZones = [localZone, offlineZone];

class ZoneRepositoryImpl implements ZoneRepository {
  @override
  Future<Either<AppException, List<Zone>>> getZones() async {
    // If the current session is the synthetic "offline" one, we skip all
    // network calls and only return the Offline zone.
    // We also hide the 'local' zone in this case because without a server
    // it's non-functional (cannot resolve streaming URLs).
    final session = getIt<ConnectionRepository>().currentToken;
    if (session == null) {
      return right([offlineZone]);
    }

    final savedGuid = getIt<SharedPreferences>().getString(kActiveZoneGuidKey);
    if (savedGuid == 'offline-zone-guid') {
      return right(_localZones);
    }

    try {
      final result = await getIt<McwsClient>().getZones();
      return result.fold(
        (e) => right(_localZones),
        (zones) => right([...zones, ..._localZones]),
      );
    } catch (_) {
      return right(_localZones);
    }
  }

  @override
  Future<Either<AppException, Unit>> setActiveZone(String zoneId) async {
    // Virtual zones (Local/Offline/Android Auto) don't need a server-side
    // setActiveZone call.
    if (zoneId == 'local' || zoneId == 'offline' || zoneId == 'android-auto') {
      return right(unit);
    }

    try {
      return await getIt<McwsClient>().setActiveZone(zoneId);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }
}
