import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/di/injection.dart';
import '../data/models/local_audio_quality.dart';

part 'local_audio_quality_provider.g.dart';

const _kQualityKey = 'local_audio_quality';

/// Selected MCWS conversion preset for the local zone.
/// Persisted to SharedPreferences so it survives restarts.
@Riverpod(keepAlive: true)
class LocalAudioQualityPref extends _$LocalAudioQualityPref {
  @override
  LocalAudioQuality build() {
    final prefs = getIt<SharedPreferences>();
    return LocalAudioQuality.fromName(prefs.getString(_kQualityKey));
  }

  Future<void> set(LocalAudioQuality quality) async {
    final prefs = getIt<SharedPreferences>();
    await prefs.setString(_kQualityKey, quality.name);
    state = quality;
  }
}
