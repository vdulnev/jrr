// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_tracks_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadedTracks)
final downloadedTracksProvider = DownloadedTracksProvider._();

final class DownloadedTracksProvider
    extends $StreamNotifierProvider<DownloadedTracks, List<DownloadedTrack>> {
  DownloadedTracksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedTracksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedTracksHash();

  @$internal
  @override
  DownloadedTracks create() => DownloadedTracks();
}

String _$downloadedTracksHash() => r'93129a86b1db6dd94983bb55a7c5874b5edaa48f';

abstract class _$DownloadedTracks
    extends $StreamNotifier<List<DownloadedTrack>> {
  Stream<List<DownloadedTrack>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<DownloadedTrack>>, List<DownloadedTrack>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<DownloadedTrack>>,
                List<DownloadedTrack>
              >,
              AsyncValue<List<DownloadedTrack>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(downloadedArtists)
final downloadedArtistsProvider = DownloadedArtistsProvider._();

final class DownloadedArtistsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  DownloadedArtistsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedArtistsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedArtistsHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return downloadedArtists(ref);
  }
}

String _$downloadedArtistsHash() => r'829f3461350659fe64ad29b2dcf37654946346b1';

@ProviderFor(downloadedAlbums)
final downloadedAlbumsProvider = DownloadedAlbumsFamily._();

final class DownloadedAlbumsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Album>>,
          List<Album>,
          FutureOr<List<Album>>
        >
    with $FutureModifier<List<Album>>, $FutureProvider<List<Album>> {
  DownloadedAlbumsProvider._({
    required DownloadedAlbumsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'downloadedAlbumsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadedAlbumsHash();

  @override
  String toString() {
    return r'downloadedAlbumsProvider'
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
    return downloadedAlbums(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadedAlbumsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadedAlbumsHash() => r'2c30b81f61a8f37b60ebe8df2db3ba1ae7eaa242';

final class DownloadedAlbumsFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Album>>, String> {
  DownloadedAlbumsFamily._()
    : super(
        retry: null,
        name: r'downloadedAlbumsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadedAlbumsProvider call(String artist) =>
      DownloadedAlbumsProvider._(argument: artist, from: this);

  @override
  String toString() => r'downloadedAlbumsProvider';
}

@ProviderFor(downloadedAlbumTracks)
final downloadedAlbumTracksProvider = DownloadedAlbumTracksFamily._();

final class DownloadedAlbumTracksProvider
    extends $FunctionalProvider<AsyncValue<Tracks>, Tracks, FutureOr<Tracks>>
    with $FutureModifier<Tracks>, $FutureProvider<Tracks> {
  DownloadedAlbumTracksProvider._({
    required DownloadedAlbumTracksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'downloadedAlbumTracksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadedAlbumTracksHash();

  @override
  String toString() {
    return r'downloadedAlbumTracksProvider'
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
    return downloadedAlbumTracks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadedAlbumTracksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadedAlbumTracksHash() =>
    r'8f6c588312f4e30c26cde5574ebc28f4c26eba15';

final class DownloadedAlbumTracksFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Tracks>, String> {
  DownloadedAlbumTracksFamily._()
    : super(
        retry: null,
        name: r'downloadedAlbumTracksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadedAlbumTracksProvider call(String albumGroupId) =>
      DownloadedAlbumTracksProvider._(argument: albumGroupId, from: this);

  @override
  String toString() => r'downloadedAlbumTracksProvider';
}
