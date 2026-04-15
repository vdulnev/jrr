import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/zone.dart';
import 'zone_repository.dart';

class ZoneRepositoryImpl implements ZoneRepository {
  @override
  Future<Either<AppException, List<Zone>>> getZones() =>
      getIt<McwsClient>().getZones();

  @override
  Future<Either<AppException, Unit>> setActiveZone(String zoneId) =>
      getIt<McwsClient>().setActiveZone(zoneId);
}
