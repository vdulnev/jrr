import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import '../../offline/data/repositories/downloads_repository.dart';
import '../../../core/di/injection.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../providers/session_provider.dart';
import '../providers/session_state.dart';

class ServerManagerScreen extends ConsumerWidget {
  const ServerManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final isOffline = ref.watch(isOfflineActiveProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CONNECTION', style: AppTextStyles.sectionLabel),
                  SizedBox(height: 6),
                  Text('Server Manager', style: AppTextStyles.screenTitle),
                ],
              ),
            ),
            Expanded(
              child: session.maybeWhen(
                authenticated: (serverInfo) => ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  children: [
                    _InfoSection(
                      title: 'CONNECTED SERVER',
                      items: [
                        _InfoRow(label: 'Name', value: serverInfo.name),
                        _InfoRow(label: 'Version', value: serverInfo.version),
                        _InfoRow(label: 'Platform', value: serverInfo.platform),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const _StorageSection(),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: isOffline
                          ? null
                          : () => ref.read(sessionProvider.notifier).logout(),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: Text(isOffline ? 'Logout (offline)' : 'Logout'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.bg3,
                        foregroundColor: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
                orElse: () => const Center(child: Text('Not authenticated')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.itemSubtitle),
          Text(
            value,
            style: AppTextStyles.monoLabel.copyWith(
              color: AppColors.text,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageSection extends ConsumerWidget {
  const _StorageSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tracksState = ref.watch(downloadedTracksProvider);

    return tracksState.when(
      data: (tracks) {
        final count = tracks.length;
        final totalBytes = tracks.fold<int>(
          0,
          (sum, t) => sum + t.fileSizeBytes,
        );
        final sizeStr = _formatBytes(totalBytes);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('OFFLINE STORAGE', style: AppTextStyles.sectionLabel),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bg2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.line),
              ),
              child: Column(
                children: [
                  _InfoRow(label: 'Downloaded Tracks', value: '$count'),
                  _InfoRow(label: 'Total Size', value: sizeStr),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: count > 0
                            ? () => _confirmClear(context, ref)
                            : null,
                        icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                        label: const Text('Clear All Downloads'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var i = 0;
    double d = bytes.toDouble();
    while (d >= 1024 && i < suffixes.length - 1) {
      d /= 1024;
      i++;
    }
    return '${d.toStringAsFixed(1)} ${suffixes[i]}';
  }

  void _confirmClear(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.bg3,
        title: const Text('Clear all downloads?'),
        content: const Text(
          'This will delete all downloaded tracks and artwork from your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              getIt<DownloadsRepository>().clearAll();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
