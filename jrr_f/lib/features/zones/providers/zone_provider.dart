import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import '../data/repositories/zone_repository.dart';

part 'zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ZoneList extends _$ZoneList {
  @override
  Future<List<Zone>> build() async {
    final result = await getIt<ZoneRepository>().getZones();
    return result.getOrElse((e) => throw e);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await getIt<ZoneRepository>().getZones();
      return result.getOrElse((e) => throw e);
    });
  }
}
