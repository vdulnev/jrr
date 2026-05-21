import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/models/auth_result.dart';

void main() {
  group('AuthResult', () {
    test('exposes token from constructor', () {
      const result = AuthResult(token: 'abc123');
      expect(result.token, 'abc123');
    });

    test('value equality holds for identical token', () {
      const a = AuthResult(token: 'tok');
      const b = AuthResult(token: 'tok');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when token differs', () {
      const a = AuthResult(token: 'tok');
      const b = AuthResult(token: 'other');
      expect(a, isNot(equals(b)));
    });

    test('copyWith replaces token', () {
      const a = AuthResult(token: 'tok');
      final b = a.copyWith(token: 'fresh');
      expect(b.token, 'fresh');
      expect(a.token, 'tok');
    });
  });
}
