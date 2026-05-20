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
    r'95c9ed32307b83a50c4d6a1fe7bf39bcf8f44c4a';

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
    r'100a1b54afb6718ddeeb43216db2088b4a518809';

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

String _$localPlayerStateHash() => r'88604d2dda321049dd9578c62efd816a755c04b2';

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
    r'fd1f99e8f23f298763320333309e52fe0b889ebb';

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

String _$localPlayerVolumeHash() => r'7bb8bce754df76feb7b0feb69961cbed01524960';

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
    r'6f4b1430ce4de3b0e33d40a91ffc18ecab15ba45';

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

String _$localPlayerHash() => r'74227d862d41c4e34aa817559fa800555b7d8094';

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
