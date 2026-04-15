import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/repositories/connection_repository.dart';

part 'last_server_provider.g.dart';

/// Loads the most recently used saved server and its password.
/// Returns null when no server has been saved yet.
@riverpod
Future<({String host, int port, String username, String? password})?>
lastServer(Ref ref) async {
  final repo = getIt<ConnectionRepository>();
  final servers = await repo.getSavedServers();
  if (servers.isEmpty) return null;
  final last = servers.first; // ordered by lastUsedAt desc
  final password = await repo.getPassword(last.passwordKey);
  return (
    host: last.host,
    port: last.port,
    username: last.username,
    password: password,
  );
}
