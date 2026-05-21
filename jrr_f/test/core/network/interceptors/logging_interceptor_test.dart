import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/interceptors/logging_interceptor.dart';
import 'package:talker/talker.dart';

class _CapturingTalker extends Talker {
  final List<String> debugs = [];
  final List<String> errors = [];

  @override
  void debug([dynamic msg, Object? exception, StackTrace? stackTrace]) {
    debugs.add('$msg');
  }

  @override
  void error([dynamic msg, Object? exception, StackTrace? stackTrace]) {
    errors.add('$msg');
  }
}

class _NoopRequestHandler implements RequestInterceptorHandler {
  RequestOptions? options;
  @override
  void next(RequestOptions o) => options = o;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopResponseHandler implements ResponseInterceptorHandler {
  Response<dynamic>? response;
  @override
  void next(Response<dynamic> r) => response = r;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoopErrorHandler implements ErrorInterceptorHandler {
  DioException? error;
  @override
  void next(DioException e) => error = e;
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late _CapturingTalker talker;
  late LoggingInterceptor interceptor;

  setUp(() {
    talker = _CapturingTalker();
    interceptor = LoggingInterceptor(talker);
  });

  group('onRequest', () {
    test('redacts the Token query parameter when present', () {
      final options = RequestOptions(
        path: '/MCWS/v1/Alive',
        baseUrl: 'http://host:52199',
        queryParameters: {'Token': 'super-secret', 'Zone': '0'},
      );
      interceptor.onRequest(options, _NoopRequestHandler());
      expect(talker.debugs, hasLength(1));
      final msg = talker.debugs.single;
      expect(msg, contains('Token=%2A%2A%2A'));
      expect(msg, isNot(contains('super-secret')));
      expect(msg, contains('Zone=0'));
    });

    test('omits body when data is null', () {
      final options = RequestOptions(path: '/x');
      interceptor.onRequest(options, _NoopRequestHandler());
      final msg = talker.debugs.single;
      expect(msg.split('\n').length, 1);
    });

    test('pretty-prints JSON-string body', () {
      final options = RequestOptions(path: '/x', data: '{"a":1,"b":2}');
      interceptor.onRequest(options, _NoopRequestHandler());
      final msg = talker.debugs.single;
      expect(msg, contains('"a": 1'));
      expect(msg, contains('"b": 2'));
    });

    test('falls back to plain toString for non-JSON body', () {
      final options = RequestOptions(path: '/x', data: 'not-json');
      interceptor.onRequest(options, _NoopRequestHandler());
      expect(talker.debugs.single, contains('not-json'));
    });

    test('truncates long bodies and reports remaining line count', () {
      final body = List.generate(120, (i) => 'line-$i').join('\n');
      final options = RequestOptions(path: '/x', data: body);
      interceptor.onRequest(options, _NoopRequestHandler());
      final msg = talker.debugs.single;
      expect(msg, contains('line-0'));
      expect(msg, contains('line-79'));
      expect(msg, isNot(contains('line-80')));
      expect(msg, contains('... (40 more lines)'));
    });
  });

  group('onResponse', () {
    test('logs status code and redacts Token in realUri', () {
      final options = RequestOptions(
        path: '/MCWS/v1/Alive',
        baseUrl: 'http://host',
        queryParameters: {'Token': 'tok'},
      );
      final response = Response<dynamic>(
        requestOptions: options,
        statusCode: 200,
        data: null,
      );
      interceptor.onResponse(response, _NoopResponseHandler());
      final msg = talker.debugs.single;
      expect(msg, contains('200'));
      expect(msg, contains('Token=%2A%2A%2A'));
    });
  });

  group('onError', () {
    test('logs error with redacted URI and forwards', () {
      final options = RequestOptions(
        path: '/x',
        baseUrl: 'http://host',
        queryParameters: {'Token': 'tok'},
      );
      final err = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response<dynamic>(
          requestOptions: options,
          statusCode: 500,
          data: '{"e":"x"}',
        ),
      );
      final handler = _NoopErrorHandler();
      interceptor.onError(err, handler);
      expect(talker.errors, hasLength(1));
      expect(talker.errors.single, contains('Token=%2A%2A%2A'));
      expect(handler.error, same(err));
    });
  });
}
