import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/data/models/albums.dart';
import 'package:jrr_f/features/library/data/models/browse_item.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/library/data/repositories/library_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockMcwsClient extends Mock implements McwsClient {}

class FakeAlbum extends Fake implements Album {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAlbum());
  });

  late MockMcwsClient client;
  late LibraryRepositoryImpl repo;

  setUp(() {
    client = MockMcwsClient();
    repo = LibraryRepositoryImpl(client: () => client);
  });

  test('browseChildren delegates to client', () async {
    const items = [BrowseItem(id: '1', name: 'A')];
    when(
      () => client.browseChildren('root'),
    ).thenAnswer((_) async => right<AppException, List<BrowseItem>>(items));
    final result = await repo.browseChildren('root');
    expect(result.getOrElse((_) => []), items);
    verify(() => client.browseChildren('root')).called(1);
  });

  test('browseFiles delegates to client', () async {
    final tracks = Tracks.fromList(const [Track(fileKey: 1)]);
    when(() => client.browseFiles('id')).thenAnswer((_) async => right(tracks));
    final result = await repo.browseFiles('id');
    expect(result.getOrElse((_) => Tracks.empty), tracks);
  });

  test('search forwards query and startIndex', () async {
    when(
      () => client.searchFiles('q', startIndex: 20),
    ).thenAnswer((_) async => right(Tracks.empty));
    await repo.search('q', startIndex: 20);
    verify(() => client.searchFiles('q', startIndex: 20)).called(1);
  });

  test('search defaults startIndex to 0', () async {
    when(
      () => client.searchFiles('q', startIndex: 0),
    ).thenAnswer((_) async => right(Tracks.empty));
    await repo.search('q');
    verify(() => client.searchFiles('q', startIndex: 0)).called(1);
  });

  test('getArtists delegates to client', () async {
    when(() => client.getArtists()).thenAnswer((_) async => right(['A', 'B']));
    expect((await repo.getArtists()).getOrElse((_) => []), ['A', 'B']);
  });

  test('getAlbumsByArtist delegates to client', () async {
    when(
      () => client.getAlbumsByArtist('Foo'),
    ).thenAnswer((_) async => right(Albums.empty));
    await repo.getAlbumsByArtist('Foo');
    verify(() => client.getAlbumsByArtist('Foo')).called(1);
  });

  test('getAlbumTracks delegates to client', () async {
    const album = Album(
      name: 'A',
      albumArtist: 'X',
      folderPath: '/a/',
      parentFolderPath: '/',
      albumGroupId: 'a|/',
    );
    when(
      () => client.getAlbumTracks(album),
    ).thenAnswer((_) async => right(Tracks.empty));
    await repo.getAlbumTracks(album);
    verify(() => client.getAlbumTracks(album)).called(1);
  });

  test('getTracksByFolder delegates to client', () async {
    when(
      () => client.getTracksByFolder('/m/'),
    ).thenAnswer((_) async => right(Tracks.empty));
    await repo.getTracksByFolder('/m/');
    verify(() => client.getTracksByFolder('/m/')).called(1);
  });

  test('getRandomAlbums delegates to client', () async {
    when(
      () => client.getRandomAlbums(),
    ).thenAnswer((_) async => right(Albums.empty));
    await repo.getRandomAlbums();
    verify(() => client.getRandomAlbums()).called(1);
  });

  test('playNow calls playByKey with no location override', () async {
    when(
      () => client.playByKey('z', [1, 2]),
    ).thenAnswer((_) async => right(unit));
    await repo.playNow('z', [1, 2]);
    verify(() => client.playByKey('z', [1, 2])).called(1);
  });

  test('playNext sets location to -1', () async {
    when(
      () => client.playByKey('z', [1], location: -1),
    ).thenAnswer((_) async => right(unit));
    await repo.playNext('z', [1]);
    verify(() => client.playByKey('z', [1], location: -1)).called(1);
  });

  test('addToQueue sets location to 0', () async {
    when(
      () => client.addToQueue('z', [1, 2], location: 0),
    ).thenAnswer((_) async => right(unit));
    await repo.addToQueue('z', [1, 2]);
    verify(() => client.addToQueue('z', [1, 2], location: 0)).called(1);
  });

  test('searchByFileKey delegates to client', () async {
    when(
      () => client.searchByFileKey(99),
    ).thenAnswer((_) async => right<AppException, Track?>(null));
    expect((await repo.searchByFileKey(99)).getOrElse((_) => null), isNull);
  });

  test('propagates errors from the client', () async {
    when(
      () => client.browseFiles('x'),
    ).thenAnswer((_) async => left(const AppException.unauthorized()));
    final result = await repo.browseFiles('x');
    expect(result.isLeft(), isTrue);
  });
}
