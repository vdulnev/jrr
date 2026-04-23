import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
sealed class AppException with _$AppException implements Exception {
  const factory AppException.connectionRefused({required String address}) =
      ConnectionRefusedException;
  const factory AppException.unauthorized() = UnauthorizedException;
  const factory AppException.serverFailure({required String message}) =
      ServerFailureException;
  const factory AppException.parseError({required String details}) =
      ParseErrorException;
  const factory AppException.timeout({required String address}) =
      AppTimeoutException;
  const factory AppException.database({required String error}) =
      DatabaseException;
  const factory AppException.unknown({required Object error}) =
      UnknownException;
}
