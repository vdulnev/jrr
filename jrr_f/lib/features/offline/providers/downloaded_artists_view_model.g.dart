// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_artists_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadedArtistsViewModel)
final downloadedArtistsViewModelProvider =
    DownloadedArtistsViewModelProvider._();

final class DownloadedArtistsViewModelProvider
    extends
        $NotifierProvider<
          DownloadedArtistsViewModel,
          DownloadedArtistsViewState
        > {
  DownloadedArtistsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadedArtistsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadedArtistsViewModelHash();

  @$internal
  @override
  DownloadedArtistsViewModel create() => DownloadedArtistsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadedArtistsViewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadedArtistsViewState>(value),
    );
  }
}

String _$downloadedArtistsViewModelHash() =>
    r'8c3725e686c9cd2df26f83bb62300fcd4fc8772c';

abstract class _$DownloadedArtistsViewModel
    extends $Notifier<DownloadedArtistsViewState> {
  DownloadedArtistsViewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<DownloadedArtistsViewState, DownloadedArtistsViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                DownloadedArtistsViewState,
                DownloadedArtistsViewState
              >,
              DownloadedArtistsViewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
