import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/track.dart';

abstract interface class LocalQueueRepository {
  /// Gets all tracks in the local queue, ordered by position.
  Future<Either<AppException, List<Track>>> getTracks();

  /// Clears the local queue and adds these tracks.
  Future<Either<AppException, Unit>> setTracks(List<Track> tracks);
}
