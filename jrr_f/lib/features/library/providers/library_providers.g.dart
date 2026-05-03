// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(librarySearch)
final librarySearchProvider = LibrarySearchFamily._();

final class LibrarySearchProvider
    extends $FunctionalProvider<AsyncValue<Tracks>, Tracks, FutureOr<Tracks>>
    with $FutureModifier<Tracks>, $FutureProvider<Tracks> {
  LibrarySearchProvider._({
    required LibrarySearchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'librarySearchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$librarySearchHash();

  @override
  String toString() {
    return r'librarySearchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Tracks> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tracks> create(Ref ref) {
    final argument = this.argument as String;
    return librarySearch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LibrarySearchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$librarySearchHash() => r'1003470390ebf6ae9698e05a76b4018a573d8494';

final class LibrarySearchFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tracks>, String> {
  LibrarySearchFamily._()
    : super(
        retry: null,
        name: r'librarySearchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LibrarySearchProvider call(String query) =>
      LibrarySearchProvider._(argument: query, from: this);

  @override
  String toString() => r'librarySearchProvider';
}

@ProviderFor(artists)
final artistsProvider = ArtistsProvider._();

final class ArtistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  ArtistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'artistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$artistsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return artists(ref);
  }
}

String _$artistsHash() => r'4cbbd91ebb3c9004e2760871afc24ff9076489d6';

@ProviderFor(albumsByArtist)
final albumsByArtistProvider = AlbumsByArtistFamily._();

final class AlbumsByArtistProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Album>>,
          List<Album>,
          FutureOr<List<Album>>
        >
    with $FutureModifier<List<Album>>, $FutureProvider<List<Album>> {
  AlbumsByArtistProvider._({
    required AlbumsByArtistFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'albumsByArtistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumsByArtistHash();

  @override
  String toString() {
    return r'albumsByArtistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Album>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Album>> create(Ref ref) {
    final argument = this.argument as String;
    return albumsByArtist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumsByArtistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumsByArtistHash() => r'b3de3261ca619288081f78cfdd82f86459fbc092';

final class AlbumsByArtistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Album>>, String> {
  AlbumsByArtistFamily._()
    : super(
        retry: null,
        name: r'albumsByArtistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumsByArtistProvider call(String artist) =>
      AlbumsByArtistProvider._(argument: artist, from: this);

  @override
  String toString() => r'albumsByArtistProvider';
}

@ProviderFor(albumTracks)
final albumTracksProvider = AlbumTracksFamily._();

final class AlbumTracksProvider
    extends $FunctionalProvider<AsyncValue<Tracks>, Tracks, FutureOr<Tracks>>
    with $FutureModifier<Tracks>, $FutureProvider<Tracks> {
  AlbumTracksProvider._({
    required AlbumTracksFamily super.from,
    required Album super.argument,
  }) : super(
         retry: null,
         name: r'albumTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumTracksHash();

  @override
  String toString() {
    return r'albumTracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Tracks> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tracks> create(Ref ref) {
    final argument = this.argument as Album;
    return albumTracks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumTracksHash() => r'11f919d1f43201cd9e5dd4aeb867244d46e870a7';

final class AlbumTracksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tracks>, Album> {
  AlbumTracksFamily._()
    : super(
        retry: null,
        name: r'albumTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumTracksProvider call(Album album) =>
      AlbumTracksProvider._(argument: album, from: this);

  @override
  String toString() => r'albumTracksProvider';
}

@ProviderFor(folderTracks)
final folderTracksProvider = FolderTracksFamily._();

final class FolderTracksProvider
    extends $FunctionalProvider<AsyncValue<Tracks>, Tracks, FutureOr<Tracks>>
    with $FutureModifier<Tracks>, $FutureProvider<Tracks> {
  FolderTracksProvider._({
    required FolderTracksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'folderTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$folderTracksHash();

  @override
  String toString() {
    return r'folderTracksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Tracks> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tracks> create(Ref ref) {
    final argument = this.argument as String;
    return folderTracks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is FolderTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$folderTracksHash() => r'a94bb41d4871a89558e6dd344c99ccb472567784';

final class FolderTracksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tracks>, String> {
  FolderTracksFamily._()
    : super(
        retry: null,
        name: r'folderTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  FolderTracksProvider call(String folderPath) =>
      FolderTracksProvider._(argument: folderPath, from: this);

  @override
  String toString() => r'folderTracksProvider';
}

@ProviderFor(randomAlbums)
final randomAlbumsProvider = RandomAlbumsProvider._();

final class RandomAlbumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Album>>,
          List<Album>,
          FutureOr<List<Album>>
        >
    with $FutureModifier<List<Album>>, $FutureProvider<List<Album>> {
  RandomAlbumsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'randomAlbumsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$randomAlbumsHash();

  @$internal
  @override
  $FutureProviderElement<List<Album>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Album>> create(Ref ref) {
    return randomAlbums(ref);
  }
}

String _$randomAlbumsHash() => r'9fb024d3589734258215778e645178282d6c6cbd';

@ProviderFor(browseChildren)
final browseChildrenProvider = BrowseChildrenFamily._();

final class BrowseChildrenProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BrowseItem>>,
          List<BrowseItem>,
          FutureOr<List<BrowseItem>>
        >
    with $FutureModifier<List<BrowseItem>>, $FutureProvider<List<BrowseItem>> {
  BrowseChildrenProvider._({
    required BrowseChildrenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'browseChildrenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$browseChildrenHash();

  @override
  String toString() {
    return r'browseChildrenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<BrowseItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BrowseItem>> create(Ref ref) {
    final argument = this.argument as String;
    return browseChildren(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrowseChildrenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$browseChildrenHash() => r'394fa24f2a41f6b316eff58dc8fe9164a1f13555';

final class BrowseChildrenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<BrowseItem>>, String> {
  BrowseChildrenFamily._()
    : super(
        retry: null,
        name: r'browseChildrenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BrowseChildrenProvider call(String id) =>
      BrowseChildrenProvider._(argument: id, from: this);

  @override
  String toString() => r'browseChildrenProvider';
}

@ProviderFor(browseFiles)
final browseFilesProvider = BrowseFilesFamily._();

final class BrowseFilesProvider
    extends $FunctionalProvider<AsyncValue<Tracks>, Tracks, FutureOr<Tracks>>
    with $FutureModifier<Tracks>, $FutureProvider<Tracks> {
  BrowseFilesProvider._({
    required BrowseFilesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'browseFilesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$browseFilesHash();

  @override
  String toString() {
    return r'browseFilesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Tracks> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Tracks> create(Ref ref) {
    final argument = this.argument as String;
    return browseFiles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is BrowseFilesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$browseFilesHash() => r'd898bd86e4bf9573faa3a2f77e4ac7c8f9564d14';

final class BrowseFilesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tracks>, String> {
  BrowseFilesFamily._()
    : super(
        retry: null,
        name: r'browseFilesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  BrowseFilesProvider call(String id) =>
      BrowseFilesProvider._(argument: id, from: this);

  @override
  String toString() => r'browseFilesProvider';
}

@ProviderFor(searchByFileKey)
final searchByFileKeyProvider = SearchByFileKeyFamily._();

final class SearchByFileKeyProvider
    extends $FunctionalProvider<AsyncValue<Track?>, Track?, FutureOr<Track?>>
    with $FutureModifier<Track?>, $FutureProvider<Track?> {
  SearchByFileKeyProvider._({
    required SearchByFileKeyFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'searchByFileKeyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$searchByFileKeyHash();

  @override
  String toString() {
    return r'searchByFileKeyProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Track?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Track?> create(Ref ref) {
    final argument = this.argument as int;
    return searchByFileKey(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchByFileKeyProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$searchByFileKeyHash() => r'0bbfae24b7f3fda2a0da6447167d360512f3fb69';

final class SearchByFileKeyFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Track?>, int> {
  SearchByFileKeyFamily._()
    : super(
        retry: null,
        name: r'searchByFileKeyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SearchByFileKeyProvider call(int fileKey) =>
      SearchByFileKeyProvider._(argument: fileKey, from: this);

  @override
  String toString() => r'searchByFileKeyProvider';
}

@ProviderFor(BrowseNavigationStack)
final browseNavigationStackProvider = BrowseNavigationStackFamily._();

final class BrowseNavigationStackProvider
    extends $NotifierProvider<BrowseNavigationStack, List<BrowseItem>> {
  BrowseNavigationStackProvider._({
    required BrowseNavigationStackFamily super.from,
    required BrowseScope super.argument,
  }) : super(
         retry: null,
         name: r'browseNavigationStackProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$browseNavigationStackHash();

  @override
  String toString() {
    return r'browseNavigationStackProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  BrowseNavigationStack create() => BrowseNavigationStack();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BrowseItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BrowseItem>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BrowseNavigationStackProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$browseNavigationStackHash() =>
    r'8ba330ad1ae268245f60339ca1c521a21ba7efc8';

final class BrowseNavigationStackFamily extends $Family
    with
        $ClassFamilyOverride<
          BrowseNavigationStack,
          List<BrowseItem>,
          List<BrowseItem>,
          List<BrowseItem>,
          BrowseScope
        > {
  BrowseNavigationStackFamily._()
    : super(
        retry: null,
        name: r'browseNavigationStackProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  BrowseNavigationStackProvider call(BrowseScope scope) =>
      BrowseNavigationStackProvider._(argument: scope, from: this);

  @override
  String toString() => r'browseNavigationStackProvider';
}

abstract class _$BrowseNavigationStack extends $Notifier<List<BrowseItem>> {
  late final _$args = ref.$arg as BrowseScope;
  BrowseScope get scope => _$args;

  List<BrowseItem> build(BrowseScope scope);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<BrowseItem>, List<BrowseItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<BrowseItem>, List<BrowseItem>>,
              List<BrowseItem>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
