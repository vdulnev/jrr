import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/player_provider.dart';

class SeekBar extends ConsumerStatefulWidget {
  final int positionMs;
  final int durationMs;
  final String positionDisplay;

  const SeekBar({
    super.key,
    required this.positionMs,
    required this.durationMs,
    required this.positionDisplay,
  });

  @override
  ConsumerState<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends ConsumerState<SeekBar> {
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final duration = widget.durationMs > 0 ? widget.durationMs : 1;
    final value = (_dragging ?? widget.positionMs / duration).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value,
              onChanged: (v) => setState(() => _dragging = v),
              onChangeEnd: (v) {
                setState(() => _dragging = null);
                final targetMs = (v * widget.durationMs).round();
                ref.read(playerProvider.notifier).seekTo(targetMs);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.positionDisplay,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                Text(
                  _msToDisplay(widget.durationMs),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _msToDisplay(int ms) {
    if (ms <= 0) return '0:00';
    final total = ms ~/ 1000;
    final m = total ~/ 60;
    final s = total % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}
