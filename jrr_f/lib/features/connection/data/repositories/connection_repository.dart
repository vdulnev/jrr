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
}
