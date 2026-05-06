import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../data/models/download_state.dart';
import '../providers/download_status_provider.dart';

class DownloadProgressIndicator extends ConsumerWidget {
  final int fileKey;
  final double size;

  const DownloadProgressIndicator({
    required this.fileKey,
    this.size = 14,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(downloadStatusProvider(fileKey));
    final progress = ref.watch(downloadProgressProvider(fileKey));

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

    if (status == DownloadState.downloaded) {
      return Icon(
        Icons.check_circle_rounded,
        size: size,
        color: AppColors.accent,
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
