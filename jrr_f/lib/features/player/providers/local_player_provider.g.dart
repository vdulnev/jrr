// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalPlayer)
final localPlayerProvider = LocalPlayerProvider._();

final class LocalPlayerProvider
    extends $NotifierProvider<LocalPlayer, LocalPlaybackState> {
  LocalPlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerHash();

  @$internal
  @override
  LocalPlayer create() => LocalPlayer();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlaybackState>(value),
    );
  }
}

String _$localPlayerHash() => r'671f2980b6296858cb78aa8e97aae8e2cfc226de';

abstract class _$LocalPlayer extends $Notifier<LocalPlaybackState> {
  LocalPlaybackState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LocalPlaybackState, LocalPlaybackState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalPlaybackState, LocalPlaybackState>,
              LocalPlaybackState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
