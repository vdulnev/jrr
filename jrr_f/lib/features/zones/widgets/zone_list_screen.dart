import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/providers/player_provider.dart';
import '../data/models/zone.dart';
import '../providers/active_zone_provider.dart';
import '../providers/zone_provider.dart';
import 'volume_knob.dart';

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
                  Text(
                    'OUTPUT',
                    style: TextStyle(
                      fontFamily: AppFonts.mono,
                      fontSize: 9,
                      letterSpacing: 3,
                      color: AppColors.accent,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Zones',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            // Volume knob for active zone
            if (activeZone != null) _VolumeSection(zone: activeZone),
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

class _VolumeSection extends ConsumerWidget {
  final Zone zone;

  const _VolumeSection({required this.zone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerState = ref.watch(playerProvider);
    final volume = playerState.asData?.value.volume ?? 0.0;
    final isMuted = playerState.asData?.value.isMuted ?? false;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: AppColors.bg2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line2),
        ),
        child: Column(
          children: [
            Text(
              zone.name,
              style: const TextStyle(
                fontFamily: AppFonts.mono,
                fontSize: 10,
                letterSpacing: 1,
                color: AppColors.text3,
              ),
            ),
            const SizedBox(height: 12),
            VolumeKnob(
              value: isMuted ? 0.0 : volume,
              onChanged: (v) => ref.read(playerProvider.notifier).setVolume(v),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => ref.read(playerProvider.notifier).toggleMute(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isMuted
                        ? Icons.volume_off_rounded
                        : Icons.volume_up_rounded,
                    size: 16,
                    color: isMuted ? AppColors.accent : AppColors.text3,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMuted ? 'Muted' : '${(volume * 100).round()}%',
                    style: TextStyle(
                      fontFamily: AppFonts.mono,
                      fontSize: 11,
                      color: isMuted ? AppColors.accent : AppColors.text3,
                    ),
                  ),
                ],
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  if (zone.isDLNA)
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text(
                        'DLNA',
                        style: TextStyle(
                          fontFamily: AppFonts.mono,
                          fontSize: 10,
                          color: AppColors.text3,
                        ),
                      ),
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
