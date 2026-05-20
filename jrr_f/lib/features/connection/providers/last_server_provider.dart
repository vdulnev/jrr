import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';

part 'last_server_provider.g.dart';

/// Loads the most recently used saved server and its password.
/// Returns null when no server has been saved yet.
@riverpod
Future<
  ({
    String host,
    int port,
    String username,
    String? password,
    bool useSsl,
    int sslPort,
  })?
>
lastServer(Ref ref) async {
  final repo = ref.read(connectionRepositoryProvider);
  final servers = await repo.getSavedServers();
  if (servers.isEmpty) return null;
  final last = servers.first; // ordered by lastUsedAt desc
  final password = await repo.getPassword(last.passwordKey);
  return (
    host: last.host,
    port: last.port,
    username: last.username,
    password: password,
    useSsl: last.useSsl,
    sslPort: last.sslPort,
  );
}
