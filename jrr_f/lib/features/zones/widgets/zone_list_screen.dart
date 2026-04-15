import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/router/navigation_notifier.dart';
import '../providers/active_zone_provider.dart';
import '../providers/zone_provider.dart';
import 'zone_tile.dart';

@RoutePage()
class ZoneListScreen extends ConsumerWidget {
  const ZoneListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesState = ref.watch(zoneListProvider);
    final activeZone = ref.watch(activeZoneProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zones'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => ref.read(navigationProvider.notifier).pop(),
        ),
      ),
      body: zonesState.when(
        data: (zones) => ListView.builder(
          itemCount: zones.length,
          itemBuilder: (_, i) {
            final zone = zones[i];
            return ZoneTile(
              zone: zone,
              isSelected: activeZone?.id == zone.id,
              onTap: () {
                ref.read(activeZoneProvider.notifier).setZone(zone);
                ref.read(navigationProvider.notifier).pop();
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 8),
              Text('$e'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(zoneListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
