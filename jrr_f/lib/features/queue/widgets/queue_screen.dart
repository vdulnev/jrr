import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/vu_meter.dart';
import '../../player/providers/player_provider.dart';
import '../providers/queue_provider.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queueState = ref.watch(queueProvider);
    final currentIndex = ref.watch(playingNowPositionProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PLAYBACK', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Queue', style: AppTextStyles.screenTitle),
                      queueState.maybeWhen(
                        data: (items) => Text(
                          '${items.length} tracks',
                          style: AppTextStyles.monoLabel,
                        ),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // "Up Next" label
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text('UP NEXT', style: AppTextStyles.sectionHeading),
            ),
            // Queue list
            Expanded(
              child: queueState.when(
                loading: () => const LoadingView(),
                error: (e, _) => ErrorView(
                  error: e,
                  onRetry: () => ref.invalidate(queueProvider),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const _NoData();
                  }
                  return _Data(
                    tracks: items,
                    currentIndex: currentIndex,
                    onTap: (index) =>
                        ref.read(playerProvider.notifier).playByIndex(index),
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

class _Data extends StatelessWidget {
  const _Data({
    required this.tracks,
    required this.currentIndex,
    required this.onTap,
  });

  final Tracks tracks;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 148),
      itemCount: tracks.length,
      itemBuilder: (context, i) {
        final track = tracks[i];
        final isCurrent = i == currentIndex;
        return _Track(
          track: track,
          isCurrent: isCurrent,
          onTap: () => onTap(i),
          index: i,
        );
      },
    );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Queue is empty', style: AppTextStyles.emptyState),
    );
  }
}

class _Track extends StatelessWidget {
  final Track track;
  final bool isCurrent;
  final VoidCallback onTap;
  final int index;

  const _Track({
    required this.track,
    required this.isCurrent,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrent ? AppColors.accentDim : Colors.transparent,
          border: const Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Stack(
          children: [
            if (isCurrent)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2.5,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(left: isCurrent ? 8 : 0),
              child: Row(
                children: [
                  if (isCurrent)
                    const VUMeter(active: true)
                  else
                    SizedBox(
                      width: 24,
                      child: Text(
                        '${index + 1}',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.monoLabel,
                      ),
                    ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          track.name,
                          style: AppTextStyles.itemTitle.copyWith(
                            fontWeight: isCurrent
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          [
                            track.artist,
                            track.album,
                          ].where((s) => s.isNotEmpty).join(' \u00b7 '),
                          style: AppTextStyles.itemSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDuration(track.duration),
                    style: AppTextStyles.monoLabel,
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.drag_handle,
                    size: 16,
                    color: AppColors.text3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(double seconds) {
    final total = seconds.round();
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
