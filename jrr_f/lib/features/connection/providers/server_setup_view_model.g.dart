// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_setup_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerSetupViewModel)
final serverSetupViewModelProvider = ServerSetupViewModelProvider._();

final class ServerSetupViewModelProvider
    extends $NotifierProvider<ServerSetupViewModel, ServerSetupViewState> {
  ServerSetupViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverSetupViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverSetupViewModelHash();

  @$internal
  @override
  ServerSetupViewModel create() => ServerSetupViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerSetupViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerSetupViewState>(value),
    );
  }
}

String _$serverSetupViewModelHash() =>
    r'2f5514295ed89887a69cdf604a2faa282ede8184';

abstract class _$ServerSetupViewModel extends $Notifier<ServerSetupViewState> {
  ServerSetupViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ServerSetupViewState, ServerSetupViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerSetupViewState, ServerSetupViewState>,
              ServerSetupViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
