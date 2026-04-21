import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SubScreenHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback onBack;
  final Widget? trailing;

  const SubScreenHeader({
    required this.title,
    this.subtitle,
    required this.onBack,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chevron_left, size: 18, color: AppColors.accent),
                SizedBox(width: 2),
                Text('Back', style: AppTextStyles.accentButton),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          subtitle!.toUpperCase(),
                          style: AppTextStyles.sectionLabel,
                        ),
                      ),
                    Text(title, style: AppTextStyles.subScreenTitle),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ],
      ),
    );
  }
}
