import 'package:fpdart/fpdart.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/error/app_exception.dart';
import '../models/server_info.dart';

/// Result of a JRiver Access Key lookup against webplay.jriver.com.
class AccessKeyLookupResult {
  final String host;
  final int port;

  /// Server-reported HTTPS port from the lookup response (`<httpsport>`),
  /// when present. Null if the server doesn't advertise SSL.
  final int? httpsPort;

  const AccessKeyLookupResult({
    required this.host,
    required this.port,
    this.httpsPort,
  });
}

abstract interface class ConnectionRepository {
  Future<Either<AppException, ServerInfo>> connect({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    int sslPort = 52200,
  });

  /// Resolves a 6-character JRiver Access Key to the server's host/port via
  /// the JRiver lookup service.
  Future<Either<AppException, AccessKeyLookupResult>> lookupAccessKey(
    String accessKey,
  );

  Future<void> clearSession();

  Future<List<SavedServer>> getSavedServers();

  /// The current session token; null when not authenticated.
  String? get currentToken;

  /// Restores a session scope from saved server info without network validation.
  /// Useful for offline startup.
  Future<void> restoreSession(SavedServer server);

  /// Retrieves the password stored under [key] in secure storage.
  Future<String?> getPassword(String key);

  /// Gets the most recently used saved server with its auth token.
  /// Returns null if no saved servers exist or if the most recent one has no token.
  Future<SavedServer?> getLastServerWithToken();
}
