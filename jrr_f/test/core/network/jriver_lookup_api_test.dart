import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/jriver_lookup_api.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
  });

  late MockDio dio;
  late JRiverLookupApi api;

  setUp(() {
    dio = MockDio();
    when(() => dio.options).thenReturn(BaseOptions());
    api = JRiverLookupApi(dio);
  });

  test('lookup hits libraryserver/lookup with id query param', () async {
    when(() => dio.fetch<String>(any())).thenAnswer(
      (_) async => Response(
        data: '<MCResponse Status="OK"/>',
        statusCode: 200,
        requestOptions: RequestOptions(path: ''),
      ),
    );

    final response = await api.lookup('ABCD12');

    expect(response, '<MCResponse Status="OK"/>');
    final captured =
        verify(() => dio.fetch<String>(captureAny())).captured.single
            as RequestOptions;
    expect(captured.path, 'libraryserver/lookup');
    expect(captured.queryParameters['id'], 'ABCD12');
    expect(captured.method, 'GET');
    // Defaults to the public registry host.
    expect(captured.baseUrl, contains('webplay.jriver.com'));
  });

  test('lookup propagates DioException on 4xx responses', () async {
    final req = RequestOptions(path: 'libraryserver/lookup');
    when(() => dio.fetch<String>(any())).thenThrow(
      DioException(
        requestOptions: req,
        response: Response(requestOptions: req, statusCode: 404),
        type: DioExceptionType.badResponse,
      ),
    );

    expect(
      () => api.lookup('NOPE12'),
      throwsA(
        isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          404,
        ),
      ),
    );
  });
}
