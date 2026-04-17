import 'dart:collection';
import 'package:fpdart/fpdart.dart';
import '../error/app_exception.dart';

/// Parses MCWS XML responses.
/// MCWS returns either:
///   Response Status="OK" with Item Name="K" elements
///   Response Status="Failure"
class McwsXmlParser {
  static final _statusRe = RegExp(r'<Response\s+Status="([^"]*)"');
  static final _itemRe = RegExp(
    r'<Item\s+Name="([^"]*)"[^>]*>(?:<!\[CDATA\[([\s\S]*?)\]\]>|([\s\S]*?))</Item>',
  );

  /// Parses a full MCWS XML response string.
  /// Returns Right with a map of Name→value pairs, or Left with AppException.
  Either<AppException, Map<String, String>> parse(String xml) {
    final statusMatch = _statusRe.firstMatch(xml);
    if (statusMatch == null) {
      return left(
        const AppException.parseError(details: 'Missing Response element'),
      );
    }

    final status = statusMatch.group(1);
    if (status != 'OK') {
      return left(AppException.serverFailure(message: 'MCWS status: $status'));
    }

    final result = LinkedHashMap<String, String>(
      equals: (a, b) => a.toLowerCase() == b.toLowerCase(),
      hashCode: (key) => key.toLowerCase().hashCode,
    );
    for (final m in _itemRe.allMatches(xml)) {
      final name = m.group(1);
      if (name == null) continue;

      final cdataValue = m.group(2);
      final normalValue = m.group(3);
      result[name] = (cdataValue ?? normalValue ?? '').trim();
    }
    return right(result);
  }

  /// Extracts status only (for commands that return no Items).
  Either<AppException, Unit> parseStatus(String xml) {
    return parse(xml).map((_) => unit);
  }
}
