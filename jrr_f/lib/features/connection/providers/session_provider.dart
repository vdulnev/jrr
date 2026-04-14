import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/router/navigation_notifier.dart';
import '../data/repositories/connection_repository.dart';
import 'session_state.dart';

part 'session_provider.g.dart';

@riverpod
class Session extends _$Session {
  @override
  SessionState build() => const SessionState.unauthenticated();

  /// Returns null on success, AppException on failure.
  Future<AppException?> connect({
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    final result = await getIt<ConnectionRepository>().connect(
      host: host,
      port: port,
      username: username,
      password: password,
    );
    return result.fold((e) => e, (info) {
      state = SessionState.authenticated(serverInfo: info);
      return null;
    });
  }

  void logout() {
    getIt<ConnectionRepository>().clearSession();
    state = const SessionState.unauthenticated();
    ref.read(navigationProvider.notifier).clear();
  }
}
