import 'dart:convert';

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
