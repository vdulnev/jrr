import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/network/models/location.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/album.dart';
import '../models/albums.dart';
import '../models/browse_item.dart';
import '../models/track.dart';
import '../models/tracks.dart';
import 'library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  final McwsClient Function() _client;

  LibraryRepositoryImpl({required McwsClient Function() client})
    : _client = client;

  @override
  Future<Either<AppException, List<BrowseItem>>> browseChildren(String id) =>
      _client().browseChildren(id);

  @override
  Future<Either<AppException, Tracks>> browseFiles(String id) =>
      _client().browseFiles(id);
  @override
  Future<Either<AppException, Tracks>> search(
    String query, {
    int startIndex = 0,
  }) => _client().searchFiles(query, startIndex: startIndex);

  @override
  Future<Either<AppException, List<String>>> getArtists() =>
      _client().getArtists();

  @override
  Future<Either<AppException, Albums>> getAlbumsByArtist(String artist) =>
      _client().getAlbumsByArtist(artist);

  @override
  Future<Either<AppException, Tracks>> getAlbumTracks(Album album) =>
      _client().getAlbumTracks(album);

  @override
  Future<Either<AppException, Tracks>> getTracksByFolder(String folderPath) =>
      _client().getTracksByFolder(folderPath);

  @override
  Future<Either<AppException, Albums>> getRandomAlbums({int count = 10}) =>
      _client().getRandomAlbums();

  @override
  Future<Either<AppException, Unit>> playNow(
    String zoneId,
    List<int> fileKeys,
  ) => _client().playByKey(zoneId, fileKeys);

  @override
  Future<Either<AppException, Unit>> playNext(
    String zoneId,
    List<int> fileKeys,
  ) => _client().playByKey(zoneId, fileKeys, location: Location.next);

  @override
  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<int> fileKeys,
  ) => _client().playByKey(zoneId, fileKeys, location: Location.end);

  @override
  Future<Either<AppException, Track?>> searchByFileKey(int fileKey) =>
      _client().searchByFileKey(fileKey);
}
