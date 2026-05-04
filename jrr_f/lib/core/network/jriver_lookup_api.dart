import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'jriver_lookup_api.g.dart';

/// Public JRiver registry hosted at webplay.jriver.com.
///
/// Unlike [McwsApi], this is not session-scoped: no auth, no MCWS host,
/// called before a session exists. Used to resolve a 6-character Access
/// Key to the registered server's host/port.
@RestApi(baseUrl: 'http://webplay.jriver.com/')
abstract class JRiverLookupApi {
  factory JRiverLookupApi(Dio dio, {String baseUrl}) = _JRiverLookupApi;

  @GET('libraryserver/lookup')
  Future<String> lookup(@Query('id') String id);
}
