import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/app_exception.dart';
import '../../features/player/data/models/playback_state.dart';
import '../../features/player/data/models/player_status.dart';
import '../../features/player/data/models/repeat_mode.dart';
import '../../features/player/data/models/shuffle_mode.dart';
import '../../features/player/data/models/track_info.dart';
import '../../features/queue/data/models/playing_now_item.dart';
import '../../features/zones/data/models/zone.dart';
import 'mcws_xml_parser.dart';

class McwsClient {
  final Dio _dio;
  final McwsXmlParser _parser;

  McwsClient({required Dio dio, required McwsXmlParser parser})
    : _dio = dio,
      _parser = parser;

  String get baseUrl => _dio.options.baseUrl;

  /// Makes a GET request and parses the XML response into a field map.
  Future<Either<AppException, Map<String, String>>> get(
    String endpoint, {
    Map<String, String> params = const {},
  }) async {
    try {
      final response = await _dio.get<String>(
        endpoint,
        queryParameters: params,
        options: Options(responseType: ResponseType.plain),
      );
      final body = response.data;
      if (body == null) {
        return left(
          const AppException.parseError(details: 'Empty response body'),
        );
      }
      return _parser.parse(body);
    } on DioException catch (e) {
      return left(_mapDioException(e));
    }
  }

  /// Sends a command and returns Unit (discards the response fields).
  Future<Either<AppException, Unit>> command(
    String endpoint, {
    Map<String, String> params = const {},
  }) async {
    return (await get(endpoint, params: params)).map((_) => unit);
  }

  // -------------------------------------------------------------------------
  // Connection
  // -------------------------------------------------------------------------

  /// Authenticates via HTTP Basic auth. Returns the session token.
  Future<Either<AppException, String>> authenticate({
    required String username,
    required String password,
  }) async {
    try {
      final credentials = base64Encode(utf8.encode('$username:$password'));
      final response = await _dio.get<String>(
        'Authenticate',
        options: Options(
          responseType: ResponseType.plain,
          extra: {'skipAuth': true},
          headers: {'Authorization': 'Basic $credentials'},
        ),
      );
      final body = response.data;
      if (body == null) {
        return left(
          const AppException.parseError(details: 'Empty response body'),
        );
      }
      final parseResult = _parser.parse(body);
      return parseResult.flatMap((fields) {
        final token = fields['Token'];
        if (token == null) {
          return left(
            const AppException.parseError(
              details: 'Token missing from Authenticate response',
            ),
          );
        }
        return right(token);
      });
    } on DioException catch (e) {
      return left(_mapDioException(e));
    }
  }

  /// Calls Alive and returns server metadata as a field map.
  Future<Either<AppException, Map<String, String>>> alive() async {
    return get('Alive');
  }

  // -------------------------------------------------------------------------
  // Zones
  // -------------------------------------------------------------------------

  Future<Either<AppException, List<Zone>>> getZones() async {
    return (await get('Playback/Zones')).flatMap((fields) {
      final count = int.tryParse(fields['NumberZones'] ?? '');
      if (count == null) {
        return left(
          const AppException.parseError(details: 'Missing NumberZones'),
        );
      }
      final zones = <Zone>[];
      for (var i = 0; i < count; i++) {
        final id = fields['ZoneID$i'];
        final name = fields['ZoneName$i'];
        final guid = fields['ZoneGUID$i'];
        if (id == null || name == null || guid == null) {
          return left(
            AppException.parseError(details: 'Missing zone fields at index $i'),
          );
        }
        zones.add(
          Zone(
            id: id,
            name: name,
            guid: guid,
            isDLNA: fields['ZoneDLNA$i'] == '1',
          ),
        );
      }
      return right(zones);
    });
  }

  Future<Either<AppException, Unit>> setActiveZone(String zoneId) {
    return command(
      'Playback/SetZone',
      params: {'Zone': zoneId, 'ZoneType': 'ID'},
    );
  }

