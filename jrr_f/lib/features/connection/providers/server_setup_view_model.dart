import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'last_server_provider.dart';
import 'server_setup_provider.dart';
import 'server_setup_view_state.dart';
import 'session_provider.dart';

part 'server_setup_view_model.g.dart';

@riverpod
class ServerSetupViewModel extends _$ServerSetupViewModel {
  @override
  ServerSetupViewState build() {
    final form = ref.watch(serverSetupFormProvider);
    final prefill = ref.watch(lastServerProvider).value;
    return ServerSetupViewState(
      isConnecting: form is AsyncLoading,
      connectError: form is AsyncError ? form.error : null,
      prefill: prefill == null
          ? null
          : ServerSetupPrefill(
              host: prefill.host,
              port: prefill.port,
              username: prefill.username,
              password: prefill.password,
              useSsl: prefill.useSsl,
              sslPort: prefill.sslPort,
            ),
    );
  }

  Future<void> connectWithAccessKey({
    required String accessKey,
    required String username,
    required String password,
    bool useSsl = false,
  }) => ref
      .read(serverSetupFormProvider.notifier)
      .connectWithAccessKey(
        accessKey: accessKey,
        username: username,
        password: password,
        useSsl: useSsl,
      );

  Future<void> connectWithHost({
    required String host,
    required int port,
    required String username,
    required String password,
    bool useSsl = false,
    int sslPort = 52200,
  }) => ref
      .read(serverSetupFormProvider.notifier)
      .connectWithHost(
        host: host,
        port: port,
        username: username,
        password: password,
        useSsl: useSsl,
        sslPort: sslPort,
      );

  Future<void> enterOfflineMode() =>
      ref.read(sessionProvider.notifier).enterOfflineMode();
}
