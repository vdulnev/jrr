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
