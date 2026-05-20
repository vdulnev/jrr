import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../library/data/models/tracks.dart';
import 'queue_repository.dart';

class QueueRepositoryImpl implements QueueRepository {
  final McwsClient Function() _client;

  QueueRepositoryImpl({required McwsClient Function() client})
    : _client = client;

  @override
  Future<Either<AppException, Tracks>> getQueue(String zoneId) =>
      _client().getPlayingNow(zoneId);

  @override
  Future<Either<AppException, Unit>> removeItem(String zoneId, int index) =>
      _client().removeFromQueue(zoneId, index);

  @override
  Future<Either<AppException, Unit>> moveItem(
    String zoneId,
    int source,
    int target,
  ) => _client().moveInQueue(zoneId, source, target);

  @override
  Future<Either<AppException, Unit>> clearQueue(String zoneId) =>
      _client().clearQueue(zoneId);
}
