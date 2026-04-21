import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../core/theme/app_theme.dart';
import '../../features/library/data/models/track.dart';
import '../../features/library/data/repositories/library_repository.dart';
import '../../features/player/providers/player_provider.dart';
import '../../features/zones/providers/active_zone_provider.dart';
import 'action_chip_button.dart';

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
                    style: const TextStyle(
                      fontFamily: AppFonts.mono,
                      fontSize: 11,
                      color: AppColors.text3,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name.isNotEmpty ? track.name : 'Unknown',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.text3,
                            ),
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
                      style: const TextStyle(
                        fontFamily: AppFonts.mono,
                        fontSize: 10,
                        color: AppColors.text3,
                      ),
                    ),
                    if (_expanded && track.bitrate > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          _formatBitrate(track),
                          style: TextStyle(
                            fontFamily: AppFonts.mono,
                            fontSize: 9,
                            color: AppColors.accent.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          Container(
            padding: const EdgeInsets.fromLTRB(58, 0, 20, 10),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ActionChipButton(
                  label: '\u25b6 Play',
                  onTap: () => _play(track),
                ),
                ActionChipButton(
                  label: 'Play Next',
                  onTap: () => _playNext(track),
                ),
                ActionChipButton(
                  label: '+ Add to Playing Now',
                  onTap: () => _addToQueue(track),
                ),
              ],
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
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    getIt<LibraryRepository>().playNow(zone.id, [track.fileKey]);
    ref.read(playerProvider.notifier).refresh();
  }

  void _playNext(Track track) {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    getIt<LibraryRepository>().playNext(zone.id, [track.fileKey]);
    ref.read(playerProvider.notifier).refresh();
  }

  void _addToQueue(Track track) {
    final zone = ref.read(activeZoneProvider);
    if (zone == null) return;
    getIt<LibraryRepository>().addToQueue(zone.id, [track.fileKey]);
    ref.read(playerProvider.notifier).refresh();
  }
}
