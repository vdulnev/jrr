// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_status_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(downloadStatus)
final downloadStatusProvider = DownloadStatusFamily._();

final class DownloadStatusProvider
    extends $FunctionalProvider<DownloadState, DownloadState, DownloadState>
    with $Provider<DownloadState> {
  DownloadStatusProvider._({
    required DownloadStatusFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'downloadStatusProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadStatusHash();

  @override
  String toString() {
    return r'downloadStatusProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<DownloadState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DownloadState create(Ref ref) {
    final argument = this.argument as int;
    return downloadStatus(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DownloadState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DownloadState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadStatusProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadStatusHash() => r'9a7f3ef8fe19b3a0f5a33b65f917c0e78fc29308';

final class DownloadStatusFamily extends $Family
    with $FunctionalFamilyOverride<DownloadState, int> {
  DownloadStatusFamily._()
    : super(
        retry: null,
        name: r'downloadStatusProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadStatusProvider call(int fileKey) =>
      DownloadStatusProvider._(argument: fileKey, from: this);

  @override
  String toString() => r'downloadStatusProvider';
}

@ProviderFor(downloadProgress)
final downloadProgressProvider = DownloadProgressFamily._();

final class DownloadProgressProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  DownloadProgressProvider._({
    required DownloadProgressFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'downloadProgressProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$downloadProgressHash();

  @override
  String toString() {
    return r'downloadProgressProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as int;
    return downloadProgress(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DownloadProgressProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$downloadProgressHash() => r'9f8d54cd1608da515b04f53e86e17dec5d0f096e';

final class DownloadProgressFamily extends $Family
    with $FunctionalFamilyOverride<double, int> {
  DownloadProgressFamily._()
    : super(
        retry: null,
        name: r'downloadProgressProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DownloadProgressProvider call(int fileKey) =>
      DownloadProgressProvider._(argument: fileKey, from: this);

  @override
  String toString() => r'downloadProgressProvider';
}
