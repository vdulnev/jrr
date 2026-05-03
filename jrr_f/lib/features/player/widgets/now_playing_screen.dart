import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jrr_f/core/di/injection.dart';
import 'package:talker/talker.dart';
import '../../library/providers/library_providers.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/progress_bar.dart';
import '../../../shared/widgets/transport_button.dart';
import '../../../shared/widgets/volume_slider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../../zones/data/models/zone.dart';
import '../data/models/playback_state.dart';
import '../data/models/repeat_mode.dart';
import '../data/models/shuffle_mode.dart';
import '../providers/player_provider.dart';
import '../providers/player_polling_provider.dart';
import '../../../shared/widgets/artwork_widget.dart';

class NowPlayingScreen extends ConsumerWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();
    ref.watch(playerPollingProvider);

    final activeZone = ref.watch(activeZoneProvider);
    if (activeZone == null) {
      talker.debug('[NowPlayingScreen]: No active zone found');
      return const Scaffold(body: LoadingView());
    }

    final fileKey = ref.watch(
      playerProvider.select((status) => status.value?.fileKey ?? -1),
    );
    if (fileKey < 0) {
      talker.debug('[NowPlayingScreen]: fileKey < 0');
      return _NowPlayingEmptyState(zone: activeZone);
    }

    // Fetch full track info to get dateReadable (which isn't in PlayerStatus)
    // Only triggers when fileKey changes
    final track = fileKey >= 0
        ? ref.watch(searchByFileKeyProvider(fileKey)).asData?.value
        : null;

    talker.debug(
      '[NowPlayingScreen]: Building UI with track: ${track?.name ?? 'Unknown'}',
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 88),
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
                          _FormatQuality(activeZone: activeZone),
                        ],
                      ),
                    ),
                    const _PlayingNowPosition(),
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
                        child: const _ArtworkConsumerWidget(),
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
                          const _TrackTitle(),
                          if (fileKey >= 0) ...[
                            const SizedBox(height: 3),
                            const _TrackArtist(),
                            const SizedBox(height: 2),
                            const _TrackAlbumLine(),
                          ],
                        ],
                      ),
                    ),

                    // Progress bar
                    const SizedBox(height: 16),
                    const _ProgressSection(),
                    // Transport controls
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const _ShuffleButton(),
                        TransportButton(
                          size: 44,
                          onPressed: () =>
                              ref.read(playerProvider.notifier).previous(),
                          child: const Icon(
                            Icons.skip_previous_rounded,
                            size: 28,
                          ),
                        ),
                        TransportButton(
                          size: 60,
                          accent: true,
                          onPressed: () =>
                              ref.read(playerProvider.notifier).playPause(),
                          child: const _PlayPauseIcon(),
                        ),
                        TransportButton(
                          size: 44,
                          onPressed: () =>
                              ref.read(playerProvider.notifier).next(),
                          child: const Icon(Icons.skip_next_rounded, size: 28),
                        ),
                        const _RepeatButton(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _VolumeControl(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VolumeControl extends ConsumerWidget {
  const _VolumeControl();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final volume = ref.watch(
      playerProvider.select((status) => status.value?.volume ?? 0.0),
    );
    final isMuted = ref.watch(
      playerProvider.select((status) => status.value?.isMuted ?? false),
    );

    talker.debug(
      '[NowPlayingScreen]: Volume control updated: volume: $volume, isMuted: $isMuted',
    );
    return VolumeSlider(
      value: volume,
      isMuted: isMuted,
      onChanged: (v) => ref.read(playerProvider.notifier).setVolume(v),
      onMuteToggle: () => ref.read(playerProvider.notifier).toggleMute(),
    );
  }
}

class _RepeatButton extends ConsumerWidget {
  const _RepeatButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final isOn = ref.watch(
      playerProvider.select(
        (status) =>
            (status.value?.repeatMode ?? RepeatMode.off) != RepeatMode.off,
      ),
    );

    talker.debug('[NowPlayingScreen]: Repeat button updated: $isOn');
    return TransportButton(
      size: 40,
      color: isOn ? AppColors.accent : AppColors.text3,
      onPressed: () => ref.read(playerProvider.notifier).cycleRepeat(),
      child: const Icon(Icons.repeat, size: 18),
    );
  }
}

class _ShuffleButton extends ConsumerWidget {
  const _ShuffleButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final isOn = ref.watch(
      playerProvider.select(
        (status) =>
            (status.value?.shuffleMode ?? ShuffleMode.off) != ShuffleMode.off,
      ),
    );

    talker.debug('[NowPlayingScreen]: Shuffle button updated: $isOn');
    return TransportButton(
      size: 40,
      color: isOn ? AppColors.accent : AppColors.text3,
      onPressed: () => ref.read(playerProvider.notifier).toggleShuffle(),
      child: const Icon(Icons.shuffle, size: 18),
    );
  }
}

class _PlayPauseIcon extends ConsumerWidget {
  const _PlayPauseIcon();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final isPlaying = ref.watch(
      playerProvider.select(
        (status) => status.value?.state == PlaybackState.playing,
      ),
    );
    talker.debug('[NowPlayingScreen]: Play/pause icon updated: $isPlaying');
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
    final talker = getIt<Talker>();

    final positionMs = ref.watch(
      playerProvider.select((status) => status.value?.positionMs ?? 0),
    );
    final durationMs = ref.watch(
      playerProvider.select((status) => status.value?.durationMs ?? 0),
    );

