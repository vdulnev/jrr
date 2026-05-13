// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_polling_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZonePolling)
final zonePollingProvider = ZonePollingProvider._();

final class ZonePollingProvider extends $NotifierProvider<ZonePolling, void> {
  ZonePollingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zonePollingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zonePollingHash();

  @$internal
  @override
  ZonePolling create() => ZonePolling();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$zonePollingHash() => r'13ff049143108d4e3f3a75ca2f9f38fea08d57d0';

abstract class _$ZonePolling extends $Notifier<void> {
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
