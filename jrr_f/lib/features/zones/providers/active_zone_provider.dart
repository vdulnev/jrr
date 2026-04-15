import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/models/zone.dart';

part 'active_zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ActiveZone extends _$ActiveZone {
  @override
  Zone? build() => null;

  void setZone(Zone zone) => state = zone;
  void clear() => state = null;
}
