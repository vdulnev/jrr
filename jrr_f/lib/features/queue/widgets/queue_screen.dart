import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/scroll_chrome_listener.dart';
import '../../../shared/widgets/vu_meter.dart';
import '../providers/queue_view_model.dart';

class QueueScreen extends ConsumerWidget {
  const QueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(queueViewModelProvider);
    final vm = ref.read(queueViewModelProvider.notifier);

    Future<void> onClearTap() => _confirmClear(context, vm);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ScrollChromeListener(
          child: state.hasError
              ? ErrorView(error: state.error!)
              : state.isLoading
              ? const LoadingView()
              : state.isEmpty
              ? _EmptyView(tracks: state.tracks, onClearTap: onClearTap)
              : _DataView(
                  items: state.tracks!,
                  currentIndex: state.currentIndex,
                  onTap: vm.playByIndex,
                  onRemove: vm.removeItem,
                  onClearTap: onClearTap,
                ),
        ),
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, QueueViewModel vm) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bg2,
        title: const Text('Clear queue?', style: AppTextStyles.subScreenTitle),
        content: const Text(
          'This will remove all tracks from the playing now queue.',
          style: AppTextStyles.itemSubtitle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await vm.clearQueue();
    }
  }
}

class _DataView extends StatelessWidget {
  const _DataView({
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.onRemove,
    required this.onClearTap,
  });

  final Tracks items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onRemove;

  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(tracks: items, onClearTap: onClearTap),
        ),
        const SliverToBoxAdapter(child: _UpNext()),
        _QueueSliverList(
          tracks: items,
          currentIndex: currentIndex,
          onTap: onTap,
          onRemove: onRemove,
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 16)),
      ],
    );
  }
}

class _UpNext extends StatelessWidget {
  const _UpNext();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Text('UP NEXT', style: AppTextStyles.sectionHeading),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.onClearTap, this.tracks});

  final VoidCallback onClearTap;
  final Tracks? tracks;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _Header(tracks: tracks, onClearTap: onClearTap),
        ),
        const SliverToBoxAdapter(child: _UpNext()),
        const SliverFillRemaining(hasScrollBody: false, child: _NoData()),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({this.tracks, required this.onClearTap});

  final Tracks? tracks;
  final VoidCallback onClearTap;

  @override
  Widget build(BuildContext context) {
    final tracks = this.tracks;
    return Padding(
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
              ...(tracks != null)
                  ? [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${tracks.length} tracks',
                            style: AppTextStyles.monoLabel,
                          ),
                          if (tracks.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _ClearButton(onPressed: onClearTap),
                          ],
                        ],
                      ),
                    ]
                  : [const SizedBox.shrink()],
            ],
          ),
        ],
      ),
    );
  }
}

class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_sweep_outlined, size: 16, color: AppColors.text2),
            SizedBox(width: 4),
            Text(
              'CLEAR',
              style: TextStyle(
                fontFamily: AppFonts.mono,
                fontSize: 11,
                letterSpacing: 1.5,
                color: AppColors.text2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QueueSliverList extends StatelessWidget {
  const _QueueSliverList({
    required this.tracks,
    required this.currentIndex,
    required this.onTap,
    required this.onRemove,
  });

  final Tracks tracks;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: tracks.length,
      itemBuilder: (context, i) {
        final track = tracks[i];
        final isCurrent = i == currentIndex;
        return _Track(
          key: ValueKey('${track.fileKey}_$i'),
          track: track,
          isCurrent: isCurrent,
          onTap: () => onTap(i),
          onDismissed: () => onRemove(i),
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
  final VoidCallback onDismissed;
  final int index;

  const _Track({
    required this.track,
    required this.isCurrent,
    required this.onTap,
    required this.onDismissed,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('dismiss_${track.fileKey}_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error.withValues(alpha: 0.18),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
          size: 20,
        ),
      ),
      onDismissed: (_) => onDismissed(),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
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
