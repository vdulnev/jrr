// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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

String _$activeTabHash() => r'2f1d87c54f7df6977b1b8c70b4301f62ba2434a2';

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
