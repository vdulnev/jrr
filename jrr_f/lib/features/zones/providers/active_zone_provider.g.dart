// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_zone_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActiveZone)
final activeZoneProvider = ActiveZoneProvider._();

final class ActiveZoneProvider extends $NotifierProvider<ActiveZone, Zone?> {
  ActiveZoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeZoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeZoneHash();

  @$internal
  @override
  ActiveZone create() => ActiveZone();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Zone? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Zone?>(value),
    );
  }
}

String _$activeZoneHash() => r'552d6c5aba11344b65e3b2624811bb8c1f380035';

abstract class _$ActiveZone extends $Notifier<Zone?> {
  Zone? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Zone?, Zone?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Zone?, Zone?>,
              Zone?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(isOfflineActive)
final isOfflineActiveProvider = IsOfflineActiveProvider._();

final class IsOfflineActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsOfflineActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOfflineActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineActiveHash() => r'9cf17c41cf06fd86f96b7a91caa227c20e103b43';

@ProviderFor(isAndroidAutoActive)
final isAndroidAutoActiveProvider = IsAndroidAutoActiveProvider._();

final class IsAndroidAutoActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  IsAndroidAutoActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isAndroidAutoActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isAndroidAutoActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isAndroidAutoActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isAndroidAutoActiveHash() =>
    r'4e34af7b2f575d129d0a710ffaa1e25237a0cc8c';

/// True when the active zone uses downloaded files for library browsing
/// (Offline or Android Auto). Live MCWS library calls should be skipped.

@ProviderFor(isOfflineLikeActive)
final isOfflineLikeActiveProvider = IsOfflineLikeActiveProvider._();

/// True when the active zone uses downloaded files for library browsing
/// (Offline or Android Auto). Live MCWS library calls should be skipped.

final class IsOfflineLikeActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True when the active zone uses downloaded files for library browsing
  /// (Offline or Android Auto). Live MCWS library calls should be skipped.
  IsOfflineLikeActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isOfflineLikeActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isOfflineLikeActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isOfflineLikeActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isOfflineLikeActiveHash() =>
    r'10d5b7ef930427c96a6692c5ee10435e72f76e49';

/// True when the active zone is a virtual (non-MCWS) zone — Local, Offline,
/// or Android Auto. Used to skip server-side zone polling and routing.

@ProviderFor(isVirtualZoneActive)
final isVirtualZoneActiveProvider = IsVirtualZoneActiveProvider._();

/// True when the active zone is a virtual (non-MCWS) zone — Local, Offline,
/// or Android Auto. Used to skip server-side zone polling and routing.

final class IsVirtualZoneActiveProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// True when the active zone is a virtual (non-MCWS) zone — Local, Offline,
  /// or Android Auto. Used to skip server-side zone polling and routing.
  IsVirtualZoneActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isVirtualZoneActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isVirtualZoneActiveHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isVirtualZoneActive(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isVirtualZoneActiveHash() =>
    r'501b7e202dc2681c3f2785876955ad5629c939de';

/// Reactive mirror of [AndroidAutoSessionService.isConnected]. The zone
/// repository surfaces the AA zone only while this is `true`; the zone
/// list provider invalidates itself whenever this flips so the picker
/// updates on connect/disconnect.

@ProviderFor(AndroidAutoConnected)
final androidAutoConnectedProvider = AndroidAutoConnectedProvider._();

/// Reactive mirror of [AndroidAutoSessionService.isConnected]. The zone
/// repository surfaces the AA zone only while this is `true`; the zone
/// list provider invalidates itself whenever this flips so the picker
/// updates on connect/disconnect.
final class AndroidAutoConnectedProvider
    extends $NotifierProvider<AndroidAutoConnected, bool> {
  /// Reactive mirror of [AndroidAutoSessionService.isConnected]. The zone
  /// repository surfaces the AA zone only while this is `true`; the zone
  /// list provider invalidates itself whenever this flips so the picker
  /// updates on connect/disconnect.
  AndroidAutoConnectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'androidAutoConnectedProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$androidAutoConnectedHash();

  @$internal
  @override
  AndroidAutoConnected create() => AndroidAutoConnected();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$androidAutoConnectedHash() =>
    r'50945ac2de7b0f6f354ff1743e62cfc878729bed';

/// Reactive mirror of [AndroidAutoSessionService.isConnected]. The zone
/// repository surfaces the AA zone only while this is `true`; the zone
/// list provider invalidates itself whenever this flips so the picker
/// updates on connect/disconnect.

abstract class _$AndroidAutoConnected extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
