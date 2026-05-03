import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_theme.dart';
import '../../features/library/data/models/track.dart';
import '../../features/library/data/models/tracks.dart';
import '../../features/player/providers/player_provider.dart';

class TrackRow extends ConsumerStatefulWidget {
  final Track track;
  final int index;

  const TrackRow({required this.track, required this.index, super.key});

  @override
  ConsumerState<TrackRow> createState() => _TrackRowState();
}

class _TrackRowState extends ConsumerState<TrackRow> {
  bool _expanded = false;

  String _formatDuration(double seconds) {
    final total = seconds.round();
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final track = widget.track;
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _expanded = !_expanded),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${widget.index}',
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
                        track.name.isNotEmpty ? track.name : 'Unknown',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.text,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_expanded)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            [
                              track.artist,
                              track.album,
                              track.dateReadable,
                            ].where((s) => s.isNotEmpty).join(' \u00b7 '),
                            style: AppTextStyles.itemSubtitle,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDuration(track.duration),
                      style: AppTextStyles.monoLabel,
                    ),
                    if (_expanded && track.bitrate > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _formatBitrate(track),
                          style: AppTextStyles.accentSmall,
                        ),
                      ),
                  ],
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 18,
                    color: AppColors.text3,
                  ),
                  padding: EdgeInsets.zero,
                  onSelected: (action) {
                    if (action == 'play') _play(track);
                    if (action == 'playNext') _playNext(track);
                    if (action == 'add') _addToQueue(track);
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'play',
                      child: ListTile(
                        leading: Icon(Icons.play_arrow_outlined),
                        title: Text('Play'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'playNext',
                      child: ListTile(
                        leading: Icon(Icons.queue_play_next),
                        title: Text('Play next'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'add',
                      child: ListTile(
                        leading: Icon(Icons.add_circle_outline),
                        title: Text('Add to playing now'),
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatBitrate(Track track) {
    if (track.bitDepth > 0 && track.sampleRate > 0) {
      final sr = track.sampleRate >= 1000
          ? '${(track.sampleRate / 1000).round()}'
          : '${track.sampleRate}';
      return 'FLAC ${track.bitDepth}/$sr';
    }
    return '${track.bitrate} kbps';
  }

  void _play(Track track) {
    ref.read(playerProvider.notifier).playNow(Tracks(tracks: [track]));
  }

  void _playNext(Track track) {
    ref.read(playerProvider.notifier).playNext(Tracks(tracks: [track]));
  }

  void _addToQueue(Track track) {
    ref.read(playerProvider.notifier).addToQueue(Tracks(tracks: [track]));
  }
}
