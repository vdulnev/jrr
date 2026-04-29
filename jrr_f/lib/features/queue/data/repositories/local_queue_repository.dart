import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/track.dart';

abstract interface class LocalQueueRepository {
  /// Gets all tracks in the local queue, ordered by position.
  Future<Either<AppException, List<Track>>> getTracks();

  /// Adds tracks to the end of the local queue.
  Future<Either<AppException, Unit>> addTracks(List<Track> tracks);

  /// Clears the local queue and adds these tracks.
  Future<Either<AppException, Unit>> setTracks(List<Track> tracks);

  /// Inserts tracks at a specific index in the local queue.
  Future<Either<AppException, Unit>> insertTracksAt(int index, List<Track> tracks);

  /// Removes a track at a specific index.
  Future<Either<AppException, Unit>> removeTrack(int index);

  /// Reorders a track from [oldIndex] to [newIndex].
  Future<Either<AppException, Unit>> moveTrack(int oldIndex, int newIndex);

  /// Clears all tracks from the local queue.
  Future<Either<AppException, Unit>> clear();

  /// Gets the current track index in the local queue.
  Future<Either<AppException, int>> getCurrentIndex();

  /// Sets the current track index in the local queue.
  Future<Either<AppException, Unit>> setCurrentIndex(int index);
}
