// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'polling_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Polling)
final pollingProvider = PollingProvider._();

final class PollingProvider extends $NotifierProvider<Polling, void> {
  PollingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pollingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pollingHash();

  @$internal
  @override
  Polling create() => Polling();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pollingHash() => r'36408c07beb98ef9ec6a3f6c5c9fbc785ba2aab0';

abstract class _$Polling extends $Notifier<void> {
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
