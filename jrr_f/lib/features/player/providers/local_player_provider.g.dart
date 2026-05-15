// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localPlayerService)
final localPlayerServiceProvider = LocalPlayerServiceProvider._();

final class LocalPlayerServiceProvider
    extends
        $FunctionalProvider<
          LocalPlayerServiceBase,
          LocalPlayerServiceBase,
          LocalPlayerServiceBase
        >
    with $Provider<LocalPlayerServiceBase> {
  LocalPlayerServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerServiceHash();

  @$internal
  @override
  $ProviderElement<LocalPlayerServiceBase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalPlayerServiceBase create(Ref ref) {
    return localPlayerService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlayerServiceBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlayerServiceBase>(value),
    );
  }
}

String _$localPlayerServiceHash() =>
    r'70ea846828e19f3768815e429731f9c5217cfc02';

@ProviderFor(LocalPlayerPosition)
final localPlayerPositionProvider = LocalPlayerPositionProvider._();

final class LocalPlayerPositionProvider
    extends $NotifierProvider<LocalPlayerPosition, Duration> {
  LocalPlayerPositionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerPositionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerPositionHash();

  @$internal
  @override
  LocalPlayerPosition create() => LocalPlayerPosition();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$localPlayerPositionHash() =>
    r'4343dc64d00a7b978685b65784c544df885c47a3';

abstract class _$LocalPlayerPosition extends $Notifier<Duration> {
  Duration build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration, Duration>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration, Duration>,
              Duration,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LocalPlayerState)
final localPlayerStateProvider = LocalPlayerStateProvider._();

final class LocalPlayerStateProvider
    extends $NotifierProvider<LocalPlayerState, PlayerStateData> {
  LocalPlayerStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerStateHash();

  @$internal
  @override
  LocalPlayerState create() => LocalPlayerState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerStateData value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerStateData>(value),
    );
  }
}

String _$localPlayerStateHash() => r'dddb723e7e6985f445df075161add502d3a5ccca';

abstract class _$LocalPlayerState extends $Notifier<PlayerStateData> {
  PlayerStateData build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PlayerStateData, PlayerStateData>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerStateData, PlayerStateData>,
              PlayerStateData,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LocalPlayerSequence)
final localPlayerSequenceProvider = LocalPlayerSequenceProvider._();

final class LocalPlayerSequenceProvider
    extends $NotifierProvider<LocalPlayerSequence, SequenceStateData?> {
  LocalPlayerSequenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerSequenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerSequenceHash();

  @$internal
  @override
  LocalPlayerSequence create() => LocalPlayerSequence();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SequenceStateData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SequenceStateData?>(value),
    );
  }
}

String _$localPlayerSequenceHash() =>
    r'a182f5c60951d7ade9a4a3c38f7a48b884e87bf4';

abstract class _$LocalPlayerSequence extends $Notifier<SequenceStateData?> {
  SequenceStateData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SequenceStateData?, SequenceStateData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SequenceStateData?, SequenceStateData?>,
              SequenceStateData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LocalPlayerVolume)
final localPlayerVolumeProvider = LocalPlayerVolumeProvider._();

final class LocalPlayerVolumeProvider
    extends $NotifierProvider<LocalPlayerVolume, double> {
  LocalPlayerVolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerVolumeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerVolumeHash();

  @$internal
  @override
  LocalPlayerVolume create() => LocalPlayerVolume();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$localPlayerVolumeHash() => r'fee731899d6590aa47dcbd298955416b9fae3bf6';

abstract class _$LocalPlayerVolume extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LocalPlayerDuration)
final localPlayerDurationProvider = LocalPlayerDurationProvider._();

final class LocalPlayerDurationProvider
    extends $NotifierProvider<LocalPlayerDuration, Duration?> {
  LocalPlayerDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlayerDurationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlayerDurationHash();

  @$internal
  @override
  LocalPlayerDuration create() => LocalPlayerDuration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration?>(value),
    );
  }
}

String _$localPlayerDurationHash() =>
    r'e589b8c873cd764cdc81c5d693da616780fc6c35';

abstract class _$LocalPlayerDuration extends $Notifier<Duration?> {
  Duration? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Duration?, Duration?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Duration?, Duration?>,
              Duration?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Owns local (just_audio) playback and emits a [PlayerStatus] view of it.
///
/// Returns `null` when the active zone is missing or remote. The unified
/// [Player] provider watches this one for the local/offline branch.

@ProviderFor(LocalPlayer)
final localPlayerProvider = LocalPlayerProvider._();

/// Owns local (just_audio) playback and emits a [PlayerStatus] view of it.
///
/// Returns `null` when the active zone is missing or remote. The unified
/// [Player] provider watches this one for the local/offline branch.
final class LocalPlayerProvider
    extends $AsyncNotifierProvider<LocalPlayer, PlayerStatus?> {
  /// Owns local (just_audio) playback and emits a [PlayerStatus] view of it.
  ///
  /// Returns `null` when the active zone is missing or remote. The unified
  /// [Player] provider watches this one for the local/offline branch.
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
}

String _$localPlayerHash() => r'faae0f77501ec9821e9e72fadcf365f983f2e92a';

/// Owns local (just_audio) playback and emits a [PlayerStatus] view of it.
///
/// Returns `null` when the active zone is missing or remote. The unified
/// [Player] provider watches this one for the local/offline branch.

abstract class _$LocalPlayer extends $AsyncNotifier<PlayerStatus?> {
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

@ProviderFor(localPlaybackState)
final localPlaybackStateProvider = LocalPlaybackStateProvider._();

final class LocalPlaybackStateProvider
    extends
        $FunctionalProvider<
          LocalPlaybackState,
          LocalPlaybackState,
          LocalPlaybackState
        >
    with $Provider<LocalPlaybackState> {
  LocalPlaybackStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localPlaybackStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localPlaybackStateHash();

  @$internal
  @override
  $ProviderElement<LocalPlaybackState> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalPlaybackState create(Ref ref) {
    return localPlaybackState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalPlaybackState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalPlaybackState>(value),
    );
  }
}

String _$localPlaybackStateHash() =>
    r'b4d809dcb40933361afa3d8b69ca804d5bc27560';
