import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/local_audio_quality.dart';

void main() {
  group('LocalAudioQuality', () {
    test('exposes mcwsParams for each preset', () {
      expect(
        LocalAudioQuality.lossless.mcwsParams,
        'Conversion=flac&Quality=high',
      );
      expect(
        LocalAudioQuality.lossyHigh.mcwsParams,
        'Conversion=opus&Quality=high',
      );
      expect(
        LocalAudioQuality.lossyNormal.mcwsParams,
        'Conversion=opus&Quality=normal',
      );
      expect(
        LocalAudioQuality.lossyLow.mcwsParams,
        'Conversion=opus&Quality=low',
      );
    });

    test('label is human-readable', () {
      expect(LocalAudioQuality.lossless.label, 'Lossless');
      expect(LocalAudioQuality.lossyHigh.label, 'Lossy (high)');
      expect(LocalAudioQuality.lossyNormal.label, 'Lossy (normal)');
      expect(LocalAudioQuality.lossyLow.label, 'Lossy (low)');
    });

    test('fromName resolves an enum identifier', () {
      expect(
        LocalAudioQuality.fromName('lossless'),
        LocalAudioQuality.lossless,
      );
      expect(
        LocalAudioQuality.fromName('lossyHigh'),
        LocalAudioQuality.lossyHigh,
      );
      expect(
        LocalAudioQuality.fromName('lossyLow'),
        LocalAudioQuality.lossyLow,
      );
    });

    test('fromName falls back to lossless for unknown or null', () {
      expect(LocalAudioQuality.fromName(null), LocalAudioQuality.lossless);
      expect(LocalAudioQuality.fromName(''), LocalAudioQuality.lossless);
      expect(LocalAudioQuality.fromName('garbage'), LocalAudioQuality.lossless);
    });
  });
}
