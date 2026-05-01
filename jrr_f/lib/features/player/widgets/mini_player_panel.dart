import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/features/player/data/models/player_status.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../data/models/playback_state.dart';
import '../providers/player_provider.dart';
import '../../../shared/widgets/artwork_widget.dart';

class MiniPlayerPanel extends ConsumerWidget {
  final VoidCallback? onItemTap;

  const MiniPlayerPanel({this.onItemTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerStatus = ref.watch(playerProvider);
    final value = playerStatus.asData?.value;
    return Stack(
      children: [
        if (playerStatus.hasValue && value != null && value.fileKey >= 0)
          _Data(
            status: value,
            onItemTap: onItemTap,
            onPreviousTap: () => ref.read(playerProvider.notifier).previous(),
            onPlayPauseTap: () => ref.read(playerProvider.notifier).playPause(),
            onNextTap: () => ref.read(playerProvider.notifier).next(),
            onSetVolumeTap: (v) =>
                ref.read(playerProvider.notifier).setVolume(v),
            onMuteToggleTap: () =>
                ref.read(playerProvider.notifier).toggleMute(),
          ),
        if (playerStatus.isLoading) const _Loader(),
        if (playerStatus.hasError) const _Error(),
      ],
    );
  }
}

class _Data extends StatelessWidget {
  const _Data({
    required this.status,
    required this.onItemTap,
    required this.onPreviousTap,
    required this.onPlayPauseTap,
    required this.onNextTap,
    required this.onSetVolumeTap,
    required this.onMuteToggleTap,
  });

  final PlayerStatus status;
  final VoidCallback? onItemTap;
  final VoidCallback onPreviousTap;
  final VoidCallback onPlayPauseTap;
  final VoidCallback onNextTap;
  final ValueChanged<double> onSetVolumeTap;
  final VoidCallback onMuteToggleTap;

  @override
  Widget build(BuildContext context) {
    final isPlaying = status.state == PlaybackState.playing;
    final progress = status.durationMs > 0
        ? (status.positionMs / status.durationMs).clamp(0.0, 1.0)
        : 0.0;

    return GestureDetector(
      onTap: onItemTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bg3,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 32,
              offset: Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress bar
            SizedBox(
              height: 2,
              child: Stack(
                children: [
                  Container(color: AppColors.bg4),
                  FractionallySizedBox(
                    widthFactor: progress,
                    child: Container(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: ArtworkWidget(
                          imageUrl: status.imageUrl,
                          size: 40,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              status.name,
                              style: AppTextStyles.labelLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Text(
                              status.artist,
                              style: AppTextStyles.itemSubtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TransportButton(
                            size: 36,
                            onPressed: onPreviousTap,
                            child: const Icon(
                              Icons.skip_previous_rounded,
                              size: 20,
                            ),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: () => onPlayPauseTap,
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 20,
                            ),
                          ),
                          TransportButton(
                            size: 36,
                            onPressed: onNextTap,
                            child: const Icon(
                              Icons.skip_next_rounded,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  VolumeSlider(
                    value: status.volume,
                    isMuted: status.isMuted,
                    onChanged: onSetVolumeTap,
                    onMuteToggle: () => onMuteToggleTap,
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

class _Shell extends StatelessWidget {
  const _Shell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg3,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x99000000),
            blurRadius: 32,
            offset: Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(height: 64, child: Center(child: child)),
    );
  }
}

class _Loader extends StatelessWidget {
  const _Loader();

  @override
  Widget build(BuildContext context) {
    return const _Shell(
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.accent,
        ),
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error();

  @override
  Widget build(BuildContext context) {
    return const _Shell(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 20, color: AppColors.text2),
            SizedBox(width: 10),
            Flexible(
              child: Text(
                'Player unavailable',
                style: AppTextStyles.labelLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
