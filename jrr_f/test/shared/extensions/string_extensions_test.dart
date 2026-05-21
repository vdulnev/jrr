import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/shared/extensions/string_extensions.dart';

void main() {
  group('StringExtensions.equalsIgnoreCase', () {
    test('returns true for equal strings regardless of case', () {
      expect('ABC'.equalsIgnoreCase('abc'), isTrue);
      expect('MiXeD'.equalsIgnoreCase('mixed'), isTrue);
      expect(''.equalsIgnoreCase(''), isTrue);
    });

    test('returns false when content differs', () {
      expect('abc'.equalsIgnoreCase('abcd'), isFalse);
      expect('abc'.equalsIgnoreCase('abd'), isFalse);
      expect('a'.equalsIgnoreCase(''), isFalse);
    });

    test('handles unicode case folding via toLowerCase', () {
      expect('Ä'.equalsIgnoreCase('ä'), isTrue);
    });
  });
}
