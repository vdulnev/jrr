import 'package:flutter/material.dart';

class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    final currentMessage = message;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (currentMessage != null) ...[
            const SizedBox(height: 16),
            Text(currentMessage, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
