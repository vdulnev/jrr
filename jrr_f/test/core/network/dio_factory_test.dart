import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/dio_factory.dart';
import 'package:jrr_f/core/network/interceptors/auth_interceptor.dart';
import 'package:jrr_f/core/network/interceptors/logging_interceptor.dart';
import 'package:talker/talker.dart';

void main() {
  late Talker talker;

  setUp(() {
    talker = Talker();
  });

  group('createPublicDio', () {
    test('applies base URL and timeout defaults', () {
      final dio = createPublicDio(baseUrl: 'http://example/', talker: talker);
      expect(dio.options.baseUrl, 'http://example/');
      expect(dio.options.connectTimeout, const Duration(seconds: 10));
      expect(dio.options.receiveTimeout, const Duration(seconds: 15));
    });

    test('attaches a LoggingInterceptor and no AuthInterceptor', () {
      final dio = createPublicDio(baseUrl: '', talker: talker);
      expect(dio.interceptors.whereType<LoggingInterceptor>(), hasLength(1));
      expect(dio.interceptors.whereType<AuthInterceptor>(), isEmpty);
    });

    test('defaults baseUrl to empty when not provided', () {
      final dio = createPublicDio(talker: talker);
      expect(dio.options.baseUrl, '');
    });
  });

  group('createDio', () {
    test('attaches both Auth and Logging interceptors', () {
      final dio = createDio(
        baseUrl: 'http://srv/',
        tokenGetter: () => 'tok',
        talker: talker,
      );
      expect(dio.options.baseUrl, 'http://srv/');
      expect(dio.interceptors.whereType<AuthInterceptor>(), hasLength(1));
      expect(dio.interceptors.whereType<LoggingInterceptor>(), hasLength(1));
    });

    test('runs Auth before Logging so the Token can be redacted', () {
      final dio = createDio(
        baseUrl: 'http://srv/',
        tokenGetter: () => null,
        talker: talker,
      );
      final auth = dio.interceptors.indexWhere((i) => i is AuthInterceptor);
      final log = dio.interceptors.indexWhere((i) => i is LoggingInterceptor);
      expect(auth, isNonNegative);
      expect(log, isNonNegative);
      expect(auth, lessThan(log));
    });
  });
}
