import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/zone.dart';
import '../data/repositories/zone_repository.dart';

part 'zone_provider.g.dart';

@Riverpod(keepAlive: true)
class ZoneList extends _$ZoneList {
  @override
  Future<List<Zone>> build() async {
    final session = ref.watch(sessionProvider);
    if (session is Authenticated) {
      final result = await getIt<ZoneRepository>().getZones();
      return result.getOrElse(
        (e) => throw e,
      ); // Try to refresh zones when session becomes available.
    } else {
      // If session is not authenticated, clear the zones list.
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final result = await getIt<ZoneRepository>().getZones();
      return result.getOrElse((e) => throw e);
    });
  }
}
