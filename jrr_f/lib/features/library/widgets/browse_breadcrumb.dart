import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../data/models/browse_item.dart';

/// Reusable breadcrumb navigation
class BrowseBreadcrumb extends StatelessWidget {
  final List<BrowseItem> stack;
  final ValueChanged<int> onTap;
  final String? prefix;

  const BrowseBreadcrumb({
    super.key,
    required this.stack,
    required this.onTap,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          if (prefix != null) ...[
            GestureDetector(
              onTap: () => onTap(-1),
              child: Text(
                prefix!,
                style: AppTextStyles.monoLabel.copyWith(color: AppColors.text3),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right,
                size: 12,
                color: AppColors.text3,
              ),
            ),
          ],
          for (var i = 0; i < stack.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: 12,
                  color: AppColors.text3,
                ),
              ),
            GestureDetector(
              onTap: i < stack.length - 1 ? () => onTap(i) : null,
              child: Text(
                stack[i].name,
                style: AppTextStyles.monoLabel.copyWith(
                  color: i < stack.length - 1
                      ? AppColors.text3
                      : AppColors.accent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
