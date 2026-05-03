import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

class LoggingInterceptor extends Interceptor {
  final Talker _talker;

  LoggingInterceptor(this._talker);

  static String _prettyBody(dynamic body) {
    if (body == null) return '';
    try {
      final decoded = body is String ? jsonDecode(body) : body;
      final pretty = const JsonEncoder.withIndent('  ').convert(decoded);
      return '\n${_limitLines(pretty)}';
    } catch (_) {
      return '\n${_limitLines(body.toString())}';
    }
  }

  static String _limitLines(String input, [int maxLines = 80]) {
    final lines = input.split('\n');
    if (lines.length <= maxLines) return input;
    return '${lines.take(maxLines).join('\n')}\n... (${lines.length - maxLines} more lines)';
  }

  static String _redact(Uri uri) {
    final params = Map<String, dynamic>.from(uri.queryParameters)
      ..update('Token', (_) => '***', ifAbsent: () => null);
    params.removeWhere((_, v) => v == null);
    return uri.replace(queryParameters: params).toString();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final body = options.data;
    final bodyStr = _prettyBody(body);
    _talker.debug('[dio] → ${options.method} ${_redact(options.uri)}$bodyStr');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final body = response.data;
    final bodyStr = _prettyBody(body);
    _talker.debug(
      '[dio] ← ${response.statusCode} ${_redact(response.realUri)}$bodyStr',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final body = err.response?.data;
    final bodyStr = _prettyBody(body);
    _talker.error(
      '[dio] ✕ ${_redact(err.requestOptions.uri)}$bodyStr',
      err,
      err.stackTrace,
    );
    handler.next(err);
  }
}
