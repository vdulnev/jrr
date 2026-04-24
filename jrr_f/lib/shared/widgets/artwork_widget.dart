import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection.dart';
import '../../features/connection/data/repositories/connection_repository.dart';
import '../../features/connection/providers/session_provider.dart';
import '../../features/connection/providers/session_state.dart';

class ArtworkWidget extends ConsumerWidget {
  final String? imageUrl;
  final double size;

  const ArtworkWidget({super.key, required this.imageUrl, this.size = 280});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder(context);
    }

    final session = ref.read(sessionProvider);
    if (session is! Authenticated) return _placeholder(context);

    final baseAddress = session.serverInfo.address;
    final token = getIt<ConnectionRepository>().currentToken;
    final separator = url.contains('?') ? '&' : '?';
    final fullUrl =
        '$baseAddress/$url${token != null ? '${separator}Token=$token' : ''}';

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        fullUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _placeholder(context),
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _placeholder(context);
        },
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.music_note,
        size: size * 0.4,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
