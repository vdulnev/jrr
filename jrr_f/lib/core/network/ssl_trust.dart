import 'dart:io';

/// Process-wide opt-in trust for self-signed TLS certificates.
///
/// JRiver MC's HTTPS port serves a self-signed cert by default, which Dart's
/// HttpClient rejects unless an application callback overrides verification.
///
/// Configuring `badCertificateCallback` inside dio's `IOHttpClientAdapter`
/// proved unreliable in practice (handshake fails before the callback path is
/// reached on some Flutter platforms). Installing an [HttpOverrides] instead
/// patches the trust at the `HttpClient` constructor level, which every
/// `dart:io` HTTP client — including dio's default adapter — goes through.
///
/// Trust is host-scoped: only hosts the user explicitly opted into via
/// [trustHost] are accepted. All other hosts retain default strict validation.
class JRiverHttpOverrides extends HttpOverrides {
  static final JRiverHttpOverrides instance = JRiverHttpOverrides._();

  JRiverHttpOverrides._();

  final Set<String> _trustedHosts = <String>{};

  /// Installs this override as the process-wide [HttpOverrides] if no other
  /// override has been installed. Idempotent.
  static void install() {
    if (HttpOverrides.current == null) {
      HttpOverrides.global = instance;
    }
  }

  /// Add [host] to the allow-list. Subsequent TLS handshakes to this host
  /// will accept any certificate (including self-signed).
  void trustHost(String host) {
    _trustedHosts.add(host);
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) =>
          _trustedHosts.contains(host);
  }
}
