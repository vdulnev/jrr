import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

class LoggingInterceptor extends Interceptor {
  final Talker _talker;

  LoggingInterceptor(this._talker);

  static String _redact(Uri uri) {
    final params = Map<String, dynamic>.from(uri.queryParameters)
      ..update('Token', (_) => '***', ifAbsent: () => null);
    params.removeWhere((_, v) => v == null);
    return uri.replace(queryParameters: params).toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _talker.debug('→ ${options.method} ${_redact(options.uri)}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _talker.debug('← ${response.statusCode} ${_redact(response.realUri)}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _talker.error('✕ ${_redact(err.requestOptions.uri)}', err, err.stackTrace);
    handler.next(err);
  }
}
