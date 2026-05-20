// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album_row_tile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlbumRowTileViewModel)
final albumRowTileViewModelProvider = AlbumRowTileViewModelFamily._();

final class AlbumRowTileViewModelProvider
    extends $NotifierProvider<AlbumRowTileViewModel, AlbumRowTileViewState> {
  AlbumRowTileViewModelProvider._({
    required AlbumRowTileViewModelFamily super.from,
    required Album super.argument,
  }) : super(
         retry: null,
         name: r'albumRowTileViewModelProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumRowTileViewModelHash();

  @override
  String toString() {
    return r'albumRowTileViewModelProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AlbumRowTileViewModel create() => AlbumRowTileViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlbumRowTileViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlbumRowTileViewState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumRowTileViewModelProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumRowTileViewModelHash() =>
    r'3248d8c4510226100618b387ce7369019cbef7f0';

final class AlbumRowTileViewModelFamily extends $Family
    with
        $ClassFamilyOverride<
          AlbumRowTileViewModel,
          AlbumRowTileViewState,
          AlbumRowTileViewState,
          AlbumRowTileViewState,
          Album
        > {
  AlbumRowTileViewModelFamily._()
    : super(
        retry: null,
        name: r'albumRowTileViewModelProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumRowTileViewModelProvider call(Album album) =>
      AlbumRowTileViewModelProvider._(argument: album, from: this);

  @override
  String toString() => r'albumRowTileViewModelProvider';
}

abstract class _$AlbumRowTileViewModel
    extends $Notifier<AlbumRowTileViewState> {
  late final _$args = ref.$arg as Album;
  Album get album => _$args;

  AlbumRowTileViewState build(Album album);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AlbumRowTileViewState, AlbumRowTileViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AlbumRowTileViewState, AlbumRowTileViewState>,
              AlbumRowTileViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
