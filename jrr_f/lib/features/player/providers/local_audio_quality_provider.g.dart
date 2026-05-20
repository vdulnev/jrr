// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_audio_quality_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Selected MCWS conversion preset for the local zone.
/// Persisted to SharedPreferences so it survives restarts.

@ProviderFor(LocalAudioQualityPref)
final localAudioQualityPrefProvider = LocalAudioQualityPrefProvider._();

/// Selected MCWS conversion preset for the local zone.
/// Persisted to SharedPreferences so it survives restarts.
final class LocalAudioQualityPrefProvider
    extends $NotifierProvider<LocalAudioQualityPref, LocalAudioQuality> {
  /// Selected MCWS conversion preset for the local zone.
  /// Persisted to SharedPreferences so it survives restarts.
  LocalAudioQualityPrefProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localAudioQualityPrefProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localAudioQualityPrefHash();

  @$internal
  @override
  LocalAudioQualityPref create() => LocalAudioQualityPref();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalAudioQuality value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalAudioQuality>(value),
    );
  }
}

String _$localAudioQualityPrefHash() =>
    r'97e19e5591f909ed811dfc7721dd916ea9e98f93';

/// Selected MCWS conversion preset for the local zone.
/// Persisted to SharedPreferences so it survives restarts.

abstract class _$LocalAudioQualityPref extends $Notifier<LocalAudioQuality> {
  LocalAudioQuality build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LocalAudioQuality, LocalAudioQuality>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalAudioQuality, LocalAudioQuality>,
              LocalAudioQuality,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
