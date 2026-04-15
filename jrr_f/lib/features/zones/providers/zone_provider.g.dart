// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZoneList)
final zoneListProvider = ZoneListProvider._();

final class ZoneListProvider
    extends $AsyncNotifierProvider<ZoneList, List<Zone>> {
  ZoneListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zoneListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zoneListHash();

  @$internal
  @override
  ZoneList create() => ZoneList();
}

String _$zoneListHash() => r'4a70c6729cd424a2891cebc11492405d15fa03e8';

abstract class _$ZoneList extends $AsyncNotifier<List<Zone>> {
  FutureOr<List<Zone>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Zone>>, List<Zone>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Zone>>, List<Zone>>,
              AsyncValue<List<Zone>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
