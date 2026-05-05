import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../../providers/active_zone_provider.dart';
import '../models/zone.dart';
import 'zone_repository.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  @override
  Future<Either<AppException, List<Zone>>> getZones() async {
    final localZones = [
      const Zone(
        id: 'local',
        name: 'Local',
        guid: 'local-zone-guid',
        isDLNA: false,
        isLocal: true,
      ),
      const Zone(
        id: 'offline',
        name: 'Offline',
        guid: 'offline-zone-guid',
        isDLNA: false,
        isLocal: false,
        isOffline: true,
      ),
    ];

    final savedGuid = getIt<SharedPreferences>().getString(kActiveZoneGuidKey);
    if (savedGuid == 'offline-zone-guid') {
      return right(localZones);
    }

    try {
      final result = await getIt<McwsClient>().getZones();
      return result.fold(
        (e) => right(localZones),
        (zones) => right([...zones, ...localZones]),
      );
    } catch (_) {
      return right(localZones);
    }
  }

  @override
  Future<Either<AppException, Unit>> setActiveZone(String zoneId) async {
    // Local/Offline zones don't need a server-side setActiveZone call
    if (zoneId == 'local' || zoneId == 'offline') {
      return right(unit);
    }

    try {
      return await getIt<McwsClient>().setActiveZone(zoneId);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }
}
