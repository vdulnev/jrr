import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/album.dart';
import '../models/library_item.dart';
import 'library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  @override
  Future<Either<AppException, List<LibraryItem>>> search(
    String query, {
    int startIndex = 0,
    int count = 100,
  }) => getIt<McwsClient>().searchFiles(
    query,
    startIndex: startIndex,
    count: count,
  );

  @override
  Future<Either<AppException, List<String>>> getArtists() =>
      getIt<McwsClient>().getArtists();

  @override
  Future<Either<AppException, List<Album>>> getAlbumsByArtist(String artist) =>
      getIt<McwsClient>().getAlbumsByArtist(artist);

  @override
  Future<Either<AppException, List<LibraryItem>>> getAlbumTracks(Album album) =>
      getIt<McwsClient>().getAlbumTracks(album);

  @override
  Future<Either<AppException, Unit>> playNow(
    String zoneId,
    List<String> fileKeys,
  ) => getIt<McwsClient>().playByKey(zoneId, fileKeys);

  @override
  Future<Either<AppException, Unit>> playNext(
    String zoneId,
    List<String> fileKeys,
  ) => getIt<McwsClient>().playByKey(zoneId, fileKeys, location: 'Next');

  @override
  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<String> fileKeys,
  ) => getIt<McwsClient>().playByKey(zoneId, fileKeys, location: 'End');
}
