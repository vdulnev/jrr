import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../models/album.dart';
import '../models/track.dart';

abstract interface class LibraryRepository {
  Future<Either<AppException, List<Track>>> search(
    String query, {
    int startIndex,
    int count,
  });

  Future<Either<AppException, List<String>>> getArtists();

  Future<Either<AppException, List<Album>>> getAlbumsByArtist(String artist);

  Future<Either<AppException, List<Track>>> getAlbumTracks(Album album);

  /// Replaces the Playing Now queue and starts playback immediately.
  Future<Either<AppException, Unit>> playNow(
    String zoneId,
    List<String> fileKeys,
  );

  /// Inserts [fileKeys] immediately after the current track.
  Future<Either<AppException, Unit>> playNext(
    String zoneId,
    List<String> fileKeys,
  );

  /// Appends [fileKeys] to the end of the Playing Now queue.
  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<String> fileKeys,
  );
}
