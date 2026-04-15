import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/error/app_exception.dart';
import 'package:jrr_f/core/network/mcws_xml_parser.dart';

void main() {
  late McwsXmlParser parser;

  setUp(() => parser = McwsXmlParser());

  group('McwsXmlParser.parse', () {
    test('parses OK response with multiple items', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
  <Item Name="Token">abc123</Item>
  <Item Name="ReadOnly">0</Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) {
        expect(m['Token'], 'abc123');
        expect(m['ReadOnly'], '0');
      });
    });

    test('returns serverFailure for Failure status', () {
      const xml = '<Response Status="Failure" />';
      final result = parser.parse(xml);
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<ServerFailureException>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns parseError when Response element is missing', () {
      const xml = '<html><body>Not found</body></html>';
      final result = parser.parse(xml);
      expect(result.isLeft(), isTrue);
      result.fold(
        (e) => expect(e, isA<ParseErrorException>()),
        (_) => fail('expected Left'),
      );
    });

    test('handles empty item list', () {
      const xml = '<Response Status="OK"></Response>';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) => expect(m, isEmpty));
    });

    test('handles item values with special characters', () {
      const xml = '''
<Response Status="OK">
  <Item Name="Name">Beethoven &amp; Mozart</Item>
  <Item Name="Path">C:\\Music\\file.flac</Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) {
        expect(m['Name'], 'Beethoven &amp; Mozart');
        expect(m['Path'], r'C:\Music\file.flac');
      });
    });

    test('handles CDATA values', () {
      const xml = '''
<Response Status="OK">
  <Item Name="Name"><![CDATA[Song with CDATA]]></Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) {
        expect(m['Name'], 'Song with CDATA');
      });
    });

    test('handles multiline item values', () {
      const xml = '''
<Response Status="OK">
  <Item Name="Description">Line 1
Line 2</Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold(
        (_) => fail('expected Right'),
        (m) => expect(m['Description'], contains('Line 1')),
      );
    });

    test('parses Alive response fields', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
  <Item Name="RuntimeGUID">{GUID-1234}</Item>
  <Item Name="FriendlyName">My JRiver Server</Item>
  <Item Name="ProgramVersion">33.0.1</Item>
  <Item Name="Platform">Windows</Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) {
        expect(m['RuntimeGUID'], '{GUID-1234}');
        expect(m['FriendlyName'], 'My JRiver Server');
        expect(m['ProgramVersion'], '33.0.1');
        expect(m['Platform'], 'Windows');
      });
    });

    test('parses Playback/Info XML correctly (user regression)', () {
      const xml = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
<Item Name="ZoneID">0</Item>
<Item Name="State">1</Item>
<Item Name="FileKey">2302</Item>
<Item Name="Artist">ABBA</Item>
<Item Name="Album">Waterloo</Item>
<Item Name="Name">Waterloo</Item>
<Item Name="Status">Paused</Item>
</Response>
''';
      final result = parser.parse(xml);
      expect(result.isRight(), isTrue);
      result.fold((_) => fail('expected Right'), (m) {
        expect(m['ZoneID'], '0');
        expect(m['State'], '1');
        expect(m['FileKey'], '2302');
        expect(m['Artist'], 'ABBA');
        expect(m['Album'], 'Waterloo');
        expect(m['Name'], 'Waterloo');
      });
    });
  });

  group('McwsXmlParser.parseStatus', () {
    test('returns Right(void) for OK response', () {
      const xml = '<Response Status="OK" />';
      final result = parser.parseStatus(xml);
      expect(result.isRight(), isTrue);
    });

    test('returns Left for Failure response', () {
      const xml = '<Response Status="Failure" />';
      final result = parser.parseStatus(xml);
      expect(result.isLeft(), isTrue);
    });
  });
}
