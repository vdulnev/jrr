// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'now_playing_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NowPlayingViewModel)
final nowPlayingViewModelProvider = NowPlayingViewModelProvider._();

final class NowPlayingViewModelProvider
    extends $NotifierProvider<NowPlayingViewModel, NowPlayingViewState> {
  NowPlayingViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nowPlayingViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nowPlayingViewModelHash();

  @$internal
  @override
  NowPlayingViewModel create() => NowPlayingViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NowPlayingViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NowPlayingViewState>(value),
    );
  }
}

String _$nowPlayingViewModelHash() =>
    r'd060d369f405c935e997709a33176cc9cab48a99';

abstract class _$NowPlayingViewModel extends $Notifier<NowPlayingViewState> {
  NowPlayingViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<NowPlayingViewState, NowPlayingViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<NowPlayingViewState, NowPlayingViewState>,
              NowPlayingViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
