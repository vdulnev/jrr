// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NavigationNotifier)
final navigationProvider = NavigationNotifierProvider._();

final class NavigationNotifierProvider
    extends
        $NotifierProvider<NavigationNotifier, List<PageRouteInfo<Object?>>> {
  NavigationNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationNotifierHash();

  @$internal
  @override
  NavigationNotifier create() => NavigationNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PageRouteInfo<Object?>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<PageRouteInfo<Object?>>>(value),
    );
  }
}

String _$navigationNotifierHash() =>
    r'727eee99e9a1bb4acd70c3517a50f1cb05e26d47';

abstract class _$NavigationNotifier
    extends $Notifier<List<PageRouteInfo<Object?>>> {
  List<PageRouteInfo<Object?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<List<PageRouteInfo<Object?>>, List<PageRouteInfo<Object?>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                List<PageRouteInfo<Object?>>,
                List<PageRouteInfo<Object?>>
              >,
              List<PageRouteInfo<Object?>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveTab)
final activeTabProvider = ActiveTabProvider._();

final class ActiveTabProvider extends $NotifierProvider<ActiveTab, AppTab> {
  ActiveTabProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTabProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTabHash();

  @$internal
  @override
  ActiveTab create() => ActiveTab();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppTab value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppTab>(value),
    );
  }
}

String _$activeTabHash() => r'bed30a98366ad65b53769190ed60ee3baaf81f09';

abstract class _$ActiveTab extends $Notifier<AppTab> {
  AppTab build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppTab, AppTab>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppTab, AppTab>,
              AppTab,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
