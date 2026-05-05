import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

Future<bool> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Delete',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.bg3,
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmLabel,
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}
