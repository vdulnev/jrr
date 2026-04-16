import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:retrofit/retrofit.dart';

part 'mcws_api.g.dart';

@RestApi(baseUrl: '', parser: Parser.FlutterCompute)
abstract class McwsApi {
  factory McwsApi(Dio dio, {String baseUrl}) = _McwsApi;

  @GET('Playback/Playlist')
  Future<List<Track>> getPlayingNow(
    @Query('Action') String action,
    @Query('ZoneType') String zoneType,
    @Query('Zone') String zoneId,
  );
}

List<Track> deserializeTrackList(List<dynamic> list) =>
    list.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList();

