import 'package:freezed_annotation/freezed_annotation.dart';

part 'zone.freezed.dart';

@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String name,
    required String guid,
    required bool isDLNA,
  }) = _Zone;
}
