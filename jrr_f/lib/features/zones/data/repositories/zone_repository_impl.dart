import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/zone.dart';
import 'zone_repository.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  @override
  Future<Either<AppException, List<Zone>>> getZones() async {
    final result = await getIt<McwsClient>().getZones();
    return result.map((zones) {
      return [
        ...zones,
        const Zone(
          id: 'local',
          name: 'Local',
          guid: 'local-zone-guid',
          isDLNA: false,
          isLocal: true,
        ),
      ];
    });
  }

  @override
  Future<Either<AppException, Unit>> setActiveZone(String zoneId) =>
      getIt<McwsClient>().setActiveZone(zoneId);
}
