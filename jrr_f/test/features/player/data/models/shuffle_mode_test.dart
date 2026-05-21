import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';

void main() {
  group('ShuffleMode.fromMcws', () {
    test('maps known values, case-insensitive', () {
      expect(ShuffleMode.fromMcws('On'), ShuffleMode.on);
      expect(ShuffleMode.fromMcws('ON'), ShuffleMode.on);
      expect(ShuffleMode.fromMcws('Automatic'), ShuffleMode.automatic);
      expect(ShuffleMode.fromMcws('automatic'), ShuffleMode.automatic);
    });

    test('falls back to off for unknown or empty input', () {
      expect(ShuffleMode.fromMcws('Off'), ShuffleMode.off);
      expect(ShuffleMode.fromMcws(''), ShuffleMode.off);
      expect(ShuffleMode.fromMcws('nope'), ShuffleMode.off);
    });
  });

  group('ShuffleMode.toMcws', () {
    test('emits TitleCase MCWS strings', () {
      expect(ShuffleMode.off.toMcws(), 'Off');
      expect(ShuffleMode.on.toMcws(), 'On');
      expect(ShuffleMode.automatic.toMcws(), 'Automatic');
    });

    test('round-trips through fromMcws', () {
      for (final mode in ShuffleMode.values) {
        expect(ShuffleMode.fromMcws(mode.toMcws()), mode);
      }
    });
  });
}
