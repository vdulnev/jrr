// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_setup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds the submission state for [ServerSetupScreen].
/// null  = idle, AsyncLoading = connecting, AsyncError = failed.
/// Auto-disposed when the screen leaves the tree.

@ProviderFor(ServerSetupForm)
final serverSetupFormProvider = ServerSetupFormProvider._();

/// Holds the submission state for [ServerSetupScreen].
/// null  = idle, AsyncLoading = connecting, AsyncError = failed.
/// Auto-disposed when the screen leaves the tree.
final class ServerSetupFormProvider
    extends $NotifierProvider<ServerSetupForm, AsyncValue<void>?> {
  /// Holds the submission state for [ServerSetupScreen].
  /// null  = idle, AsyncLoading = connecting, AsyncError = failed.
  /// Auto-disposed when the screen leaves the tree.
  ServerSetupFormProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'serverSetupFormProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$serverSetupFormHash();

  @$internal
  @override
  ServerSetupForm create() => ServerSetupForm();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>?>(value),
    );
  }
}

String _$serverSetupFormHash() => r'e0d0e499c04e6a78b2d3e55a1bd13355fa063715';

/// Holds the submission state for [ServerSetupScreen].
/// null  = idle, AsyncLoading = connecting, AsyncError = failed.
/// Auto-disposed when the screen leaves the tree.

abstract class _$ServerSetupForm extends $Notifier<AsyncValue<void>?> {
  AsyncValue<void>? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>?, AsyncValue<void>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>?, AsyncValue<void>?>,
              AsyncValue<void>?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
