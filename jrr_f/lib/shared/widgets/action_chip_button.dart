import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class ActionChipButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const ActionChipButton({required this.label, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.bg3,
          border: Border.all(color: AppColors.line2),
          borderRadius: BorderRadius.circular(13),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.chipLabel),
      ),
    );
  }
}
