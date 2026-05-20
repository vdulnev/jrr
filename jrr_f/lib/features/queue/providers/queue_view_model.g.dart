// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(QueueViewModel)
final queueViewModelProvider = QueueViewModelProvider._();

final class QueueViewModelProvider
    extends $NotifierProvider<QueueViewModel, QueueViewState> {
  QueueViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueViewModelHash();

  @$internal
  @override
  QueueViewModel create() => QueueViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueueViewState>(value),
    );
  }
}

String _$queueViewModelHash() => r'08f6d89c94f8ec18e386eb05a39b297eee759c0b';

abstract class _$QueueViewModel extends $Notifier<QueueViewState> {
  QueueViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<QueueViewState, QueueViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<QueueViewState, QueueViewState>,
              QueueViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
