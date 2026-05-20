// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_manager_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ServerManagerViewModel)
final serverManagerViewModelProvider = ServerManagerViewModelProvider._();

final class ServerManagerViewModelProvider
    extends $NotifierProvider<ServerManagerViewModel, ServerManagerViewState> {
  ServerManagerViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverManagerViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverManagerViewModelHash();

  @$internal
  @override
  ServerManagerViewModel create() => ServerManagerViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ServerManagerViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ServerManagerViewState>(value),
    );
  }
}

String _$serverManagerViewModelHash() =>
    r'554d6a2c4cfd3ebfd7c5793cfad8ad925f712fb3';

abstract class _$ServerManagerViewModel
    extends $Notifier<ServerManagerViewState> {
  ServerManagerViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<ServerManagerViewState, ServerManagerViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ServerManagerViewState, ServerManagerViewState>,
              ServerManagerViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
