import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/artwork_widget.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../../zones/data/models/zone.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../providers/now_playing_view_model.dart';

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Skip the high-churn `positionMs` / `durationMs` fields at the screen
    // level so the position tick doesn't rebuild the entire subtree;
    // _ProgressSection subscribes to those directly through the same VM
    // provider. A record `.select` ensures we only rebuild on the
    // low-churn fields actually rendered here.
    final state = ref.watch(
      nowPlayingViewModelProvider.select(
        (s) => (
          activeZone: s.activeZone,
          fileKey: s.fileKey,
          dateReadable: s.track?.dateReadable,
          name: s.name,
          artist: s.artist,
          album: s.album,
          volume: s.volume,
          isMuted: s.isMuted,
          isPlaying: s.isPlaying,
          repeatMode: s.repeatMode,
          shuffleMode: s.shuffleMode,
          playingNowPosition: s.playingNowPosition,
          playingNowTracks: s.playingNowTracks,
          fileType: s.fileType,
          bitDepth: s.bitDepth,
          sampleRate: s.sampleRate,
        ),
      ),
    );
    final vm = ref.read(nowPlayingViewModelProvider.notifier);

    if (state.activeZone == null) {
      return const Scaffold(body: LoadingView());
    }
    if (state.fileKey < 0) {
      return _NowPlayingEmptyState(zone: state.activeZone!, vm: vm);
    }

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'NOW PLAYING',
                          style: AppTextStyles.sectionLabel,
                        ),
                        const SizedBox(height: 4),
                        _FormatQuality(
                          activeZoneName: state.activeZone!.name,
                          fileType: state.fileType,
                          bitDepth: state.bitDepth,
                          sampleRate: state.sampleRate,
                        ),
                      ],
                    ),
                  ),
                  _PlayingNowPosition(
                    position: state.playingNowPosition,
                    total: state.playingNowTracks,
                  ),
                ],
              ),
            ),

            // Album art
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxWidth: 280,
                        maxHeight: 280,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xCC000000),
                            blurRadius: 60,
                            offset: Offset(0, 16),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: ArtworkWidget(fileKey: state.fileKey, size: 280),
                    ),
                  ),
                ),
              ),
            ),

            // Track info + controls
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
              child: Column(
                children: [
                  // Track info
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TrackTitle(name: state.name),
                        const SizedBox(height: 3),
                        _TrackArtist(artist: state.artist),
                        const SizedBox(height: 2),
                        _TrackAlbumLine(
                          album: state.album,
                          dateReadable: state.dateReadable,
                        ),
                      ],
                    ),
                  ),

                  // Progress bar — its own ConsumerWidget so the position
                  // tick doesn't rebuild the rest of the screen.
                  const SizedBox(height: 16),
                  const _ProgressSection(),
                  // Transport controls
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ShuffleButton(
                        isOn: state.shuffleMode != ShuffleMode.off,
                        onPressed: vm.toggleShuffle,
                      ),
                      TransportButton(
                        size: 44,
                        onPressed: vm.previous,
                        child: const Icon(
                          Icons.skip_previous_rounded,
                          size: 28,
                        ),
                      ),
                      TransportButton(
                        size: 60,
                        accent: true,
                        onPressed: vm.playPause,
                        child: _PlayPauseIcon(isPlaying: state.isPlaying),
                      ),
                      TransportButton(
                        size: 44,
                        onPressed: vm.next,
                        child: const Icon(Icons.skip_next_rounded, size: 28),
                      ),
                      _RepeatButton(
                        isOn: state.repeatMode != RepeatMode.off,
                        onPressed: vm.cycleRepeat,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _VolumeControl(
                    volume: state.volume,
                    isMuted: state.isMuted,
                    onChanged: vm.setVolume,
                    onMuteToggle: vm.toggleMute,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeControl extends StatelessWidget {
  const _VolumeControl({
    required this.volume,
    required this.isMuted,
    required this.onChanged,
    required this.onMuteToggle,
  });

  final double volume;
  final bool isMuted;
  final ValueChanged<double> onChanged;
  final VoidCallback onMuteToggle;

  @override
  Widget build(BuildContext context) {
    return VolumeSlider(
      value: volume,
      isMuted: isMuted,
      onChanged: onChanged,
      onMuteToggle: onMuteToggle,
    );
  }
}

class _RepeatButton extends StatelessWidget {
  const _RepeatButton({required this.isOn, required this.onPressed});

  final bool isOn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TransportButton(
      size: 40,
      color: isOn ? AppColors.accent : AppColors.text3,
      onPressed: onPressed,
      child: const Icon(Icons.repeat, size: 18),
    );
  }
}

class _ShuffleButton extends StatelessWidget {
  const _ShuffleButton({required this.isOn, required this.onPressed});

  final bool isOn;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TransportButton(
      size: 40,
      color: isOn ? AppColors.accent : AppColors.text3,
      onPressed: onPressed,
      child: const Icon(Icons.shuffle, size: 18),
    );
  }
}

