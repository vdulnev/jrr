import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../models/playing_now_item.dart';

abstract interface class QueueRepository {
  Future<Either<AppException, List<PlayingNowItem>>> getQueue(String zoneId);
  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index);
  Future<Either<AppException, Unit>> removeItem(String zoneId, int index);
  Future<Either<AppException, Unit>> moveItem(
    String zoneId,
    int source,
    int target,
  );
  Future<Either<AppException, Unit>> clearQueue(String zoneId);
}
