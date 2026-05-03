import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../library/data/models/tracks.dart';
import 'queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  @override
  Future<Either<AppException, Tracks>> getQueue(String zoneId) =>
      getIt<McwsClient>().getPlayingNow(zoneId);

  @override
  Future<Either<AppException, Unit>> removeItem(String zoneId, int index) =>
      getIt<McwsClient>().removeFromQueue(zoneId, index);

  @override
  Future<Either<AppException, Unit>> moveItem(
    String zoneId,
    int source,
    int target,
  ) => getIt<McwsClient>().moveInQueue(zoneId, source, target);

  @override
  Future<Either<AppException, Unit>> clearQueue(String zoneId) =>
      getIt<McwsClient>().clearQueue(zoneId);
}
