import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_result.freezed.dart';

@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult({
    required String token,
  }) = _AuthResult;
}
