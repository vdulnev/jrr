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

String _$activeZoneHash() => r'1d505924698e412f13d155b6e986a8f6f752faf6';

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