class _PlayPauseIcon extends StatelessWidget {
  const _PlayPauseIcon({required this.isPlaying});

  final bool isPlaying;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
      size: 32,
    );
  }
}

class _ProgressSection extends ConsumerWidget {
  const _ProgressSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slice = ref.watch(
      nowPlayingViewModelProvider.select(
        (s) => (positionMs: s.positionMs, durationMs: s.durationMs),
      ),
    );
    final vm = ref.read(nowPlayingViewModelProvider.notifier);
    final positionMs = slice.positionMs;
    final durationMs = slice.durationMs;
    final progress = durationMs > 0
        ? (positionMs / durationMs).clamp(0.0, 1.0)
        : 0.0;
    final elapsed = positionMs ~/ 1000;
    final remaining = durationMs > 0 ? (durationMs - positionMs) ~/ 1000 : 0;

    return Column(
      children: [
        AppProgressBar(
          progress: progress,
          onChanged: (v) => vm.seekTo((v * durationMs).round()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_fmt(elapsed), style: AppTextStyles.monoLabel),
              Text('-${_fmt(remaining)}', style: AppTextStyles.monoLabel),
            ],
          ),
        ),
      ],
    );
  }

  String _fmt(int seconds) {
    if (seconds < 0) seconds = 0;
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }
}

class _TrackAlbumLine extends StatelessWidget {
  const _TrackAlbumLine({required this.album, required this.dateReadable});

  final String album;
  final String? dateReadable;

  @override
  Widget build(BuildContext context) {
    return Text(
      [album, dateReadable ?? ''].where((s) => s.isNotEmpty).join(' · '),
      style: AppTextStyles.monoLabel,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TrackArtist extends StatelessWidget {
  const _TrackArtist({required this.artist});

  final String artist;

  @override
  Widget build(BuildContext context) {
    return Text(
      artist,
      style: AppTextStyles.nowPlayingArtist,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TrackTitle extends StatelessWidget {
  const _TrackTitle({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name.isNotEmpty ? name : 'Nothing playing',
      style: AppTextStyles.nowPlayingTitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _PlayingNowPosition extends StatelessWidget {
  const _PlayingNowPosition({required this.position, required this.total});

  final int position;
  final int total;

  @override
  Widget build(BuildContext context) {
    if (total <= 0) return const SizedBox.shrink();
    return Text('${position + 1} / $total', style: AppTextStyles.monoLabel);
  }
}

class _FormatQuality extends StatelessWidget {
  const _FormatQuality({
    required this.activeZoneName,
    required this.fileType,
    required this.bitDepth,
    required this.sampleRate,
  });

  final String activeZoneName;
  final String fileType;
  final int bitDepth;
  final int sampleRate;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$activeZoneName'
      '${_formatQuality(fileType: fileType, bitDepth: bitDepth, sampleRate: sampleRate)}',
      style: AppTextStyles.itemSubtitle,
    );
  }

  String _formatQuality({
    required String fileType,
    required int bitDepth,
    required int sampleRate,
  }) {
    if (bitDepth > 0 && sampleRate > 0 && fileType.isNotEmpty) {
      final sr = sampleRate >= 1000
          ? '${(sampleRate / 1000).round()}'
          : '$sampleRate';
      return ' · $fileType $bitDepth/$sr';
    }
    return '';
  }
}

class _NowPlayingEmptyState extends StatelessWidget {
  const _NowPlayingEmptyState({required this.zone, required this.vm});

  final Zone zone;
  final NowPlayingViewModel vm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NOW PLAYING', style: AppTextStyles.sectionLabel),
                  const SizedBox(height: 4),
                  Text(zone.name, style: AppTextStyles.itemSubtitle),
                ],
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.music_note_outlined,
                    size: 64,
                    color: AppColors.text3.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nothing playing',
                    style: AppTextStyles.nowPlayingArtist,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select a track from the library',
                    style: AppTextStyles.monoLabel.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          // Volume control still useful even if nothing playing
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: VolumeSlider(
              value: 0,
              isMuted: false,
              onChanged: vm.setVolume,
              onMuteToggle: vm.toggleMute,
            ),
          ),
        ],
      ),
    );
  }
}
