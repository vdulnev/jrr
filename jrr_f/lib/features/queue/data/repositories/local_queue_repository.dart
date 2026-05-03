import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/tracks.dart';

abstract interface class LocalQueueRepository {
  /// Gets all tracks in the local queue, ordered by position.
  Future<Either<AppException, Tracks>> getTracks();

  /// Clears the local queue and adds these tracks.
  Future<Either<AppException, Unit>> setTracks(Tracks tracks);

  /// Gets the current track index in the local queue.
  Future<Either<AppException, int>> getCurrentIndex();

  /// Sets the current track index in the local queue.
  Future<Either<AppException, Unit>> setCurrentIndex(int index);
}
