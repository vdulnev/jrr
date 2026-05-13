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

String _$librarySearchHash() => r'5588367caabd023cc8a9047460a6285cbefe0765';

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

String _$artistsHash() => r'20e9952c55d0e952679d57d73ca0064286d705a3';

@ProviderFor(albumsByArtist)
final albumsByArtistProvider = AlbumsByArtistFamily._();

final class AlbumsByArtistProvider
    extends $FunctionalProvider<AsyncValue<Albums>, Albums, FutureOr<Albums>>
    with $FutureModifier<Albums>, $FutureProvider<Albums> {
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
  $FutureProviderElement<Albums> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Albums> create(Ref ref) {
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

String _$albumsByArtistHash() => r'4351259d20546885d209469e763e457432f43d80';

final class AlbumsByArtistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Albums>, String> {
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

@ProviderFor(albumGroupsByArtist)
final albumGroupsByArtistProvider = AlbumGroupsByArtistFamily._();

final class AlbumGroupsByArtistProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<AlbumGroup>>,
          List<AlbumGroup>,
          FutureOr<List<AlbumGroup>>
        >
    with $FutureModifier<List<AlbumGroup>>, $FutureProvider<List<AlbumGroup>> {
  AlbumGroupsByArtistProvider._({
    required AlbumGroupsByArtistFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'albumGroupsByArtistProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$albumGroupsByArtistHash();

  @override
  String toString() {
    return r'albumGroupsByArtistProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<AlbumGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<AlbumGroup>> create(Ref ref) {
    final argument = this.argument as String;
    return albumGroupsByArtist(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AlbumGroupsByArtistProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$albumGroupsByArtistHash() =>
    r'015d774c68ce6ee926226b19c3135bd704b241ee';

final class AlbumGroupsByArtistFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<AlbumGroup>>, String> {
  AlbumGroupsByArtistFamily._()
    : super(
        retry: null,
        name: r'albumGroupsByArtistProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AlbumGroupsByArtistProvider call(String artist) =>
      AlbumGroupsByArtistProvider._(argument: artist, from: this);

  @override
  String toString() => r'albumGroupsByArtistProvider';
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

String _$albumTracksHash() => r'5ec5a631ac021511c56cbcf3233fb20c77098bab';

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

String _$folderTracksHash() => r'4fe6abc100e7fdaa387091b27b48c123b1acbe41';

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
    extends $FunctionalProvider<AsyncValue<Albums>, Albums, FutureOr<Albums>>
    with $FutureModifier<Albums>, $FutureProvider<Albums> {
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
  $FutureProviderElement<Albums> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Albums> create(Ref ref) {
    return randomAlbums(ref);
  }
}

String _$randomAlbumsHash() => r'e5d20c882ecab2914fbcd5b8dada7e98a821c12b';

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

String _$browseChildrenHash() => r'efa3fcb5a8938a5d5d68bc3cd3dcf7957c93c3f9';

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

String _$browseFilesHash() => r'ff37551ec9882ad185ddf77667927ac0620e751d';

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

String _$searchByFileKeyHash() => r'a908e3984040f23c339fab79b806766aab8dd84f';

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
