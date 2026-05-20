import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/artwork_widget.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../providers/mini_player_view_model.dart';

class MiniPlayerPanel extends ConsumerWidget {
  final VoidCallback? onItemTap;

  const MiniPlayerPanel({this.onItemTap, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Skip the high-churn `progress` field here so the panel chrome doesn't
    // rebuild on every position tick. _ProgressBar subscribes to it
    // directly through the same VM provider.
    final state = ref.watch(
      miniPlayerViewModelProvider.select(
        (s) => (
          fileKey: s.fileKey,
          name: s.name,
          artist: s.artist,
          volume: s.volume,
          isMuted: s.isMuted,
          isPlaying: s.isPlaying,
          hasTracks: s.hasTracks,
        ),
      ),
    );
    final vm = ref.read(miniPlayerViewModelProvider.notifier);

    return _Data(
      state: state,
      onItemTap: onItemTap,
      onPreviousTap: state.hasTracks ? vm.previous : null,
      onPlayPauseTap: state.hasTracks ? vm.playPause : null,
      onNextTap: state.hasTracks ? vm.next : null,
      onSetVolumeTap: vm.setVolume,
      onMuteToggleTap: vm.toggleMute,
    );
  }
}

typedef _MiniPlayerSlice = ({
  int? fileKey,
  String name,
  String artist,
  double volume,
  bool isMuted,
  bool isPlaying,
  bool hasTracks,
});

class _Data extends StatelessWidget {
  const _Data({
    required this.state,
    required this.onItemTap,
    required this.onPreviousTap,
    required this.onPlayPauseTap,
    required this.onNextTap,
    required this.onSetVolumeTap,
    required this.onMuteToggleTap,
  });

  final _MiniPlayerSlice state;
  final VoidCallback? onItemTap;
  final VoidCallback? onPreviousTap;
  final VoidCallback? onPlayPauseTap;
  final VoidCallback? onNextTap;
  final ValueChanged<double> onSetVolumeTap;
  final VoidCallback onMuteToggleTap;

  @override
  Widget build(BuildContext context) {
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
            // Progress bar — its own ConsumerWidget so the position tick
            // doesn't rebuild the rest of the panel.
            SizedBox(
              height: 2,
              child: Stack(
                children: [
                  Container(color: AppColors.bg4),
                  const _ProgressBar(),
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
                        child: _Cover(fileKey: state.fileKey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _Name(name: state.name),
                            const SizedBox(height: 1),
                            _Artist(artist: state.artist),
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
                            onPressed: onPlayPauseTap,
                            child: _PlayIcon(isPlaying: state.isPlaying),
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
                  _Volume(
                    volume: state.volume,
                    isMuted: state.isMuted,
                    onSetVolumeTap: onSetVolumeTap,
                    onMuteToggleTap: onMuteToggleTap,
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

class _Volume extends StatelessWidget {
  const _Volume({
    required this.volume,
    required this.isMuted,
    required this.onSetVolumeTap,
    required this.onMuteToggleTap,
  });

  final double volume;
  final bool isMuted;
  final ValueChanged<double> onSetVolumeTap;
  final VoidCallback onMuteToggleTap;

  @override
  Widget build(BuildContext context) {
    return VolumeSlider(
      value: volume,
      isMuted: isMuted,
      onChanged: onSetVolumeTap,
      onMuteToggle: onMuteToggleTap,
    );
  }
}

class _PlayIcon extends StatelessWidget {
  const _PlayIcon({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      size: 20,
    );
  }
}

class _Artist extends StatelessWidget {
  const _Artist({required this.artist});

  final String artist;

  @override
  Widget build(BuildContext context) {
    return Text(
      artist,
      style: AppTextStyles.itemSubtitle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Name extends StatelessWidget {
  const _Name({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: AppTextStyles.labelLarge,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.fileKey});

  final int? fileKey;

  @override
  Widget build(BuildContext context) {
    return ArtworkWidget(fileKey: fileKey, size: 40);
  }
}

class _ProgressBar extends ConsumerWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      miniPlayerViewModelProvider.select((s) => s.progress),
    );
    return FractionallySizedBox(
      widthFactor: progress,
      child: Container(color: AppColors.accent),
    );
  }
}
