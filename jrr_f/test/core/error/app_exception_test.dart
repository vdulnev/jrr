import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';

void main() {
  group('AppException', () {
    test('connectionRefused carries address', () {
      const ex = AppException.connectionRefused(address: '10.0.0.1:52199');
      expect(ex, isA<ConnectionRefusedException>());
      expect(ex, isA<Exception>());
      expect((ex as ConnectionRefusedException).address, '10.0.0.1:52199');
    });

    test('unauthorized is its own type', () {
      const ex = AppException.unauthorized();
      expect(ex, isA<UnauthorizedException>());
    });

    test('serverFailure carries message', () {
      const ex = AppException.serverFailure(message: 'oops');
      expect((ex as ServerFailureException).message, 'oops');
    });

    test('parseError carries details', () {
      const ex = AppException.parseError(details: 'bad xml');
      expect((ex as ParseErrorException).details, 'bad xml');
    });

    test('timeout carries address', () {
      const ex = AppException.timeout(address: '127.0.0.1');
      expect((ex as AppTimeoutException).address, '127.0.0.1');
    });

    test('database carries error', () {
      const ex = AppException.database(error: 'locked');
      expect((ex as DatabaseException).error, 'locked');
    });

    test('unknown wraps Object error', () {
      final inner = StateError('boom');
      final ex = AppException.unknown(error: inner);
      expect((ex as UnknownException).error, same(inner));
    });

    test('sealed switch covers every variant exhaustively', () {
      const variants = <AppException>[
        AppException.connectionRefused(address: 'a'),
        AppException.unauthorized(),
        AppException.serverFailure(message: 'm'),
        AppException.parseError(details: 'd'),
        AppException.timeout(address: 'a'),
        AppException.database(error: 'e'),
      ];
      for (final v in variants) {
        final label = switch (v) {
          ConnectionRefusedException() => 'cr',
          UnauthorizedException() => 'un',
          ServerFailureException() => 'sf',
          ParseErrorException() => 'pe',
          AppTimeoutException() => 'to',
          DatabaseException() => 'db',
          UnknownException() => 'uk',
        };
        expect(label, isNotEmpty);
      }
    });

    test('equality holds for identical variants', () {
      const a = AppException.connectionRefused(address: 'x');
      const b = AppException.connectionRefused(address: 'x');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('different variants are not equal', () {
      const a = AppException.unauthorized();
      const b = AppException.timeout(address: 'x');
      expect(a, isNot(equals(b)));
    });
  });
}