    final progress = durationMs > 0
        ? (positionMs / durationMs).clamp(0.0, 1.0)
        : 0.0;
    final elapsed = positionMs ~/ 1000;
    final remaining = durationMs > 0 ? (durationMs - positionMs) ~/ 1000 : 0;

    talker.debug(
      '[NowPlayingScreen]: Progress updated: $elapsed / ${durationMs ~/ 1000}',
    );

    return Column(
      children: [
        AppProgressBar(
          progress: progress,
          onChanged: (v) {
            final ms = (v * durationMs).round();
            talker.debug(
              '[NowPlayingScreen]: Progress changed to $v volume, $ms ms',
            );
            ref.read(playerProvider.notifier).seekTo(ms);
          },
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

class _TrackAlbumLine extends ConsumerWidget {
  const _TrackAlbumLine();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final album = ref.watch(
      playerProvider.select((status) => status.value?.album ?? ''),
    );
    final fileKey = ref.watch(
      playerProvider.select((status) => status.value?.fileKey ?? -1),
    );
    final dateReadable = fileKey >= 0
        ? ref
              .watch(searchByFileKeyProvider(fileKey))
              .asData
              ?.value
              ?.dateReadable
        : null;

    talker.debug(
      '[NowPlayingScreen]: Track album line updated: $album, date: $dateReadable',
    );
    return Text(
      [album, dateReadable ?? ''].where((s) => s.isNotEmpty).join(' · '),
      style: AppTextStyles.monoLabel,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TrackArtist extends ConsumerWidget {
  const _TrackArtist();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final artist = ref.watch(
      playerProvider.select((status) => status.value?.artist ?? ''),
    );
    talker.debug('[NowPlayingScreen]: Track artist updated: $artist');
    return Text(
      artist,
      style: AppTextStyles.nowPlayingArtist,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _TrackTitle extends ConsumerWidget {
  const _TrackTitle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final name = ref.watch(
      playerProvider.select((status) => status.value?.name ?? ''),
    );
    talker.debug('[NowPlayingScreen]: Track title updated: $name');
    return Text(
      name.isNotEmpty ? name : 'Nothing playing',
      style: AppTextStyles.nowPlayingTitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ArtworkConsumerWidget extends ConsumerWidget {
  const _ArtworkConsumerWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final imageUrl = ref.watch(
      playerProvider.select((status) => status.value?.imageUrl ?? ''),
    );

    talker.debug('[NowPlayingScreen]: Artwork updated: $imageUrl');
    return ArtworkWidget(imageUrl: imageUrl, size: 280);
  }
}

class _PlayingNowPosition extends ConsumerWidget {
  const _PlayingNowPosition();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final talker = getIt<Talker>();

    final playingNowPosition = ref.watch(
      playerProvider.select((status) => status.value?.playingNowPosition ?? 0),
    );
    final playingNowTracks = ref.watch(
      playerProvider.select((status) => status.value?.playingNowTracks ?? 0),
    );
    if (playingNowTracks > 0) {
      talker.debug(
        '[NowPlayingScreen]: Playing now position updated: $playingNowPosition / $playingNowTracks',
      );
      return Text(
        '${playingNowPosition + 1} / $playingNowTracks',
        style: AppTextStyles.monoLabel,
      );
    } else {
      talker.debug(
        '[NowPlayingScreen]: playingNowTracks is 0, hiding position',
      );
      return const SizedBox.shrink();
    }
  }
}

class _FormatQuality extends ConsumerWidget {
  const _FormatQuality({required this.activeZone});

  final Zone activeZone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Talker talker = getIt<Talker>();

    final bitDepth = ref.watch(
      playerProvider.select((status) => status.value?.bitDepth ?? 0),
    );
    final sampleRate = ref.watch(
      playerProvider.select((status) => status.value?.sampleRate ?? 0),
    );
    final bitrate = ref.watch(
      playerProvider.select((status) => status.value?.bitrate ?? 0),
    );
    talker.debug(
      '[NowPlayingScreen]: Sound quality updated: bitDepth: $bitDepth, sampleRate: $sampleRate, bitrate: $bitrate',
    );
    return Text(
      '${activeZone.name}'
      '${_formatQuality(bitDepth: bitDepth, sampleRate: sampleRate, bitrate: bitrate)}',
      style: AppTextStyles.itemSubtitle,
    );
  }

  String _formatQuality({
    required int bitDepth,
    required int sampleRate,
    required int bitrate,
  }) {
    if (bitDepth > 0 && sampleRate > 0) {
      final sr = sampleRate >= 1000
          ? '${(sampleRate / 1000).round()}'
          : '$sampleRate';
      return ' \u00b7 FLAC $bitDepth/$sr';
    }
    if (bitrate > 0) return ' \u00b7 $bitrate kbps';
    return '';
  }
}

class _NowPlayingEmptyState extends ConsumerWidget {
  final Zone zone;

  const _NowPlayingEmptyState({required this.zone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 88),
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
                    const Text(
                      'NOW PLAYING',
                      style: AppTextStyles.sectionLabel,
                    ),
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
                onChanged: (v) =>
                    ref.read(playerProvider.notifier).setVolume(v),
                onMuteToggle: () =>
                    ref.read(playerProvider.notifier).toggleMute(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