  // -------------------------------------------------------------------------
  // Player info
  // -------------------------------------------------------------------------

  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(
    String zoneId,
  ) async {
    return (await get(
      'Playback/Info',
      params: {'Zone': zoneId, 'ZoneType': 'ID'},
    )).flatMap((fields) {
      final zId = fields['ZoneID'] ?? zoneId;
      final zName = fields['ZoneName'] ?? '';
      final state = PlaybackState.fromMcws(fields['State'] ?? '0');

      final posMs = int.tryParse(fields['PositionMS'] ?? '0') ?? 0;
      final durMs = int.tryParse(fields['DurationMS'] ?? '0') ?? 0;
      final posDisplay = fields['PositionDisplay'] ?? '';

      // Volume: MCWS returns 0–100; normalise to 0.0–1.0.
      final rawVol = double.tryParse(fields['Volume'] ?? '0') ?? 0.0;
      final volume = (rawVol > 1.0 ? rawVol / 100.0 : rawVol).clamp(0.0, 1.0);
      final volDisplay = fields['VolumeDisplay'] ?? '';

      final isMuted =
          fields['Muted'] == '1' || volDisplay.toLowerCase().contains('muted');

      final shuffleMode = ShuffleMode.fromMcws(fields['Shuffle'] ?? '');
      final repeatMode = RepeatMode.fromMcws(fields['Repeat'] ?? '');

      final pnPos = int.tryParse(fields['PlayingNowPosition'] ?? '-1') ?? -1;
      final pnTracks = int.tryParse(fields['PlayingNowTracks'] ?? '0') ?? 0;
      final pnPosDisplay = fields['PlayingNowPositionDisplay'] ?? '';
      final pnCounter =
          int.tryParse(fields['PlayingNowChangeCounter'] ?? '0') ?? 0;

      // TrackInfo is only present when something is loaded in the queue.
      final fileKey = fields['FileKey'] ?? fields['Key'];
      TrackInfo? trackInfo;
      if (fileKey != null && fileKey.isNotEmpty && fileKey != '-1') {
        trackInfo = TrackInfo(
          fileKey: fileKey,
          name: fields['Name'] ?? fields['Title'] ?? '',
          artist: fields['Artist'] ??
              fields['Album Artist'] ??
              fields['AlbumArtist'] ??
              '',
          album: fields['Album'] ?? '',
          imageUrl: fields['ImageURL'] ?? '',
          bitrate: int.tryParse(fields['Bitrate'] ?? '0') ?? 0,
          bitDepth: int.tryParse(fields['BitDepth'] ?? '0') ?? 0,
          sampleRate: int.tryParse(fields['SampleRate'] ?? '0') ?? 0,
          channels: int.tryParse(fields['Channels'] ?? '0') ?? 0,
        );
      }

      return right(
        PlayerStatus(
          zoneId: zId,
          zoneName: zName,
          state: state,
          trackInfo: trackInfo,
          positionMs: posMs,
          durationMs: durMs,
          positionDisplay: posDisplay,
          volume: volume,
          volumeDisplay: volDisplay,
          isMuted: isMuted,
          shuffleMode: shuffleMode,
          repeatMode: repeatMode,
          playingNowPosition: pnPos,
          playingNowTracks: pnTracks,
          playingNowPositionDisplay: pnPosDisplay,
          playingNowChangeCounter: pnCounter,
        ),
      );
    });
  }

  // -------------------------------------------------------------------------
  // Transport
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> play(String zoneId) =>
      command('Playback/Play', params: {'Zone': zoneId, 'ZoneType': 'ID'});

  Future<Either<AppException, Unit>> playPause(String zoneId) =>
      command('Playback/PlayPause', params: {'Zone': zoneId, 'ZoneType': 'ID'});

  Future<Either<AppException, Unit>> stop(String zoneId) =>
      command('Playback/Stop', params: {'Zone': zoneId, 'ZoneType': 'ID'});

  Future<Either<AppException, Unit>> stopAll() => command('Playback/StopAll');

  Future<Either<AppException, Unit>> next(String zoneId) =>
      command('Playback/Next', params: {'Zone': zoneId, 'ZoneType': 'ID'});

  Future<Either<AppException, Unit>> previous(String zoneId) =>
      command('Playback/Previous', params: {'Zone': zoneId, 'ZoneType': 'ID'});

  // -------------------------------------------------------------------------
  // Seek, volume, mute
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> setPosition(
    String zoneId,
    int positionMs,
  ) => command(
    'Playback/Position',
    params: {
      'Zone': zoneId,
      'ZoneType': 'ID',
      'Position': positionMs.toString(),
      'Mode': 'ms',
    },
  );

  Future<Either<AppException, Unit>> setVolume(String zoneId, double level) =>
      command(
        'Playback/Volume',
        params: {
          'Zone': zoneId,
          'ZoneType': 'ID',
          'Level': level.toStringAsFixed(3),
        },
      );

  Future<Either<AppException, Unit>> setMute(
    String zoneId, {
    required bool mute,
  }) => command(
    'Playback/Mute',
    params: {'Zone': zoneId, 'ZoneType': 'ID', 'Set': mute ? '1' : '0'},
  );

  // -------------------------------------------------------------------------
  // Shuffle & repeat
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> setShuffle(
    String zoneId,
    ShuffleMode mode,
  ) => command(
    'Playback/Shuffle',
    params: {'Zone': zoneId, 'Mode': mode.toMcws()},
  );

