import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'mcws_api.g.dart';

@RestApi()
abstract class McwsApi {
  factory McwsApi(Dio dio, {String baseUrl}) = _McwsApi;

  @GET('Authenticate')
  @Extra({'skipAuth': true})
  Future<String> authenticate(@Header('Authorization') String basicAuth);

  @GET('Alive')
  @Extra({'skipAuth': true})
  Future<String> alive();

  @GET('Playback/Zones')
  Future<String> getZones();

  @GET('Playback/Info')
  Future<String> getPlaybackInfo({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/SetZone')
  Future<String> setActiveZone({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/Play')
  Future<String> play({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/PlayPause')
  Future<String> playPause({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/Stop')
  Future<String> stop({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/StopAll')
  Future<String> stopAll();

  @GET('Playback/Next')
  Future<String> next({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/Previous')
  Future<String> previous({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/Position')
  Future<String> setPosition({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
    @Query('Position') required String position,
    @Query('Mode') String mode = 'ms',
  });

  @GET('Playback/Volume')
  Future<String> setVolume({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
    @Query('Level') required String level,
  });

  @GET('Playback/Mute')
  Future<String> setMute({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
    @Query('Set') required String set,
  });

  @GET('Playback/Shuffle')
  Future<String> setShuffle({
    @Query('Zone') required String zoneId,
    @Query('Mode') required String mode,
  });

  @GET('Playback/Repeat')
  Future<String> setRepeat({
    @Query('Zone') required String zoneId,
    @Query('Mode') required String mode,
  });

  @GET('Playback/PlayByIndex')
  Future<String> playByIndex({
    @Query('Zone') required String zoneId,
    @Query('Index') required String index,
  });

  @GET('Playback/EditPlaylist')
  Future<String> editPlaylist({
    @Query('Zone') required String zoneId,
    @Query('Action') required String action,
    @Query('Source') required String source,
    @Query('Target') String? target,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/ClearPlaylist')
  Future<String> clearQueue({
    @Query('Zone') required String zoneId,
    @Query('ZoneType') String zoneType = 'ID',
  });

  @GET('Playback/PlayByKey')
  Future<String> playByKey({
    @Query('Zone') required String zoneId,
    @Query('Key') required String key,
    @Query('Location') String? location,
    @Query('ZoneType') String zoneType = 'ID',
  });
}
