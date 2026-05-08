// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unified player provider. Dispatches between [LocalPlayer] (just_audio) for
/// local/offline zones and [McwsPlayer] (MCWS HTTP API) for remote zones.
///
/// Public surface is preserved so consumers don't need to know which transport
/// is active.

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

/// Unified player provider. Dispatches between [LocalPlayer] (just_audio) for
/// local/offline zones and [McwsPlayer] (MCWS HTTP API) for remote zones.
///
/// Public surface is preserved so consumers don't need to know which transport
/// is active.
final class PlayerProvider
    extends $AsyncNotifierProvider<Player, PlayerStatus?> {
  /// Unified player provider. Dispatches between [LocalPlayer] (just_audio) for
  /// local/offline zones and [McwsPlayer] (MCWS HTTP API) for remote zones.
  ///
  /// Public surface is preserved so consumers don't need to know which transport
  /// is active.
  PlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerHash();

  @$internal
  @override
  Player create() => Player();
}

String _$playerHash() => r'd0357777de15f66ef28a0586457acbfb832e91cd';

/// Unified player provider. Dispatches between [LocalPlayer] (just_audio) for
/// local/offline zones and [McwsPlayer] (MCWS HTTP API) for remote zones.
///
/// Public surface is preserved so consumers don't need to know which transport
/// is active.

abstract class _$Player extends $AsyncNotifier<PlayerStatus?> {
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

@ProviderFor(PlayingNowPosition)
final playingNowPositionProvider = PlayingNowPositionProvider._();

final class PlayingNowPositionProvider
    extends $NotifierProvider<PlayingNowPosition, int> {
  PlayingNowPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playingNowPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playingNowPositionHash();

  @$internal
  @override
  PlayingNowPosition create() => PlayingNowPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$playingNowPositionHash() =>
    r'4115001223702ff0f68357e2e8050d4921898f85';

abstract class _$PlayingNowPosition extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
