import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../error/app_exception.dart';
import 'mcws_xml_parser.dart';

class McwsClient {
  final Dio _dio;
  final McwsXmlParser _parser;

  McwsClient({required Dio dio, required McwsXmlParser parser})
      : _dio = dio,
        _parser = parser;

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

  AppException _mapDioException(DioException e) {
    if (e.error is AppException) return e.error! as AppException;
    return switch (e.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout =>
        AppException.connectionRefused(
          address: e.requestOptions.baseUrl,
        ),
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        AppException.timeout(
          address: e.requestOptions.baseUrl,
        ),
      _ => e.response?.statusCode == 401
          ? const AppException.unauthorized()
          : AppException.unknown(error: e),
    };
  }
}
