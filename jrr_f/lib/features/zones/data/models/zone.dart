import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';

@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String name,
    required String guid,
    required bool isDLNA,
    @Default(false) bool isLocal,
    @Default(false) bool isOffline,
    @Default(false) bool isAndroidAuto,
  }) = _Zone;

  static const offline = Zone(
    id: 'offline',
    name: 'Offline',
    guid: 'offline-zone-guid',
    isDLNA: false,
    isLocal: false,
    isOffline: true,
  );

  static const local = Zone(
    id: 'local',
    name: 'Local',
    guid: 'local-zone-guid',
    isDLNA: false,
    isLocal: true,
  );

  static const androidAuto = Zone(
    id: 'android-auto',
    name: 'Android Auto',
    guid: 'android-auto-zone-guid',
    isDLNA: false,
    isAndroidAuto: true,
  );
}
