import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/logging/file_log_observer.dart';
import '../../../core/theme/app_theme.dart';
import '../../offline/data/models/download_state.dart';
import '../../offline/providers/download_jobs_provider.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import '../../offline/data/repositories/downloads_repository.dart';
import '../../../core/di/injection.dart';
import '../providers/session_provider.dart';
import '../providers/session_state.dart';

class ServerManagerScreen extends ConsumerWidget {
  const ServerManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

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
                    const _FailedDownloadsSection(),
                    const SizedBox(height: 32),
                    const _DiagnosticsSection(),
                    const SizedBox(height: 32),
                    Builder(
                      builder: (context) {
                        final isSyntheticOffline = session.maybeWhen(
                          authenticated: (info) => info.id == 'offline',
                          orElse: () => false,
                        );

                        return FilledButton.icon(
                          onPressed: () =>
                              ref.read(sessionProvider.notifier).logout(),
                          icon: Icon(
                            isSyntheticOffline
                                ? Icons.login_rounded
                                : Icons.logout_rounded,
                            size: 18,
                          ),
                          label: Text(
                            isSyntheticOffline
                                ? 'Setup Server / Login'
                                : 'Logout',
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.bg3,
                            foregroundColor: isSyntheticOffline
                                ? AppColors.accent
                                : Colors.redAccent,
                          ),
                        );
                      },
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

class _FailedDownloadsSection extends ConsumerWidget {
  const _FailedDownloadsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsState = ref.watch(downloadJobsProvider);

    final failed = jobsState.value
        ?.where((j) => j.state == DownloadState.failed)
        .toList();

    if (failed == null || failed.isEmpty) {
      return const SizedBox.shrink();
    }

    final repo = getIt<DownloadsRepository>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FAILED DOWNLOADS (${failed.length})',
          style: AppTextStyles.sectionLabel,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: [
              for (var i = 0; i < failed.length; i++) ...[
                if (i > 0) const Divider(height: 1, color: AppColors.line),
                _FailedRow(
                  fileKey: failed[i].fileKey,
                  title: failed[i].track.name,
                  subtitle: [
                    failed[i].track.artist,
                    if (failed[i].error != null) failed[i].error!,
                  ].where((s) => s.isNotEmpty).join(' • '),
                  onRetry: () => repo.enqueue(failed[i].track),
                  onRemove: () => repo.removeJob(failed[i].fileKey),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FailedRow extends StatelessWidget {
  final int fileKey;
  final String title;
  final String subtitle;
  final VoidCallback onRetry;
  final VoidCallback onRemove;

  const _FailedRow({
    required this.fileKey,
    required this.title,
    required this.subtitle,
    required this.onRetry,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.itemTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.itemSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.replay, size: 20),
            color: AppColors.text,
            tooltip: 'Retry',
            onPressed: onRetry,
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.error,
            tooltip: 'Remove',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _DiagnosticsSection extends StatelessWidget {
  const _DiagnosticsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('DIAGNOSTICS', style: AppTextStyles.sectionLabel),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Builder(
                    builder: (btnContext) => OutlinedButton.icon(
                      onPressed: () => _exportLogs(btnContext),
                      icon: const Icon(Icons.ios_share_rounded, size: 18),
                      label: const Text('Export Logs'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: const BorderSide(color: AppColors.line2),
                      ),
                    ),
                  ),
                ),
                if (Platform.isMacOS) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _saveLogTo(context),
                      icon: const Icon(Icons.save_alt_rounded, size: 18),
                      label: const Text('Save Log As…'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: const BorderSide(color: AppColors.line2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openLogInTextEdit(context),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Open in TextEdit'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.text,
                        side: const BorderSide(color: AppColors.line2),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveLogTo(BuildContext context) async {
    final path = FileLogObserver.logFilePath;
    if (path == null || !File(path).existsSync()) {
      _showSnack(context, 'Log file not ready yet');
      return;
    }
    final ts = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    // NSSavePanel — granted via Powerbox, so writing to the chosen path is
    // permitted even though our app is sandboxed.
    final location = await getSaveLocation(
      suggestedName: 'jrr_log_$ts.txt',
      acceptedTypeGroups: const [
        XTypeGroup(label: 'Text', extensions: ['txt', 'log']),
      ],
    );
    if (location == null) return; // user cancelled
    try {
      await File(path).copy(location.path);
      if (context.mounted) _showSnack(context, 'Saved to ${location.path}');
    } catch (e) {
      if (context.mounted) _showSnack(context, 'Save failed: $e');
    }
  }

  Future<void> _openLogInTextEdit(BuildContext context) async {
    final path = FileLogObserver.logFilePath;
    if (path == null || !File(path).existsSync()) {
      _showSnack(context, 'Log file not ready yet');
      return;
    }
    // /usr/bin/open routes through Launch Services, which grants TextEdit
    // a security-scoped read permission to our sandboxed log file via
    // Powerbox. Direct File access from TextEdit would otherwise be denied.
    final result = await Process.run('/usr/bin/open', ['-a', 'TextEdit', path]);
    if (result.exitCode != 0 && context.mounted) {
      _showSnack(context, 'Could not open: ${result.stderr}');
    }
  }

  Future<void> _exportLogs(BuildContext context) async {
    // Capture the popover anchor synchronously, before any await. iPad/macOS
    // share sheets are presented as popovers and require this rect.
    Rect? originRect;
    final box = context.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      originRect = box.localToGlobal(Offset.zero) & box.size;
    }

    final path = FileLogObserver.logFilePath;
    if (path == null) {
      _showSnack(context, 'Log file not ready yet');
      return;
    }
    final src = File(path);
    if (!src.existsSync()) {
      _showSnack(context, 'Log file not found at $path');
      return;
    }

    // Copy the live log file to a temp file with a fresh, timestamped name.
    // Sharing a clean independent file (not the active log) is more
    // compatible with iOS share targets like Files and AirDrop.
    final ts = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;
    final tmpDir = await getTemporaryDirectory();
    // macOS sandbox does not pre-create the per-bundle subdirectory under
    // Caches; create it before writing into it.
    if (!tmpDir.existsSync()) tmpDir.createSync(recursive: true);
    final exportPath = '${tmpDir.path}/jrr_log_$ts.txt';
    await src.copy(exportPath);

    final params = ShareParams(
      files: [
        XFile(exportPath, mimeType: 'text/plain', name: 'jrr_log_$ts.txt'),
      ],
      subject: 'JRR application logs',
      sharePositionOrigin: originRect,
    );
    await SharePlus.instance.share(params);
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
