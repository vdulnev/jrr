// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zone_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZoneList)
final zoneListProvider = ZoneListProvider._();

final class ZoneListProvider extends $AsyncNotifierProvider<ZoneList, Zones> {
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

String _$zoneListHash() => r'066494d0944fcad0fb8d08e3546a1ba51997a069';

abstract class _$ZoneList extends $AsyncNotifier<Zones> {
  FutureOr<Zones> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Zones>, Zones>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Zones>, Zones>,
              AsyncValue<Zones>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
