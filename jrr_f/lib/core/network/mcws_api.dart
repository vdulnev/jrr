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
}
