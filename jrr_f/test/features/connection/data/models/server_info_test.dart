import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/connection/data/models/server_info.dart';

void main() {
  group('ServerInfo', () {
    test('exposes constructor fields', () {
      const info = ServerInfo(
        id: 'srv-1',
        name: 'Home',
        version: '32.0.1',
        platform: 'Windows',
        address: '192.168.1.10:52199',
      );
      expect(info.id, 'srv-1');
      expect(info.name, 'Home');
      expect(info.version, '32.0.1');
      expect(info.platform, 'Windows');
      expect(info.address, '192.168.1.10:52199');
    });

    test('offline constant carries empty address and offline id', () {
      expect(ServerInfo.offline.id, 'offline');
      expect(ServerInfo.offline.name, 'Offline Mode');
      expect(ServerInfo.offline.address, isEmpty);
      expect(ServerInfo.offline.version, 'none');
      expect(ServerInfo.offline.platform, 'none');
    });

    test('equality compares by value', () {
      const a = ServerInfo(
        id: 'a',
        name: 'A',
        version: '1',
        platform: 'p',
        address: '',
      );
      const b = ServerInfo(
        id: 'a',
        name: 'A',
        version: '1',
        platform: 'p',
        address: '',
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when address differs', () {
      const a = ServerInfo(
        id: 'a',
        name: 'A',
        version: '1',
        platform: 'p',
        address: '10.0.0.1',
      );
      const b = ServerInfo(
        id: 'a',
        name: 'A',
        version: '1',
        platform: 'p',
        address: '10.0.0.2',
      );
      expect(a, isNot(equals(b)));
    });
  });
}
