// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mini_player_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MiniPlayerViewModel)
final miniPlayerViewModelProvider = MiniPlayerViewModelProvider._();

final class MiniPlayerViewModelProvider
    extends $NotifierProvider<MiniPlayerViewModel, MiniPlayerViewState> {
  MiniPlayerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miniPlayerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miniPlayerViewModelHash();

  @$internal
  @override
  MiniPlayerViewModel create() => MiniPlayerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiniPlayerViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiniPlayerViewState>(value),
    );
  }
}

String _$miniPlayerViewModelHash() =>
    r'cda8cf4202bfea5f13b37d961f0deec78be61e63';

abstract class _$MiniPlayerViewModel extends $Notifier<MiniPlayerViewState> {
  MiniPlayerViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<MiniPlayerViewState, MiniPlayerViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MiniPlayerViewState, MiniPlayerViewState>,
              MiniPlayerViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
