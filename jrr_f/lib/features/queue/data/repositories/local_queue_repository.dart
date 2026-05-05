import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/tracks.dart';

abstract interface class LocalQueueRepository {
  /// Gets all tracks in the local queue for a specific zone, ordered by position.
  Future<Either<AppException, Tracks>> getTracks(String zoneId);

  /// Clears the local queue for a specific zone and adds these tracks.
  Future<Either<AppException, Unit>> setTracks(String zoneId, Tracks tracks);

  /// Gets the current track index in the local queue for a specific zone.
  Future<Either<AppException, int>> getCurrentIndex(String zoneId);

  /// Sets the current track index in the local queue for a specific zone.
  Future<Either<AppException, Unit>> setCurrentIndex(String zoneId, int index);
}
