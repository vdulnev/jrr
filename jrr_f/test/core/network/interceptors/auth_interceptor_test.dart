import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/interceptors/auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class MockRequestHandler extends Mock implements RequestInterceptorHandler {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeDioException extends Fake implements DioException {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeDioException());
  });

  late MockRequestHandler handler;

  setUp(() {
    handler = MockRequestHandler();
  });

  test('injects Token query parameter when getter returns a value', () {
    final interceptor = AuthInterceptor(() => 'abc');
    final options = RequestOptions(path: '/x');
    interceptor.onRequest(options, handler);
    expect(options.queryParameters['Token'], 'abc');
    verify(() => handler.next(options)).called(1);
    verifyNever(() => handler.reject(any(), any()));
  });

  test('bypasses auth when extra["skipAuth"] is true', () {
    final interceptor = AuthInterceptor(() => 'abc');
    final options = RequestOptions(path: '/x', extra: {'skipAuth': true});
    interceptor.onRequest(options, handler);
    expect(options.queryParameters.containsKey('Token'), isFalse);
    verify(() => handler.next(options)).called(1);
  });

  test('rejects with unauthorized AppException when token is null', () {
    final interceptor = AuthInterceptor(() => null);
    final options = RequestOptions(path: '/x');
    interceptor.onRequest(options, handler);
    verifyNever(() => handler.next(any()));
    final captured =
        verify(() => handler.reject(captureAny(), true)).captured.single
            as DioException;
    expect(captured.type, DioExceptionType.cancel);
    expect(captured.error, isA<UnauthorizedException>());
    expect(captured.requestOptions, options);
  });
}
