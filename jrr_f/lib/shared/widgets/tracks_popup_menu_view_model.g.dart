// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracks_popup_menu_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TracksPopupMenuViewModel)
final tracksPopupMenuViewModelProvider = TracksPopupMenuViewModelFamily._();

final class TracksPopupMenuViewModelProvider
    extends
        $NotifierProvider<TracksPopupMenuViewModel, TracksPopupMenuViewState> {
  TracksPopupMenuViewModelProvider._({
    required TracksPopupMenuViewModelFamily super.from,
    required Tracks super.argument,
  }) : super(
         retry: null,
         name: r'tracksPopupMenuViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tracksPopupMenuViewModelHash();

  @override
  String toString() {
    return r'tracksPopupMenuViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TracksPopupMenuViewModel create() => TracksPopupMenuViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TracksPopupMenuViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TracksPopupMenuViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TracksPopupMenuViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tracksPopupMenuViewModelHash() =>
    r'a2d11f62ef685534e43040f7a14df7861274a67f';

final class TracksPopupMenuViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          TracksPopupMenuViewModel,
          TracksPopupMenuViewState,
          TracksPopupMenuViewState,
          TracksPopupMenuViewState,
          Tracks
        > {
  TracksPopupMenuViewModelFamily._()
    : super(
        retry: null,
        name: r'tracksPopupMenuViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TracksPopupMenuViewModelProvider call(Tracks tracks) =>
      TracksPopupMenuViewModelProvider._(argument: tracks, from: this);

  @override
  String toString() => r'tracksPopupMenuViewModelProvider';
}

abstract class _$TracksPopupMenuViewModel
    extends $Notifier<TracksPopupMenuViewState> {
  late final _$args = ref.$arg as Tracks;
  Tracks get tracks => _$args;

  TracksPopupMenuViewState build(Tracks tracks);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<TracksPopupMenuViewState, TracksPopupMenuViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TracksPopupMenuViewState, TracksPopupMenuViewState>,
              TracksPopupMenuViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
