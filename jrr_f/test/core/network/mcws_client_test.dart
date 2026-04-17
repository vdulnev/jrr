import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/core/network/models/auth_result.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

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
    client = McwsClient(
      dio: mockDio,
      parser: McwsXmlParser(),
      tokenGetter: () => 'test-token',
      talker: Talker(),
    );
  });

  group('authenticate', () {
    test('returns AuthResult with token on success', () async {
      final jsonResponse = {
        'Token': 'new-token-123',
      };

      when(
        () => mockDio.fetch<Map<String, dynamic>>(any()),
      ).thenAnswer(
        (_) async => Response(
          data: jsonResponse,
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
        () => mockDio.get<String>(
          any(that: contains('Playback/Info')),
          queryParameters: any(named: 'queryParameters'),
          options: any(named: 'options'),
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
