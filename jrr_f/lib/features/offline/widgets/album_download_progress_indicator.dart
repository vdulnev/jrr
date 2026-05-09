import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/download_state.dart';
import '../providers/download_status_provider.dart';

class AlbumDownloadProgressIndicator extends ConsumerWidget {
  final String albumGroupId;
  final double size;

  const AlbumDownloadProgressIndicator({
    required this.albumGroupId,
    this.size = 14,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(albumDownloadStatusProvider(albumGroupId));
    final progress = ref.watch(albumDownloadProgressProvider(albumGroupId));

    if (status == DownloadState.queued) {
      return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.text3),
        ),
      );
    }

    if (status == DownloadState.running) {
      return SizedBox(
        width: size,
        height: size,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
          builder: (_, value, _) => CircularProgressIndicator(
            value: value > 0 ? value : null,
            strokeWidth: 2,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
        ),
      );
    }

    if (status == DownloadState.failed) {
      return Icon(
        Icons.error_outline_rounded,
        size: size,
        color: AppColors.error,
      );
    }

    return const SizedBox.shrink();
  }
}