  Future<Either<AppException, Unit>> setRepeat(
    String zoneId,
    RepeatMode mode,
  ) => command(
    'Playback/Repeat',
    params: {'Zone': zoneId, 'Mode': mode.toMcws()},
  );

  // -------------------------------------------------------------------------
  // Playing Now queue
  // -------------------------------------------------------------------------

  Future<Either<AppException, List<PlayingNowItem>>> getPlayingNow(
    String zoneId,
  ) async {
    // The Fields parameter uses semicolons as delimiters. Dio percent-encodes
    // semicolons (%3B) in queryParameters, which MCWS does not recognise.
    // Embed Fields (and other static params) directly in the path so they are
    // never re-encoded; only the dynamic zoneId goes through queryParameters.
    try {
      final response = await _dio.get<String>(
        'Playback/Playlist?Action=JSON&ResponseFormat=JSON&ZoneType=ID',
        queryParameters: {'Zone': zoneId},
        options: Options(responseType: ResponseType.plain),
      );
      final body = response.data;
      if (body == null) {
        return left(
          const AppException.parseError(details: 'Empty playlist response'),
        );
      }
      final decoded = jsonDecode(body);
      List<dynamic> raw;
      if (decoded is List) {
        raw = decoded;
      } else if (decoded is Map) {
        final mpl = decoded['MPL'];
        final resp = decoded['Response'];
        if (mpl is Map && mpl['Item'] is List) {
          raw = mpl['Item'] as List<dynamic>;
        } else if (resp is Map && resp['Item'] is List) {
          raw = resp['Item'] as List<dynamic>;
        } else if (decoded['Item'] is List) {
          raw = decoded['Item'] as List<dynamic>;
        } else {
          raw = [];
        }
      } else {
        raw = [];
      }

      final items = raw.indexed.map((entry) {
        final (i, item) = entry;
        final map = item as Map<String, dynamic>;

        // Extract fields from either a flat map or the [{Name, Value}, ...] structure
        String? getValue(String name) {
          if (map.containsKey(name)) return map[name]?.toString();
          final fields = map['Field'] as List<dynamic>?;
          if (fields != null) {
            for (final f in fields) {
              if (f is Map && f['Name'] == name) return f['Value']?.toString();
            }
          }
          return null;
        }

        return PlayingNowItem(
          index: i,
          fileKey: getValue('Key') ?? getValue('FileKey') ?? '0',
          name: getValue('Name') ?? '',
          artist: getValue('Artist') ?? '',
          album: getValue('Album') ?? '',
        );
      }).toList();
      return right(items);
    } on DioException catch (e) {
      return left(_mapDioException(e));
    } on FormatException catch (e) {
      return left(
        AppException.parseError(details: 'Invalid playlist JSON: $e'),
      );
    } on TypeError catch (e) {
      return left(
        AppException.parseError(
          details: 'Playlist response is not in the expected MPL JSON format: $e',
        ),
      );
    }
  }

  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index) =>
      command(
        'Playback/PlayByIndex',
        params: {'Zone': zoneId, 'Index': index.toString()},
      );

  Future<Either<AppException, Unit>> removeFromQueue(
    String zoneId,
    int index,
  ) => command(
    'Playback/EditPlaylist',
    params: {'Zone': zoneId, 'Action': 'Remove', 'Source': index.toString()},
  );

  Future<Either<AppException, Unit>> moveInQueue(
    String zoneId,
    int source,
    int target,
  ) => command(
    'Playback/EditPlaylist',
    params: {
      'Zone': zoneId,
      'Action': 'Move',
      'Source': source.toString(),
      'Target': target.toString(),
    },
  );

  Future<Either<AppException, Unit>> clearQueue(String zoneId) => command(
    'Playback/ClearPlaylist',
    params: {'Zone': zoneId, 'ZoneType': 'ID'},
  );

  // -------------------------------------------------------------------------
  // Error mapping
  // -------------------------------------------------------------------------

  AppException _mapDioException(DioException e) {
    if (e.error is AppException) return e.error! as AppException;
    return switch (e.type) {
      DioExceptionType.connectionError || DioExceptionType.connectionTimeout =>
        AppException.connectionRefused(address: e.requestOptions.baseUrl),
      DioExceptionType.receiveTimeout || DioExceptionType.sendTimeout =>
        AppException.timeout(address: e.requestOptions.baseUrl),
      _ =>
        e.response?.statusCode == 401
            ? const AppException.unauthorized()
            : AppException.unknown(error: e),
    };
  }
}
