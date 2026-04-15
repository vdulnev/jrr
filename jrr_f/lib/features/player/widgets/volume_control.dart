import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/player_status.dart';
import '../providers/player_provider.dart';

class VolumeControl extends ConsumerStatefulWidget {
  final PlayerStatus status;

  const VolumeControl({super.key, required this.status});

  @override
  ConsumerState<VolumeControl> createState() => _VolumeControlState();
}

class _VolumeControlState extends ConsumerState<VolumeControl> {
  double? _dragging;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(playerProvider.notifier);
    final vol = _dragging ?? widget.status.volume;
    final isMuted = widget.status.isMuted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: Icon(isMuted ? Icons.volume_off : Icons.volume_down),
            onPressed: notifier.toggleMute,
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              ),
              child: Slider(
                value: vol.clamp(0.0, 1.0),
                onChanged: (v) => setState(() => _dragging = v),
                onChangeEnd: (v) {
                  setState(() => _dragging = null);
                  notifier.setVolume(v);
                },
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => notifier.setVolume((vol + 0.05).clamp(0.0, 1.0)),
          ),
        ],
      ),
    );
  }
}
