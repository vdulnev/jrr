import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/di/injection.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockDio extends Mock implements Dio {}

class FakeOptions extends Fake implements Options {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeOptions());
  });

  late MockDio mockDio;
  late McwsClient client;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<Talker>(Talker());

    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    client = McwsClient(dio: mockDio, parser: McwsXmlParser());
  });

  tearDown(() async {
    await getIt.reset();
  });

  group('authenticate', () {
    test('returns AuthResult with token on success', () async {
      const xmlResponse = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
<Item Name="Token">new-token-123</Item>
</Response>
''';

      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: xmlResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.authenticate(
        username: 'user',
        password: 'pass',
      );

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()).token, 'new-token-123');
    });

    test('alive returns Unit and ignores data', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data:
              '<Response Status="OK"><Item Name="Anything">Value</Item></Response>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.alive();

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()), unit);
    });
  });

  group('getZones', () {
    test('parses XML zones correctly', () async {
      const xmlResponse = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
<Item Name="NumberZones">1</Item>
<Item Name="ZoneName0">Player</Item>
<Item Name="ZoneID0">0</Item>
<Item Name="ZoneGUID0">{GUID-0}</Item>
<Item Name="ZoneDLNA0">1</Item>
</Response>
''';

      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: xmlResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getZones();

      expect(result.isRight(), true);
      final zones = result.getOrElse((_) => []);
      expect(zones.length, 1);
      expect(zones[0].name, 'Player');
      expect(zones[0].id, '0');
    });
  });

  group('setActiveZone', () {
    test('returns Unit on success', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: '<Response Status="OK"></Response>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.setActiveZone('0');

      expect(result.isRight(), true);
      expect(result.getOrElse((_) => throw Exception()), unit);
    });
  });

  group('transport & controls', () {
    test('play returns Unit', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: '<Response Status="OK"/>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await client.play('0');
      expect(result.isRight(), true);
    });

    test('setPosition sends correct params', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: '<Response Status="OK"/>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await client.setPosition('0', 5000);
      expect(result.isRight(), true);
    });

    test('setVolume sends correct level', () async {
      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: '<Response Status="OK"/>',
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final result = await client.setVolume('0', 0.5);
      expect(result.isRight(), true);
    });
  });

  group('getPlayingNow', () {
    test('parses raw JSON array correctly', () async {
      final jsonResponse = [
        {'Key': 1, 'Name': 'Song 1', 'Artist': 'Artist 1', 'Album': 'Album 1'},
      ];

      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => Tracks.empty);
      expect(items.length, 1);
      expect(items[0].name, 'Song 1');
    });
  });

  group('getPlaybackInfo', () {
    test('parses user XML correctly', () async {
      const xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
<Item Name="ZoneID">0</Item>
<Item Name="State">1</Item>
<Item Name="FileKey">2302</Item>
<Item Name="Artist">ABBA</Item>
<Item Name="Album">Waterloo</Item>
<Item Name="Name">Waterloo</Item>
<Item Name="Status">Paused</Item>
</Response>
''';

      when(() => mockDio.fetch<String>(any())).thenAnswer(
        (_) async => Response(
          data: xml,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getPlaybackInfo('0');

      expect(result.isRight(), true);
      final status = result.getOrElse((_) => throw Exception('Failed'));
      expect(status.name, 'Waterloo');
      expect(status.artist, 'ABBA');
    });
  });

  group('searchFiles', () {
    test('returns empty list for empty query', () async {
      final result = await client.searchFiles('');
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => Tracks.empty).isEmpty, true);
    });

    test('trims query and returns tracks', () async {
      final jsonResponse = [
        {
          'Key': 123,
          'Name': 'Matched Song',
          'Artist': 'Artist',
          'Album': 'Album',
        },
      ];

      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.searchFiles('  query  ');

      expect(result.isRight(), true);
      final tracks = result.getOrElse((_) => Tracks.empty);
      expect(tracks.length, 1);
      expect(tracks[0].fileKey, 123);
      expect(tracks[0].name, 'Matched Song');
    });
  });

  group('getArtists', () {
    test('extracts names from track list', () async {
      final jsonResponse = [
        {'Key': 1, 'Artist': 'ABBA'},
        {'Key': 2, 'Artist': 'Queen'},
      ];

      when(() => mockDio.fetch<List<dynamic>>(any())).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getArtists();

      expect(result.isRight(), true);
      final artists = result.getOrElse((_) => []);
      expect(artists, ['ABBA', 'Queen']);
    });
  });
}
