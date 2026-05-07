// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_server_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Loads the most recently used saved server and its password.
/// Returns null when no server has been saved yet.

@ProviderFor(lastServer)
final lastServerProvider = LastServerProvider._();

/// Loads the most recently used saved server and its password.
/// Returns null when no server has been saved yet.

final class LastServerProvider
    extends
        $FunctionalProvider<
          AsyncValue<
            ({
              String host,
              String? password,
              int port,
              int sslPort,
              bool useSsl,
              String username,
            })?
          >,
          ({
            String host,
            String? password,
            int port,
            int sslPort,
            bool useSsl,
            String username,
          })?,
          FutureOr<
            ({
              String host,
              String? password,
              int port,
              int sslPort,
              bool useSsl,
              String username,
            })?
          >
        >
    with
        $FutureModifier<
          ({
            String host,
            String? password,
            int port,
            int sslPort,
            bool useSsl,
            String username,
          })?
        >,
        $FutureProvider<
          ({
            String host,
            String? password,
            int port,
            int sslPort,
            bool useSsl,
            String username,
          })?
        > {
  /// Loads the most recently used saved server and its password.
  /// Returns null when no server has been saved yet.
  LastServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastServerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastServerHash();

  @$internal
  @override
  $FutureProviderElement<
    ({
      String host,
      String? password,
      int port,
      int sslPort,
      bool useSsl,
      String username,
    })?
  >
  $createElement($ProviderPointer pointer) => $FutureProviderElement(pointer);

  @override
  FutureOr<
    ({
      String host,
      String? password,
      int port,
      int sslPort,
      bool useSsl,
      String username,
    })?
  >
  create(Ref ref) {
    return lastServer(ref);
  }
}

String _$lastServerHash() => r'8e3d91b2ff2259bfd89558b7c2af9705ee94aac9';
