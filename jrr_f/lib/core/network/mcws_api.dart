import 'package:dio/dio.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:retrofit/retrofit.dart';

part 'mcws_api.g.dart';

@RestApi(baseUrl: '')
abstract class McwsApi {
  factory McwsApi(Dio dio, {String baseUrl}) = _McwsApi;

  @GET('Playback/Playlist')
  Future<List<Track>> getPlayingNow(
    @Query('Action') String action,
    @Query('ZoneType') String zoneType,
    @Query('Zone') String zoneId,
  );
}
