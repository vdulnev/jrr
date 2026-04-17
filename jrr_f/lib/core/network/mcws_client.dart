import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../di/injection.dart';
import '../error/app_exception.dart';
import '../../features/library/data/models/album.dart';
import '../../features/library/data/models/track.dart';
import '../../features/player/data/models/playback_state.dart';
import '../../features/player/data/models/player_status.dart';
import '../../features/player/data/models/repeat_mode.dart';
import '../../features/player/data/models/shuffle_mode.dart';
import '../../features/zones/data/models/zone.dart';
import 'mcws_api.dart';
import 'mcws_xml_parser.dart';
import 'models/auth_result.dart';

class McwsClient {
  final Dio _dio;
  final McwsXmlParser _parser;
  final McwsApi _api;

  Talker get _talker => getIt<Talker>();

  McwsClient({required Dio dio, required McwsXmlParser parser})
    : _dio = dio,
      _parser = parser,
      _api = McwsApi(dio);

  String get baseUrl => _dio.options.baseUrl;

  Future<Either<AppException, T>> _request<T, R>(
    Future<R> Function() call,
    Either<AppException, T> Function(R) parser,
  ) async {
    try {
      final response = await call();
      return parser(response);
    } on DioException catch (e) {
      return left(_mapDioException(e));
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  Future<Either<AppException, Unit>> _command(Future<String> Function() call) =>
      _request(call, _parser.parseStatus);

  // -------------------------------------------------------------------------
  // Connection
  // -------------------------------------------------------------------------

  /// Authenticates via HTTP Basic auth. Returns the [AuthResult].
  Future<Either<AppException, AuthResult>> authenticate({
    required String username,
    required String password,
  }) async {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    return _request(
      () => _api.authenticate('Basic $credentials'),
      (resp) => _parser.parse(resp).flatMap((fields) {
        final token = fields['Token'];
        if (token == null) {
          return left(
            const AppException.parseError(
              details: 'Token missing from Authenticate response',
            ),
          );
        }
        return right(AuthResult(token: token));
      }),
    );
  }

  /// Calls Alive to verify server connectivity. Returns [Unit] on success.
  Future<Either<AppException, Unit>> alive() => _command(_api.alive);

  // -------------------------------------------------------------------------
  // Zones
  // -------------------------------------------------------------------------

  Future<Either<AppException, List<Zone>>> getZones() =>
      _request(
        _api.getZones,
        (responseStr) => _parser.parse(responseStr).map((fields) {
          final count = int.tryParse(fields['NumberZones'] ?? '');
          if (count == null) return []; // Or throw if strictly required

          final zones = <Zone>[];
          for (
            var i = 0;
            i < (int.tryParse(fields['NumberZones'] ?? '0') ?? 0);
            i++
          ) {
            final id = fields['ZoneID$i'];
            final name = fields['ZoneName$i'];
            final guid = fields['ZoneGUID$i'];
            if (id != null && name != null && guid != null) {
              zones.add(
                Zone(
                  id: id,
                  name: name,
                  guid: guid,
                  isDLNA: fields['ZoneDLNA$i'] == '1',
                ),
              );
            }
          }
          return zones;
        }),
      );

  Future<Either<AppException, Unit>> setActiveZone(String zoneId) =>
      _command(() => _api.setActiveZone(zoneId: zoneId));

  // -------------------------------------------------------------------------
  // Player info
  // -------------------------------------------------------------------------

  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(
    String zoneId,
  ) => _request(
    () => _api.getPlaybackInfo(zoneId: zoneId),
    (responseStr) => _parser.parse(responseStr).flatMap((fields) {
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
      Track? trackInfo;
      if (fileKey != null && fileKey.isNotEmpty && fileKey != '-1') {
        trackInfo = _trackFromMap(fields);
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
    }),
  );

  // -------------------------------------------------------------------------
  // Transport
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> play(String zoneId) =>
      _command(() => _api.play(zoneId: zoneId));

  Future<Either<AppException, Unit>> playPause(String zoneId) =>
      _command(() => _api.playPause(zoneId: zoneId));

  Future<Either<AppException, Unit>> stop(String zoneId) =>
      _command(() => _api.stop(zoneId: zoneId));

  Future<Either<AppException, Unit>> stopAll() => _command(_api.stopAll);

  Future<Either<AppException, Unit>> next(String zoneId) =>
      _command(() => _api.next(zoneId: zoneId));

  Future<Either<AppException, Unit>> previous(String zoneId) =>
      _command(() => _api.previous(zoneId: zoneId));

  // -------------------------------------------------------------------------
  // Seek, volume, mute
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> setPosition(
    String zoneId,
    int positionMs,
  ) => _command(
    () => _api.setPosition(zoneId: zoneId, position: positionMs.toString()),
  );

  Future<Either<AppException, Unit>> setVolume(String zoneId, double level) =>
      _command(
        () => _api.setVolume(zoneId: zoneId, level: level.toStringAsFixed(3)),
      );

  Future<Either<AppException, Unit>> setMute(
    String zoneId, {
    required bool mute,
  }) => _command(() => _api.setMute(zoneId: zoneId, set: mute ? '1' : '0'));

  // -------------------------------------------------------------------------
  // Shuffle & repeat
  // -------------------------------------------------------------------------

  Future<Either<AppException, Unit>> setShuffle(
    String zoneId,
    ShuffleMode mode,
  ) => _command(() => _api.setShuffle(zoneId: zoneId, mode: mode.toMcws()));

  Future<Either<AppException, Unit>> setRepeat(
    String zoneId,
    RepeatMode mode,
  ) => _command(() => _api.setRepeat(zoneId: zoneId, mode: mode.toMcws()));

  // -------------------------------------------------------------------------
  // Playing Now queue
  // -------------------------------------------------------------------------

  Future<Either<AppException, List<Track>>> getPlayingNow(String zoneId) async {
    return _request(
      () => _api.getPlayingNow(zoneId: zoneId),
      (List<Track> items) => right(items),
    );
  }

  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index) =>
      _command(() => _api.playByIndex(zoneId: zoneId, index: index.toString()));

  Future<Either<AppException, Unit>> removeFromQueue(
    String zoneId,
    int index,
  ) => _command(
    () => _api.editPlaylist(
      zoneId: zoneId,
      action: 'Remove',
      source: index.toString(),
    ),
  );

  Future<Either<AppException, Unit>> moveInQueue(
    String zoneId,
    int source,
    int target,
  ) => _command(
    () => _api.editPlaylist(
      zoneId: zoneId,
      action: 'Move',
      source: source.toString(),
      target: target.toString(),
    ),
  );

  Future<Either<AppException, Unit>> clearQueue(String zoneId) =>
      _command(() => _api.clearQueue(zoneId: zoneId));

  // -------------------------------------------------------------------------
  // Library browse & search
  // -------------------------------------------------------------------------

  Track _trackFromMap(Map<String, dynamic> itemMap) {
    // Extract fields from either a flat map or the [{Name, Value}, ...] structure
    String? getValue(String name) {
      if (itemMap.containsKey(name)) return itemMap[name]?.toString();
      final fields = itemMap['Field'] as List<dynamic>?;
      if (fields != null) {
        for (final f in fields) {
          if (f is Map && f['Name'] == name) return f['Value']?.toString();
        }
      }
      return null;
    }

    final fileKey = int.tryParse(getValue('Key') ?? getValue('FileKey') ?? '0') ?? 0;

    return Track(
      fileKey: fileKey,
      name: getValue('Name') ?? getValue('Title') ?? '',
      artist:
          getValue('Artist') ??
          getValue('Album Artist') ??
          getValue('AlbumArtist') ??
          '',
      album: getValue('Album') ?? '',
      genre: getValue('Genre') ?? '',
      duration: double.tryParse(getValue('Duration') ?? '0') ?? 0.0,
      trackNumber: int.tryParse(getValue('Track #') ?? '0') ?? 0,
      discNumber: int.tryParse(getValue('Disc #') ?? '0') ?? 0,
      totalDiscs: int.tryParse(getValue('Total Discs') ?? '0') ?? 0,
      imageUrl: getValue('ImageURL') ?? '',
      bitrate: int.tryParse(getValue('Bitrate') ?? '0') ?? 0,
      bitDepth:
          int.tryParse(getValue('Bit Depth') ?? getValue('BitDepth') ?? '0') ??
          0,
      sampleRate:
          int.tryParse(
            getValue('Sample Rate') ?? getValue('SampleRate') ?? '0',
          ) ??
          0,
      channels: int.tryParse(getValue('Channels') ?? '0') ?? 0,
      filePath: getValue('Filename') ?? getValue('Filename (path)') ?? '',
    );
  }

  /// URL-encodes a value for embedding inside an MCWS query expression.
  String _qv(String value) {
    _talker.debug('[McwsClient] Query value: "$value"');
    return Uri.encodeComponent(value);
  }

  Future<Either<AppException, List<Track>>> searchFiles(
    String query, {
    int startIndex = 0,
    int count = 100,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return right([]);

    final q = _qv(trimmed);
    // Note: MCWS requires these literal brackets. Retrofit/Dio might encode them,
    // which usually works for search queries but if it fails we may need a custom interceptor.
    final mcwsQuery =
        '[Media Type]=Audio ([Name] contains $q OR [Artist] contains $q OR [Album] contains $q)';

    return _request(
      () => _api.searchFiles(
        query: mcwsQuery,
        startIndex: startIndex,
        count: count,
      ),
      (items) => right(items..sort((a, b) => a.name.compareTo(b.name))),
    );
  }

  Future<Either<AppException, List<String>>> getArtists() =>
      _request(
        () => _api.getArtists(),
        (items) => right(
          items
              .map((track) => track.artist)
              .where((artist) => artist.isNotEmpty)
              .toList(),
        ),
      );

  Future<Either<AppException, List<Album>>> getAlbumsByArtist(
    String artist,
  ) {
    final query =
        '[Media Type]=Audio [Artist]=${_qv(artist)} ~limit=-1,1,[Album],[Filename (path)] ~sort=[Album]';

    return _request(
      () => _api.getAlbumsByArtist(query: query),
      (tracks) => right(
        tracks
            .map((track) {
              final albumName = track.album;
              if (albumName.isEmpty) return null;

              return Album(
                name: albumName,
                artist: track.artist,
                folderPath: track.folderPath,
              );
            })
            .whereType<Album>()
            .toList(),
      ),
    );
  }

  Future<Either<AppException, List<Track>>> getAlbumTracks(Album album) {
    final baseQuery =
        '[Media Type]=Audio [Album]=${_qv(album.name)} [Artist]=${_qv(album.artist)}';
    final query = album.folderPath.isNotEmpty
        ? '$baseQuery [Filename (path)]=${_qv(album.folderPath)}'
        : baseQuery;

    return _request(
      () => _api.getAlbumTracks(query: query),
      (tracks) => right(tracks),
    );
  }

  Future<Either<AppException, Unit>> playByKey(
    String zoneId,
    List<int> fileKeys, {
    String? location,
  }) => _command(
    () => _api.playByKey(
      zoneId: zoneId,
      key: fileKeys.join(','),
      location: location,
    ),
  );

  // -------------------------------------------------------------------------
  // Error mapping
  // -------------------------------------------------------------------------

  AppException _mapDioException(DioException e) {
    final error = e.error;
    if (error is AppException) return error;
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
