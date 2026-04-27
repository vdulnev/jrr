// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Queue)
final queueProvider = QueueProvider._();

final class QueueProvider extends $AsyncNotifierProvider<Queue, List<Track>> {
  QueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queueHash();

  @$internal
  @override
  Queue create() => Queue();
}

String _$queueHash() => r'01187d55f09aacc99213da50337b12d4d658bde2';

abstract class _$Queue extends $AsyncNotifier<List<Track>> {
  FutureOr<List<Track>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Track>>, List<Track>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Track>>, List<Track>>,
              AsyncValue<List<Track>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
