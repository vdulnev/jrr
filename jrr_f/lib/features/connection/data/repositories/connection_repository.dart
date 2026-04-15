import 'package:fpdart/fpdart.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/error/app_exception.dart';
import '../models/server_info.dart';

abstract interface class ConnectionRepository {
  Future<Either<AppException, ServerInfo>> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  });

  Future<void> clearSession();

  Future<List<SavedServer>> getSavedServers();

  /// The current session token; null when not authenticated.
  String? get currentToken;

  /// Retrieves the password stored under [key] in secure storage.
  Future<String?> getPassword(String key);

  /// Gets the most recently used saved server with its auth token.
  /// Returns null if no saved servers exist or if the most recent one has no token.
  Future<SavedServer?> getLastServerWithToken();
}
