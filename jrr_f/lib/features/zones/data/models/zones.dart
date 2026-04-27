import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';

part 'zones.freezed.dart';

@freezed
abstract class Zones with _$Zones {
  const factory Zones({required List<Zone> zones}) = _Zones;
}
