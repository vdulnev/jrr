import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

const _okXml = '<Response Status="OK"/>';

Response<String> _okResponse() => Response(
  data: _okXml,
  statusCode: 200,
  requestOptions: RequestOptions(path: ''),
);

Response<List<dynamic>> _jsonResponse(List<dynamic> data) => Response(
  data: data,
  statusCode: 200,
  requestOptions: RequestOptions(path: ''),
);

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  late MockDio mockDio;
  late McwsClient client;

  setUp(() {
    mockDio = MockDio();
    when(
      () => mockDio.options,
    ).thenReturn(BaseOptions(baseUrl: 'http://host:52199/MCWS/v1/'));
    client = McwsClient(dio: mockDio, parser: McwsXmlParser());
  });

  /// Returns the fully-resolved URI of the most recent fetch<String> call.
  Uri capturedUri() {
    final captured =
        verify(() => mockDio.fetch<String>(captureAny())).captured.single
            as RequestOptions;
    return captured.uri;
  }

  /// Returns the fully-resolved URI of the most recent fetch<List> call.
  Uri capturedJsonUri() {
    final captured =
        verify(() => mockDio.fetch<List<dynamic>>(captureAny())).captured.single
            as RequestOptions;
    return captured.uri;
  }

  void stubOk() {
    when(
      () => mockDio.fetch<String>(any()),
    ).thenAnswer((_) async => _okResponse());
  }

  void stubJson(List<dynamic> data) {
    when(
      () => mockDio.fetch<List<dynamic>>(any()),
    ).thenAnswer((_) async => _jsonResponse(data));
  }

  group('baseUrl getter', () {
    test('exposes the Dio base URL', () {
      expect(client.baseUrl, 'http://host:52199/MCWS/v1/');
    });
  });

  group('authenticate', () {
    test('returns parseError when Token is missing', () async {
      const xml =
          '<Response Status="OK"><Item Name="Other">x</Item></Response>';
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: xml,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await client.authenticate(username: 'u', password: 'p');
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<ParseErrorException>()),
        (_) => fail('expected left'),
      );
    });

    test('sends HTTP Basic auth header derived from credentials', () async {
      const xml =
          '<Response Status="OK"><Item Name="Token">tok</Item></Response>';
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: xml,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      await client.authenticate(username: 'user', password: 'pass');
      final captured =
          verify(() => mockDio.fetch<String>(captureAny())).captured.single
              as RequestOptions;
      // user:pass → dXNlcjpwYXNz
      expect(captured.headers['Authorization'], 'Basic dXNlcjpwYXNz');
    });
  });

  group('transport commands', () {
    test('playPause hits PlayPause endpoint', () async {
      stubOk();
      final result = await client.playPause('zoneA');
      expect(result.isRight(), isTrue);
      final uri = capturedUri();
      expect(uri.path, endsWith('Playback/PlayPause'));
      expect(uri.queryParameters['Zone'], 'zoneA');
    });

    test('stop hits Stop endpoint', () async {
      stubOk();
      expect((await client.stop('z')).isRight(), isTrue);
      expect(capturedUri().path, endsWith('Playback/Stop'));
    });

    test('stopAll hits StopAll endpoint', () async {
      stubOk();
      expect((await client.stopAll()).isRight(), isTrue);
      expect(capturedUri().path, endsWith('Playback/StopAll'));
    });

    test('next hits Next endpoint', () async {
      stubOk();
      expect((await client.next('z')).isRight(), isTrue);
      expect(capturedUri().path, endsWith('Playback/Next'));
    });

    test('previous hits Previous endpoint', () async {
      stubOk();
      expect((await client.previous('z')).isRight(), isTrue);
      expect(capturedUri().path, endsWith('Playback/Previous'));
    });
  });

  group('volume / mute / position', () {
    test('setVolume formats level to 3 decimals', () async {
      stubOk();
      await client.setVolume('z', 0.5);
      expect(capturedUri().queryParameters['Level'], '0.500');
    });

    test('setMute true sends Set=1', () async {
      stubOk();
      await client.setMute('z', mute: true);
      expect(capturedUri().queryParameters['Set'], '1');
    });

    test('setMute false sends Set=0', () async {
      stubOk();
      await client.setMute('z', mute: false);
      expect(capturedUri().queryParameters['Set'], '0');
    });

    test('setPosition sends Position in ms', () async {
      stubOk();
      await client.setPosition('z', 12345);
      final params = capturedUri().queryParameters;
      expect(params['Position'], '12345');
      expect(params['Mode'], 'ms');
    });
  });

  group('shuffle & repeat', () {
    test('setShuffle maps mode through ShuffleMode.toMcws', () async {
      stubOk();
      await client.setShuffle('z', ShuffleMode.automatic);
      expect(capturedUri().queryParameters['Mode'], 'Automatic');
    });

    test('setRepeat maps mode through RepeatMode.toMcws', () async {
      stubOk();
      await client.setRepeat('z', RepeatMode.playlist);
      expect(capturedUri().queryParameters['Mode'], 'Playlist');
    });
  });

  group('queue', () {
    test('playByIndex passes index as string', () async {
      stubOk();
      await client.playByIndex('z', 4);
      expect(capturedUri().queryParameters['Index'], '4');
    });

    test('removeFromQueue uses EditPlaylist Action=Remove', () async {
      stubOk();
      await client.removeFromQueue('z', 2);
      final params = capturedUri().queryParameters;
      expect(params['Action'], 'Remove');
      expect(params['Source'], '2');
      expect(params.containsKey('Target'), isFalse);
    });

    test('moveInQueue uses EditPlaylist Action=Move with Target', () async {
      stubOk();
      await client.moveInQueue('z', 3, 7);
      final params = capturedUri().queryParameters;
      expect(params['Action'], 'Move');
      expect(params['Source'], '3');
      expect(params['Target'], '7');
    });

    test('clearQueue hits ClearPlaylist', () async {
      stubOk();
      await client.clearQueue('z');
      expect(capturedUri().path, endsWith('Playback/ClearPlaylist'));
    });
  });

  group('library queries — escape behaviour', () {
    test('searchFiles escapes []()- characters with /', () async {
      stubJson([]);
      await client.searchFiles('foo (bar) [baz]-qux');
      final query = capturedJsonUri().queryParameters['Query']!;
      // Each special char must be prefixed with '/'.
      expect(query, contains(r'foo /(bar/) /[baz/]/-qux'));
    });

    test(
      'searchFiles returns empty Tracks for whitespace-only query',
      () async {
        final result = await client.searchFiles('   ');
        expect(result.isRight(), isTrue);
        expect(result.getOrElse((_) => throw 'x').isEmpty, isTrue);
        verifyNever(() => mockDio.fetch<List<dynamic>>(any()));
      },
    );

    test('searchFiles sorts results by name', () async {
      stubJson([
        {'Key': 1, 'Name': 'Charlie'},
        {'Key': 2, 'Name': 'Alpha'},
        {'Key': 3, 'Name': 'Bravo'},
      ]);
      final result = await client.searchFiles('q');
      final tracks = result.getOrElse((_) => throw 'x');
      expect(tracks.tracks.map((t) => t.name), ['Alpha', 'Bravo', 'Charlie']);
    });

    test('searchByFileKey returns null when fileKey <= 0', () async {
      final result = await client.searchByFileKey(0);
      expect(result.getOrElse((_) => throw 'x'), isNull);
      verifyNever(() => mockDio.fetch<List<dynamic>>(any()));
    });

    test('searchByFileKey returns first track when fileKey > 0', () async {
      stubJson([
        {'Key': 7, 'Name': 'A'},
        {'Key': 7, 'Name': 'B'},
      ]);
      final result = await client.searchByFileKey(7);
      expect(result.getOrElse((_) => throw 'x')!.name, 'A');
    });

    test('getAlbumsByArtist escapes artist and sets sort', () async {
      stubJson([
        {
          'Key': 1,
          'Album': 'X',
          'Album Artist (auto)': 'Foo',
          'Filename': '/a/',
        },
      ]);
      await client.getAlbumsByArtist('Foo (Live)');
      final query = capturedJsonUri().queryParameters['Query']!;
      expect(query, contains(r'[Album Artist (auto)]=[Foo /(Live/)]'));
      expect(query, contains('~sort=[Album]'));
    });

    test('getAlbumTracks adds folderPath filter when provided', () async {
      stubJson([
        {'Key': 1, 'Name': 'S', 'Album': 'X'},
      ]);
      const album = Album(
        name: 'X',
        albumArtist: 'A',
        folderPath: '/Music/X/',
        parentFolderPath: '/Music/',
        albumGroupId: 'x|/Music/',
      );
      await client.getAlbumTracks(album);
      final query = capturedJsonUri().queryParameters['Query']!;
      expect(query, contains('[Album]=[X]'));
      expect(query, contains('[Filename (path)]="/Music/X/"'));
      expect(query, contains('~sort=[Disc #],[Track #]'));
    });

    test('getAlbumTracks omits folderPath filter when empty', () async {
      stubJson([]);
      const album = Album(
        name: 'X',
        albumArtist: 'A',
        folderPath: '',
        parentFolderPath: '',
        albumGroupId: 'x|',
      );
      await client.getAlbumTracks(album);
      final query = capturedJsonUri().queryParameters['Query']!;
      expect(query, isNot(contains('[Filename (path)]=')));
    });

    test('getTracksByFolder escapes folderPath', () async {
      stubJson([]);
      await client.getTracksByFolder('/Music/Artist (Live)/');
      final query = capturedJsonUri().queryParameters['Query']!;
      expect(query, contains(r'[Filename (path)]="/Music/Artist /(Live/)/"'));
    });

    test('getRandomAlbums uses limit/n=10 query', () async {
      stubJson([
        {'Key': 1, 'Album': 'X', 'Album Artist (auto)': 'Y', 'Filename': '/a/'},
      ]);
      await client.getRandomAlbums();
      final query = capturedJsonUri().queryParameters['Query']!;
      expect(query, contains('~limit=10'));
      expect(query, contains('~n=10'));
    });
  });

  group('browse', () {
    test(
      'browseChildren returns BrowseItems built from name/id pairs',
      () async {
        const xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
<Item Name="Rock">10</Item>
<Item Name="Pop">11</Item>
</Response>
''';
        when(() => mockDio.fetch<String>(any())).thenAnswer(
          (_) async => Response(
            data: xml,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        final result = await client.browseChildren('99');
        final items = result.getOrElse((_) => throw 'x');
        expect(items.map((i) => i.name), ['Rock', 'Pop']);
        expect(items.map((i) => i.id), ['10', '11']);
      },
    );

    test('browseFiles wraps JSON tracks into Tracks', () async {
      stubJson([
        {'Key': 5, 'Name': 'Song'},
      ]);
      final result = await client.browseFiles('33');
      final tracks = result.getOrElse((_) => throw 'x');
      expect(tracks.length, 1);
      expect(tracks[0].fileKey, 5);
    });
  });

  group('error mapping', () {
    Future<AppException> runWithError(DioException ex) async {
      when(() => mockDio.fetch<String>(any())).thenThrow(ex);
      final result = await client.alive();
      return result.fold((e) => e, (_) => throw StateError('expected left'));
    }

    test('connectionError → connectionRefused', () async {
      final mapped = await runWithError(
        DioException(
          requestOptions: RequestOptions(
            baseUrl: 'http://host:52199/',
            path: 'Alive',
          ),
          type: DioExceptionType.connectionError,
        ),
      );
      expect(mapped, isA<ConnectionRefusedException>());
      expect(
        (mapped as ConnectionRefusedException).address,
        'http://host:52199/',
      );
    });

    test('connectionTimeout → connectionRefused', () async {
      final mapped = await runWithError(
        DioException(
          requestOptions: RequestOptions(baseUrl: 'http://b/', path: 'p'),
          type: DioExceptionType.connectionTimeout,
        ),
      );
      expect(mapped, isA<ConnectionRefusedException>());
    });

    test('receiveTimeout → timeout', () async {
      final mapped = await runWithError(
        DioException(
          requestOptions: RequestOptions(baseUrl: 'http://b/', path: 'p'),
          type: DioExceptionType.receiveTimeout,
        ),
      );
      expect(mapped, isA<AppTimeoutException>());
    });

    test('sendTimeout → timeout', () async {
      final mapped = await runWithError(
        DioException(
          requestOptions: RequestOptions(baseUrl: 'http://b/', path: 'p'),
          type: DioExceptionType.sendTimeout,
        ),
      );
      expect(mapped, isA<AppTimeoutException>());
    });

    test('badResponse 401 → unauthorized', () async {
      final req = RequestOptions(baseUrl: 'http://b/', path: 'p');
      final mapped = await runWithError(
        DioException(
          requestOptions: req,
          response: Response(requestOptions: req, statusCode: 401),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(mapped, isA<UnauthorizedException>());
    });

    test('badResponse 500 → unknown', () async {
      final req = RequestOptions(baseUrl: 'http://b/', path: 'p');
      final mapped = await runWithError(
        DioException(
          requestOptions: req,
          response: Response(requestOptions: req, statusCode: 500),
          type: DioExceptionType.badResponse,
        ),
      );
      expect(mapped, isA<UnknownException>());
    });

    test(
      'DioException carrying AppException passes through unchanged',
      () async {
        const inner = AppException.unauthorized();
        final mapped = await runWithError(
          DioException(
            requestOptions: RequestOptions(baseUrl: 'http://b/', path: 'p'),
            error: inner,
            type: DioExceptionType.cancel,
          ),
        );
        expect(mapped, same(inner));
      },
    );

    test('non-Dio exception → unknown', () async {
      when(() => mockDio.fetch<String>(any())).thenThrow(StateError('boom'));
      final result = await client.alive();
      final err = result.fold((e) => e, (_) => throw 'x');
      expect(err, isA<UnknownException>());
    });

    test('MCWS Failure status surfaces as serverFailure', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: '<Response Status="Failure"/>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await client.alive();
      final err = result.fold((e) => e, (_) => throw 'x');
      expect(err, isA<ServerFailureException>());
    });
  });
}
