// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Queue)
final queueProvider = QueueProvider._();

final class QueueProvider
    extends $AsyncNotifierProvider<Queue, List<PlayingNowItem>> {
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

String _$queueHash() => r'2afb04f0d805035c3f53186933fa595fa42d45b6';

abstract class _$Queue extends $AsyncNotifier<List<PlayingNowItem>> {
  FutureOr<List<PlayingNowItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<PlayingNowItem>>, List<PlayingNowItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<PlayingNowItem>>,
                List<PlayingNowItem>
              >,
              AsyncValue<List<PlayingNowItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
