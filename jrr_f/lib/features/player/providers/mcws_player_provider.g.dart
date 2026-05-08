// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcws_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Owns all MCWS-driven (remote) playback control.
///
/// Returns `null` when the active zone is missing, local, or offline. The
/// unified [Player] provider watches this one for the remote branch and
/// dispatches commands here for non-local zones.

@ProviderFor(McwsPlayer)
final mcwsPlayerProvider = McwsPlayerProvider._();

/// Owns all MCWS-driven (remote) playback control.
///
/// Returns `null` when the active zone is missing, local, or offline. The
/// unified [Player] provider watches this one for the remote branch and
/// dispatches commands here for non-local zones.
final class McwsPlayerProvider
    extends $AsyncNotifierProvider<McwsPlayer, PlayerStatus?> {
  /// Owns all MCWS-driven (remote) playback control.
  ///
  /// Returns `null` when the active zone is missing, local, or offline. The
  /// unified [Player] provider watches this one for the remote branch and
  /// dispatches commands here for non-local zones.
  McwsPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mcwsPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mcwsPlayerHash();

  @$internal
  @override
  McwsPlayer create() => McwsPlayer();
}

String _$mcwsPlayerHash() => r'49f81de5708acc63d591da13d853220706a2025f';

/// Owns all MCWS-driven (remote) playback control.
///
/// Returns `null` when the active zone is missing, local, or offline. The
/// unified [Player] provider watches this one for the remote branch and
/// dispatches commands here for non-local zones.

abstract class _$McwsPlayer extends $AsyncNotifier<PlayerStatus?> {
  FutureOr<PlayerStatus?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlayerStatus?>, PlayerStatus?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerStatus?>, PlayerStatus?>,
              AsyncValue<PlayerStatus?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
