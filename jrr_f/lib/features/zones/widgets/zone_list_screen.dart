import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../data/models/zone.dart';
import '../providers/active_zone_provider.dart';
import '../providers/zone_provider.dart';

@RoutePage()
class ZoneListScreen extends ConsumerWidget {
  const ZoneListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zonesState = ref.watch(zoneListProvider);
    final activeZone = ref.watch(activeZoneProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OUTPUT', style: AppTextStyles.sectionLabel),
                  SizedBox(height: 6),
                  Text('Zones', style: AppTextStyles.screenTitle),
                ],
              ),
            ),
            // Zone list
            Expanded(
              child: zonesState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(zoneListProvider),
                ),
                data: (zones) => ListView.builder(
                  padding: const EdgeInsets.only(bottom: 148),
                  itemCount: zones.length,
                  itemBuilder: (_, i) {
                    final zone = zones[i];
                    final isActive = activeZone?.id == zone.id;
                    return _ZoneTile(
                      zone: zone,
                      isActive: isActive,
                      onTap: () =>
                          ref.read(activeZoneProvider.notifier).setZone(zone),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneTile extends StatelessWidget {
  final Zone zone;
  final bool isActive;
  final VoidCallback onTap;

  const _ZoneTile({
    required this.zone,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentDim : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isActive
                    ? AppColors.accent.withValues(alpha: 0.15)
                    : AppColors.bg3,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                zone.isDLNA ? Icons.cast_rounded : Icons.speaker_rounded,
                size: 20,
                color: isActive ? AppColors.accent : AppColors.text3,
              ),
            ),
            const SizedBox(width: 14),
            // Name + badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name,
                    style: AppTextStyles.itemTitle.copyWith(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (zone.isDLNA)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('DLNA', style: AppTextStyles.monoLabel),
                    ),
                ],
              ),
            ),
            // Active indicator
            if (isActive)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
