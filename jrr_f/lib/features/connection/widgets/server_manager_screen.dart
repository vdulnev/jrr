import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
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
                    FilledButton.icon(
                      onPressed: () =>
                          ref.read(sessionProvider.notifier).logout(),
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Logout'),
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
