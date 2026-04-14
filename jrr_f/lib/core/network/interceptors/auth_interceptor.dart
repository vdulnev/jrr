import 'package:dio/dio.dart';
import '../../error/app_exception.dart';

class AuthInterceptor extends Interceptor {
  final String? Function() _tokenGetter;

  AuthInterceptor(this._tokenGetter);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra['skipAuth'] == true) {
      handler.next(options);
      return;
    }
    final token = _tokenGetter();
    if (token == null) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: const AppException.unauthorized(),
          type: DioExceptionType.cancel,
        ),
        true,
      );
      return;
    }
    options.queryParameters['Token'] = token;
    handler.next(options);
  }
}
