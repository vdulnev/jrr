import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

import '../error/app_exception.dart';
import '../../features/library/data/models/album.dart';
import '../../features/library/data/models/browse_item.dart';
import '../../features/library/data/models/track.dart';
import '../../features/library/data/models/tracks.dart';
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

  Future<Either<AppException, List<Zone>>> getZones() => _request(
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

  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(String zoneId) =>
      _request(
        () => _api.getPlaybackInfo(zoneId: zoneId),
        (responseStr) => _parser.parse(responseStr).flatMap((fields) {
          final volDisplay = fields['VolumeDisplay'] ?? '';

          return right(
            PlayerStatus(
              zoneId: fields['ZoneID'] ?? zoneId,
              zoneName: fields['ZoneName'] ?? '',
              fileKey: int.tryParse(fields['FileKey'] ?? '-1') ?? -1,
              state: PlaybackState.fromMcws(fields['State'] ?? '0'),
              positionMs: int.tryParse(fields['PositionMS'] ?? '0') ?? 0,
              durationMs: int.tryParse(fields['DurationMS'] ?? '0') ?? 0,
              positionDisplay: fields['PositionDisplay'] ?? '',
              volume: double.tryParse(fields['Volume'] ?? '0') ?? 0.0,
              volumeDisplay: volDisplay,
              isMuted: volDisplay.toLowerCase().contains('muted'),
              playingNowPosition:
                  int.tryParse(fields['PlayingNowPosition'] ?? '-1') ?? -1,
              playingNowTracks:
                  int.tryParse(fields['PlayingNowTracks'] ?? '0') ?? 0,
              playingNowPositionDisplay:
                  fields['PlayingNowPositionDisplay'] ?? '',
              playingNowChangeCounter:
                  int.tryParse(fields['PlayingNowChangeCounter'] ?? '0') ?? 0,
              name: fields['Name'] ?? '',
              artist: fields['Artist'] ?? '',
              album: fields['Album'] ?? '',
              imageUrl: fields['ImageURL'] ?? '',
              bitrate: int.tryParse(fields['Bitrate'] ?? '0') ?? 0,
              bitDepth: int.tryParse(fields['Bitdepth'] ?? '0') ?? 0,
              sampleRate: int.tryParse(fields['SampleRate'] ?? '0') ?? 0,
              channels: int.tryParse(fields['Channels'] ?? '0') ?? 0,
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

  Future<Either<AppException, Tracks>> getPlayingNow(String zoneId) async {
    return _request(
      () => _api.getPlayingNow(zoneId: zoneId),
      (List<Track> items) => right(Tracks(tracks: items)),
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

  Future<Either<AppException, Unit>> addToQueue(
    String zoneId,
    List<int> fileKeys, {
    int location = 0,
  }) => _command(
    () => _api.playByKey(
      zoneId: zoneId,
      key: fileKeys.join(','),
      location: location,
    ),
  );

  Future<Either<AppException, Unit>> clearQueue(String zoneId) =>
      _command(() => _api.clearQueue(zoneId: zoneId));

  static String _esc(String value) =>
      value.replaceAllMapped(RegExp(r'[\[\]()\-]'), (m) => '/${m[0]}');

  // -------------------------------------------------------------------------
  // Library browse & search
  // -------------------------------------------------------------------------

  Future<Either<AppException, Tracks>> searchFiles(
    String query, {
    int startIndex = 0,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return right(Tracks.empty);

    final term = _esc(trimmed);
    return _request(
      () => _api.filesSearch(
        query:
            '[Media Type]=Audio ([Name] contains $term OR [Artist] contains $term OR [Album] contains $term)',
        startIndex: startIndex,
      ),
      (items) => right(
        Tracks(tracks: items..sort((a, b) => a.name.compareTo(b.name))),
      ),
    );
  }

  Future<Either<AppException, Track?>> searchByFileKey(int fileKey) async {
    if (fileKey > 0) {
      return _request(
        () => _api.searchByFileKey(fileKey: fileKey),
        (tracks) => right(tracks.firstOrNull),
      );
    } else {
      return right(null);
    }
  }

  Future<Either<AppException, List<String>>> getArtists() => _request(
    () => _api.filesSearch(
      query: '[Media Type]=Audio ~limit=-1,1,[Artist] ~sort=[Artist]',
    ),
    (items) => right(
      items
          .map((track) => track.artist)
          .where((artist) => artist.isNotEmpty)
          .toList(),
    ),
  );

  Future<Either<AppException, List<Album>>> getAlbumsByArtist(
    String artist,
  ) => _request(
    () => _api.filesSearch(
      query:
          '[Media Type]=Audio [Artist]=[${_esc(artist)}] ~limit=-1,1,[Album],Expression={If(Math([Total Discs]>1|[Disc #]>1),FileParent([Filename (path)]),[Filename (path)])} ~sort=[Album]',
    ),
    (tracks) => right(
      tracks
          .where((t) => t.artist == artist && t.album.isNotEmpty)
          .map(Album.fromTrack)
          .toList(),
    ),
  );

  Future<Either<AppException, Tracks>> getAlbumTracks(Album album) {
    final base = '[Media Type]=Audio [Album]=[${_esc(album.name)}]';
    final query = album.folderPath.isNotEmpty
        ? '$base [Filename (path)]="${_esc(album.folderPath)}"'
        : base;
    return _request(
      () => _api.filesSearch(query: query),
      (tracks) => right(Tracks(tracks: tracks)),
    );
  }

  Future<Either<AppException, Tracks>> getTracksByFolder(String folderPath) =>
      _request(
        () => _api.filesSearch(
          query: '[Media Type]=Audio [Filename (path)]="${_esc(folderPath)}"',
        ),
        (tracks) => right(Tracks(tracks: tracks)),
      );

  Future<Either<AppException, List<Album>>> getRandomAlbums() => _request(
    () => _api.filesSearch(
      query:
          '[Media Type]=[Audio] ~limit=10,-1,[Album],[Filename (path)] ~n=10',
    ),
    (tracks) => right(tracks.map(Album.fromTrack).toList()),
  );

  // -------------------------------------------------------------------------
  // Browse tree
  // -------------------------------------------------------------------------

  Future<Either<AppException, List<BrowseItem>>> browseChildren(String id) =>
      _request(
        () => _api.browseChildren(id: id),
        (xml) => _parser
            .parse(xml)
            .map(
              (fields) => fields.entries
                  .map((e) => BrowseItem(name: e.key, id: e.value))
                  .toList(),
            ),
      );

  Future<Either<AppException, Tracks>> browseFiles(String id) => _request(
    () => _api.browseFiles(id: id),
    (items) => right(Tracks(tracks: items)),
  );

  Future<Either<AppException, Unit>> playByKey(
    String zoneId,
    List<int> fileKeys, {
    int? location,
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
