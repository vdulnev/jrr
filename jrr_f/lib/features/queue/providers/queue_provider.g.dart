// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Queue)
final queueProvider = QueueProvider._();

final class QueueProvider extends $AsyncNotifierProvider<Queue, Tracks> {
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

String _$queueHash() => r'67dfc20200348dcbcb95332ee2ad5875af3b0070';

abstract class _$Queue extends $AsyncNotifier<Tracks> {
  FutureOr<Tracks> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Tracks>, Tracks>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Tracks>, Tracks>,
              AsyncValue<Tracks>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
