import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

Dio createDio({
  required String baseUrl,
  required String? Function() tokenGetter,
  required Talker talker,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'text/xml'},
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(tokenGetter),
    LoggingInterceptor(talker),
  ]);
  return dio;
}
