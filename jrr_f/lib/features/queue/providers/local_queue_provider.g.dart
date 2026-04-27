// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalQueue)
final localQueueProvider = LocalQueueProvider._();

final class LocalQueueProvider
    extends $AsyncNotifierProvider<LocalQueue, List<Track>> {
  LocalQueueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localQueueProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localQueueHash();

  @$internal
  @override
  LocalQueue create() => LocalQueue();
}

String _$localQueueHash() => r'54f650af9ba94b0846089155f7b358a968bb6b46';

abstract class _$LocalQueue extends $AsyncNotifier<List<Track>> {
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
