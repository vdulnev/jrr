// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
    r'677c239b88b002d70c2a1e174a195047e26ec4be';

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

String _$localPlayerStateHash() => r'3faf31e1c7e7863ac89924f883d54811f108208f';

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
    r'b445a65bec65041122b9a5504381f1a34a66d37b';

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

String _$localPlayerVolumeHash() => r'adc1e4654e4c5afe2fb12a2a2232d3c22125c224';

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
    r'5cb2a43f9fe139412a86706503460cdb83b20645';

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

@ProviderFor(LocalPlayer)
final localPlayerProvider = LocalPlayerProvider._();

final class LocalPlayerProvider extends $NotifierProvider<LocalPlayer, void> {
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
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$localPlayerHash() => r'd3cad609e8490c45feeca869f8af1a5654ea2006';

abstract class _$LocalPlayer extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
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
