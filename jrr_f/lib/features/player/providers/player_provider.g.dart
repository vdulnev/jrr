// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Player)
final playerProvider = PlayerProvider._();

final class PlayerProvider
    extends $AsyncNotifierProvider<Player, PlayerStatus?> {
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

String _$playerHash() => r'c852e9c7c8f341b4ba69be16dfd0b01654d7a063';

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
