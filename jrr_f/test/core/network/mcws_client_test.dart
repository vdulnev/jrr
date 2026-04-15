import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';
import 'package:jrr_f/features/queue/data/models/playing_now_item.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late McwsClient client;

  setUp(() {
    mockDio = MockDio();
    client = McwsClient(dio: mockDio, parser: McwsXmlParser());
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
        }
      ];

      when(() => mockDio.get<String>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: jsonEncode(jsonResponse),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items.length, 2);
      expect(items[0].name, 'Song 1');
      expect(items[1].name, 'Song 2');
    });

    test('parses Response JSON correctly', () async {
      final jsonResponse = {
        'Response': {
          'Status': 'OK',
          'Item': [
            {
              'Key': '1',
              'Name': 'Song 1',
              'Artist': 'Artist 1',
              'Album': 'Album 1',
            }
          ]
        }
      };

      when(() => mockDio.get<String>(
            any(that: contains('ResponseFormat=JSON')),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: jsonEncode(jsonResponse),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items.length, 1);
      expect(items[0].name, 'Song 1');
    });

    test('parses MPL JSON with Field array correctly', () async {
      final jsonResponse = {
        'MPL': {
          'Item': [
            {
              'Field': [
                {'Name': 'Key', 'Value': '1'},
                {'Name': 'Name', 'Value': 'Song 1'},
                {'Name': 'Artist', 'Value': 'Artist 1'},
              ]
            },
            {
              'Field': [
                {'Name': 'Key', 'Value': '2'},
                {'Name': 'Name', 'Value': 'Song 2'},
              ]
            }
          ]
        }
      };

      when(() => mockDio.get<String>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: jsonEncode(jsonResponse),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items.length, 2);
      expect(items[0].name, 'Song 1');
      expect(items[0].artist, 'Artist 1');
      expect(items[1].name, 'Song 2');
    });

    test('parses MPL JSON with flat Item fields correctly', () async {
      final jsonResponse = {
        'MPL': {
          'Item': [
            {
              'Key': '1',
              'Name': 'Song 1',
            }
          ]
        }
      };

      when(() => mockDio.get<String>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: jsonEncode(jsonResponse),
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await client.getPlayingNow('zone-1');

      expect(result.isRight(), true);
      final items = result.getOrElse((_) => []);
      expect(items[0].name, 'Song 1');
    });

    test('returns empty list if response is invalid type', () async {
      when(() => mockDio.get<String>(
            any(),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: '123',
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await client.getPlayingNow('zone-1');
      expect(result.isRight(), true);
      expect(result.getOrElse((_) => [const PlayingNowItem(index: 0, fileKey: '', name: 'fail', artist: '', album: '')]), isEmpty);
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

      when(() => mockDio.get<String>(
            any(that: contains('Playback/Info')),
            queryParameters: any(named: 'queryParameters'),
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: xml,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

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
