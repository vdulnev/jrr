// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_polling_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PlayerPolling)
final playerPollingProvider = PlayerPollingProvider._();

final class PlayerPollingProvider
    extends $NotifierProvider<PlayerPolling, void> {
  PlayerPollingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerPollingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerPollingHash();

  @$internal
  @override
  PlayerPolling create() => PlayerPolling();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$playerPollingHash() => r'b2972db2234de87b5e9212e3bc6d51e3fa626230';

abstract class _$PlayerPolling extends $Notifier<void> {
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
