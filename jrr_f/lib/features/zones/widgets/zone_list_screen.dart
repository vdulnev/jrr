import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../player/data/models/local_audio_quality.dart';
import '../../player/data/models/playback_state.dart';
import '../../player/providers/local_audio_quality_provider.dart';
import '../data/models/zone.dart';
import '../providers/zone_list_view_model.dart';

class ZoneListScreen extends ConsumerWidget {
  const ZoneListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(zoneListViewModelProvider);
    final vm = ref.read(zoneListViewModelProvider.notifier);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('OUTPUT', style: AppTextStyles.sectionLabel),
                        SizedBox(height: 6),
                        Text('Zones', style: AppTextStyles.screenTitle),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: vm.refresh,
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.text2,
                    tooltip: 'Refresh zones',
                  ),
                ],
              ),
            ),
            // Zone list
            Expanded(
              child: state.hasError
                  ? ErrorView(error: state.error!, onRetry: vm.refresh)
                  : state.isLoading
                  ? const LoadingView()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: state.zones!.zones.length,
                      itemBuilder: (_, i) {
                        final zone = state.zones!.zones[i];
                        final isActive = state.activeZone?.id == zone.id;
                        return _ZoneTile(
                          zone: zone,
                          isActive: isActive,
                          activePlaybackState: isActive
                              ? state.activePlaybackState
                              : null,
                          onTap: () => vm.setZone(zone),
                        );
                      },
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
  final PlaybackState? activePlaybackState;
  final VoidCallback onTap;

  const _ZoneTile({
    required this.zone,
    required this.isActive,
    required this.activePlaybackState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final state = activePlaybackState;
    final showPlayingIcon = isActive && state == PlaybackState.playing;
    final showPausedIcon = isActive && state == PlaybackState.paused;

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
                zone.isAndroidAuto
                    ? Icons.directions_car_rounded
                    : zone.isLocal
                    ? Icons.smartphone_rounded
                    : (zone.isDLNA
                          ? Icons.cast_rounded
                          : Icons.speaker_rounded),
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
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          zone.name,
                          style: AppTextStyles.itemTitle.copyWith(
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (showPlayingIcon || showPausedIcon) ...[
                        const SizedBox(width: 8),
                        Icon(
                          showPlayingIcon
                              ? Icons.play_arrow_rounded
                              : Icons.pause_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                      ],
                    ],
                  ),
                  if (zone.isDLNA || zone.isLocal || zone.isAndroidAuto)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(
                        children: [
                          Text(
                            zone.isAndroidAuto
                                ? 'ANDROID AUTO'
                                : zone.isLocal
                                ? 'LOCAL'
                                : 'DLNA',
                            style: AppTextStyles.monoLabel,
                          ),
                          // Audio-quality popup applies to any zone that
                          // streams through the local just_audio handler —
                          // Local and Android Auto.
                          if (zone.isLocal || zone.isAndroidAuto) ...[
                            const SizedBox(width: 6),
                            const Text('·', style: AppTextStyles.monoLabel),
                            const SizedBox(width: 6),
                            const _QualityPopup(),
                          ],
                        ],
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

/// `localAudioQualityPrefProvider` already exposes the selected quality
/// plus a `set` command, so it functions as this widget's view model.
/// No wrapper provider needed.
class _QualityPopup extends ConsumerWidget {
  const _QualityPopup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localAudioQualityPrefProvider);
    return PopupMenuButton<LocalAudioQuality>(
      tooltip: 'Audio quality',
      padding: EdgeInsets.zero,
      onSelected: (q) =>
          ref.read(localAudioQualityPrefProvider.notifier).set(q),
      itemBuilder: (_) => [
        for (final q in LocalAudioQuality.values)
          CheckedPopupMenuItem(
            value: q,
            checked: q == current,
            child: Text(q.label),
          ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(current.label, style: AppTextStyles.monoLabel),
          const Icon(Icons.arrow_drop_down, size: 16, color: AppColors.text3),
        ],
      ),
    );
  }
}
