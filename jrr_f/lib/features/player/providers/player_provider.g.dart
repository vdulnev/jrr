// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Unified player provider. Resolves the active [PlayerController]
/// implementation from [activeZoneProvider] and forwards every command to it,
/// so call sites never branch on zone locality.

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

/// Unified player provider. Resolves the active [PlayerController]
/// implementation from [activeZoneProvider] and forwards every command to it,
/// so call sites never branch on zone locality.
final class PlayerProvider
    extends $AsyncNotifierProvider<Player, PlayerStatus?> {
  /// Unified player provider. Resolves the active [PlayerController]
  /// implementation from [activeZoneProvider] and forwards every command to it,
  /// so call sites never branch on zone locality.
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

String _$playerHash() => r'cdeff665db0a529060236f30d478e28a75463a62';

/// Unified player provider. Resolves the active [PlayerController]
/// implementation from [activeZoneProvider] and forwards every command to it,
/// so call sites never branch on zone locality.

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
    r'0beffb3f07731fb8f4d9a3bbe4eaf045b7fd2775';

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
