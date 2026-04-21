import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../models/album.dart';
import '../models/browse_item.dart';
import '../models/track.dart';

abstract interface class LibraryRepository {
  Future<Either<AppException, List<BrowseItem>>> browseChildren(String id);

  Future<Either<AppException, List<Track>>> browseFiles(String id);
  Future<Either<AppException, List<Track>>> search(
    String query, {
    int startIndex,
  });

  Future<Either<AppException, List<String>>> getArtists();

  Future<Either<AppException, List<Album>>> getAlbumsByArtist(String artist);

  Future<Either<AppException, List<Track>>> getAlbumTracks(Album album);

  Future<Either<AppException, List<Track>>> getTracksByFolder(
    String folderPath,
  );

  Future<Either<AppException, Track?>> searchByFileKey(int fileKey);

  Future<Either<AppException, List<Album>>> getRandomAlbums({int count});

  /// Replaces the Playing Now queue and starts playback immediately.
  Future<Either<AppException, Unit>> playNow(String zoneId, List<int> fileKeys);

  /// Inserts [fileKeys] immediately after the current track.
  Future<Either<AppException, Unit>> playNext(
    String zoneId,
    List<int> fileKeys,
  );

  /// Appends [fileKeys] to the end of the Playing Now queue.
  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<int> fileKeys,
  );
}
