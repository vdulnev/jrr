// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_jobs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DownloadJobs)
final downloadJobsProvider = DownloadJobsProvider._();

final class DownloadJobsProvider
    extends $StreamNotifierProvider<DownloadJobs, List<DownloadJob>> {
  DownloadJobsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'downloadJobsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$downloadJobsHash();

  @$internal
  @override
  DownloadJobs create() => DownloadJobs();
}

String _$downloadJobsHash() => r'f3cca2fc9b500c798da46fc640b081e9427fd68e';

abstract class _$DownloadJobs extends $StreamNotifier<List<DownloadJob>> {
  Stream<List<DownloadJob>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DownloadJob>>, List<DownloadJob>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DownloadJob>>, List<DownloadJob>>,
              AsyncValue<List<DownloadJob>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
