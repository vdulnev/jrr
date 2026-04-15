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
    extends $AsyncNotifierProvider<Player, PlayerStatus> {
  PlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerHash();

  @$internal
  @override
  Player create() => Player();
}

String _$playerHash() => r'55f8c47d15bc9aaf0f22b7d452746a9f63dff96a';

abstract class _$Player extends $AsyncNotifier<PlayerStatus> {
  FutureOr<PlayerStatus> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PlayerStatus>, PlayerStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PlayerStatus>, PlayerStatus>,
              AsyncValue<PlayerStatus>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
