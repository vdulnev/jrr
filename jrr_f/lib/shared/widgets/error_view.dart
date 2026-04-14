import 'package:flutter/material.dart';
import '../../core/error/app_exception.dart';

class ErrorView extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.error, this.onRetry});

  String _message() {
    if (error is AppException) {
      return switch (error as AppException) {
        ConnectionRefusedException(:final address) =>
          'Cannot connect to $address.\n'
              'Check the server address and try again.',
        UnauthorizedException() =>
          'Authentication failed.\n'
              'Check your username and password.',
        ServerFailureException(:final message) => 'Server error: $message',
        ParseErrorException(:final details) =>
          'Unexpected response from server ($details).',
        AppTimeoutException(:final address) =>
          'Connection to $address timed out.',
        UnknownException(:final error) => 'Unexpected error: $error',
      };
    }
    return error.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _message(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
