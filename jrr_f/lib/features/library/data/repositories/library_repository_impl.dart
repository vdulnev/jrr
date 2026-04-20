import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/album.dart';
import '../models/track.dart';
import 'library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  @override
  Future<Either<AppException, List<Track>>> search(
    String query, {
    int startIndex = 0,
  }) => getIt<McwsClient>().searchFiles(query, startIndex: startIndex);

  @override
  Future<Either<AppException, List<String>>> getArtists() =>
      getIt<McwsClient>().getArtists();

  @override
  Future<Either<AppException, List<Album>>> getAlbumsByArtist(String artist) =>
      getIt<McwsClient>().getAlbumsByArtist(artist);

  @override
  Future<Either<AppException, List<Track>>> getAlbumTracks(Album album) =>
      getIt<McwsClient>().getAlbumTracks(album);

  @override
  Future<Either<AppException, List<Track>>> getTracksByFolder(
    String folderPath,
  ) => getIt<McwsClient>().getTracksByFolder(folderPath);

  @override
  Future<Either<AppException, List<Album>>> getRandomAlbums({int count = 10}) =>
      getIt<McwsClient>().getRandomAlbums();

  @override
  Future<Either<AppException, Unit>> playNow(
    String zoneId,
    List<int> fileKeys,
  ) => getIt<McwsClient>().playByKey(zoneId, fileKeys);

  @override
  Future<Either<AppException, Unit>> playNext(
    String zoneId,
    List<int> fileKeys,
  ) => getIt<McwsClient>().playByKey(zoneId, fileKeys, location: -1);

  @override
  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<int> fileKeys,
  ) => getIt<McwsClient>().addToQueue(zoneId, fileKeys, location: 0);
}
