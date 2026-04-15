import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../models/zone.dart';

abstract interface class ZoneRepository {
  Future<Either<AppException, List<Zone>>> getZones();
  Future<Either<AppException, Unit>> setActiveZone(String zoneId);
}
