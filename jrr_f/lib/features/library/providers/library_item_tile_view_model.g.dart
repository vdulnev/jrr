// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_item_tile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LibraryItemTileViewModel)
final libraryItemTileViewModelProvider = LibraryItemTileViewModelFamily._();

final class LibraryItemTileViewModelProvider
    extends
        $NotifierProvider<LibraryItemTileViewModel, LibraryItemTileViewState> {
  LibraryItemTileViewModelProvider._({
    required LibraryItemTileViewModelFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'libraryItemTileViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$libraryItemTileViewModelHash();

  @override
  String toString() {
    return r'libraryItemTileViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  LibraryItemTileViewModel create() => LibraryItemTileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibraryItemTileViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibraryItemTileViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is LibraryItemTileViewModelProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$libraryItemTileViewModelHash() =>
    r'3d838faac70dcf78ffd4648ab410a6d329b09e88';

final class LibraryItemTileViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          LibraryItemTileViewModel,
          LibraryItemTileViewState,
          LibraryItemTileViewState,
          LibraryItemTileViewState,
          int
        > {
  LibraryItemTileViewModelFamily._()
    : super(
        retry: null,
        name: r'libraryItemTileViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibraryItemTileViewModelProvider call(int fileKey) =>
      LibraryItemTileViewModelProvider._(argument: fileKey, from: this);

  @override
  String toString() => r'libraryItemTileViewModelProvider';
}

abstract class _$LibraryItemTileViewModel
    extends $Notifier<LibraryItemTileViewState> {
  late final _$args = ref.$arg as int;
  int get fileKey => _$args;

  LibraryItemTileViewState build(int fileKey);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<LibraryItemTileViewState, LibraryItemTileViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibraryItemTileViewState, LibraryItemTileViewState>,
              LibraryItemTileViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
