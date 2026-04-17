import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  late MockDio mockDio;
  late McwsClient client;

  setUp(() {
    mockDio = MockDio();
    when(() => mockDio.options).thenReturn(BaseOptions());
    client = McwsClient(dio: mockDio, parser: McwsXmlParser());
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
      when(
        () => mockDio.fetch<String>(
          any(
            that: isA<RequestOptions>().having(
              (r) => r.path,
              'path',
              contains('Alive'),
            ),
          ),
        ),
      ).thenAnswer(
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

      when(
        () => mockDio.fetch<String>(
          any(
            that: isA<RequestOptions>().having(
              (r) => r.path,
              'path',
              contains('Playback/Zones'),
            ),
          ),
        ),
      ).thenAnswer(
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
      when(
        () => mockDio.fetch<String>(
          any(
            that: isA<RequestOptions>().having(
              (r) => r.path,
              'path',
              contains('Playback/SetZone'),
            ),
          ),
        ),
      ).thenAnswer(
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

  group('getPlayingNow', () {
    test('parses raw JSON array correctly', () async {
      final jsonResponse = [
        {
          'Key': '1',
          'Name': 'Song 1',
          'Artist': 'Artist 1',
          'Album': 'Album 1',
        },
        {
          'Key': '2',
          'Name': 'Song 2',
          'Artist': 'Artist 2',
          'Album': 'Album 2',
        },
      ];

      when(
        () => mockDio.get<String>(
          any(that: contains('Playback/Playlist')),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: jsonEncode(jsonResponse),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items.length, 2);
      expect(items[0].name, 'Song 1');
      expect(items[1].name, 'Song 2');
    });

    test('parses JSON with minimal fields correctly', () async {
      final jsonResponse = [
        {
          'Key': '1',
          'Name': 'Song 1',
          'Artist': 'Artist 1',
          'Album': 'Album 1',
        },
        {
          'Key': '2',
          'Name': 'Song 2',
          'Artist': 'Artist 2',
          'Album': 'Album 2',
        },
      ];

      when(
        () => mockDio.get<String>(
          any(that: contains('Playback/Playlist')),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: jsonEncode(jsonResponse),
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items.length, 2);
      expect(items[0].name, 'Song 1');
      expect(items[0].artist, 'Artist 1');
      expect(items[1].name, 'Song 2');
    });

    test('returns empty list if response is invalid type', () async {
      when(
        () => mockDio.get<String>(
          any(that: contains('Playback/Playlist')),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.unknown,
        ),
      );

      final result = await client.getPlayingNow('zone-1');
      expect(result.isLeft(), true);
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
<Item Name="PositionMS">9241</Item>
<Item Name="DurationMS">165666</Item>
<Item Name="PlayingNowPosition">0</Item>
<Item Name="PlayingNowTracks">11</Item>
<Item Name="PlayingNowPositionDisplay">1 of 11</Item>
<Item Name="PlayingNowChangeCounter">20</Item>
<Item Name="Bitrate">1079</Item>
<Item Name="Bitdepth">16</Item>
<Item Name="SampleRate">44100</Item>
<Item Name="Channels">2</Item>
<Item Name="Volume">0.28508</Item>
<Item Name="VolumeDisplay">29%</Item>
<Item Name="ImageURL">MCWS/v1/File/GetImage?File=2302</Item>
<Item Name="Artist">ABBA</Item>
<Item Name="Album">Waterloo</Item>
<Item Name="Name">Waterloo</Item>
<Item Name="Status">Paused</Item>
</Response>
''';

      when(
        () => mockDio.fetch<String>(
          any(
            that: isA<RequestOptions>().having(
              (r) => r.path,
              'path',
              contains('Playback/Info'),
            ),
          ),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: xml,
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await client.getPlaybackInfo('0');

      expect(result.isRight(), true);
      final status = result.getOrElse((_) => throw Exception('Failed'));
      expect(status.trackInfo, isNotNull);
      expect(status.trackInfo?.name, 'Waterloo');
      expect(status.trackInfo?.artist, 'ABBA');
      expect(status.trackInfo?.fileKey, '2302');
      expect(status.playingNowTracks, 11);
      expect(status.playingNowPositionDisplay, '1 of 11');
    });
  });
}
