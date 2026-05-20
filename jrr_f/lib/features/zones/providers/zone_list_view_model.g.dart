// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZoneListViewModel)
final zoneListViewModelProvider = ZoneListViewModelProvider._();

final class ZoneListViewModelProvider
    extends $NotifierProvider<ZoneListViewModel, ZoneListViewState> {
  ZoneListViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneListViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneListViewModelHash();

  @$internal
  @override
  ZoneListViewModel create() => ZoneListViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZoneListViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZoneListViewState>(value),
    );
  }
}

String _$zoneListViewModelHash() => r'12bb77eb6967ebc1aeb03c1c6e499208d13ea9cb';

abstract class _$ZoneListViewModel extends $Notifier<ZoneListViewState> {
  ZoneListViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ZoneListViewState, ZoneListViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ZoneListViewState, ZoneListViewState>,
              ZoneListViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
