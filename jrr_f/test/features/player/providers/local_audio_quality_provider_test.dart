import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/player/data/models/local_audio_quality.dart';
import 'package:jrr_f/features/player/providers/local_audio_quality_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  Future<ProviderContainer> openContainer({
    Map<String, Object> seed = const {},
  }) async {
    SharedPreferences.setMockInitialValues(seed);
    prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('build() defaults to lossless when no preference is stored', () async {
    final container = await openContainer();
    expect(
      container.read(localAudioQualityPrefProvider),
      LocalAudioQuality.lossless,
    );
  });

  test('build() reads the stored preference', () async {
    final container = await openContainer(
      seed: {'local_audio_quality': 'lossyNormal'},
    );
    expect(
      container.read(localAudioQualityPrefProvider),
      LocalAudioQuality.lossyNormal,
    );
  });

  test('set() persists to prefs and updates state', () async {
    final container = await openContainer();

    await container
        .read(localAudioQualityPrefProvider.notifier)
        .set(LocalAudioQuality.lossyHigh);

    expect(
      container.read(localAudioQualityPrefProvider),
      LocalAudioQuality.lossyHigh,
    );
    expect(prefs.getString('local_audio_quality'), 'lossyHigh');
  });
}
