import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

/// Builds a Dio for unauthenticated public endpoints (e.g. the JRiver
/// access-key lookup service). No auth interceptor — only logging.
///
/// HTTPS connections to self-signed servers (JRiver MC's SSL port) are
/// handled by the global `JRiverHttpOverrides` rather than per-Dio
/// configuration; callers must register the host via
/// `JRiverHttpOverrides.instance.trustHost(...)` before issuing requests.
Dio createPublicDio({String baseUrl = '', required Talker talker}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  dio.interceptors.add(LoggingInterceptor(talker));
  return dio;
}

/// Builds a Dio bound to a session-scoped MCWS host: same as
/// [createPublicDio] plus an [AuthInterceptor] that appends the Token query
/// param.
Dio createDio({
  required String baseUrl,
  required String? Function() tokenGetter,
  required Talker talker,
}) {
  final dio = createPublicDio(baseUrl: baseUrl, talker: talker);
  // Auth runs before logging so the Token is present on the request the
  // logging interceptor records (and then redacts).
  dio.interceptors.insert(0, AuthInterceptor(tokenGetter));
  return dio;
}
