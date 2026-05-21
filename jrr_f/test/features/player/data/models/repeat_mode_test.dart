import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';

void main() {
  group('RepeatMode.fromMcws', () {
    test('maps known values, case-insensitive', () {
      expect(RepeatMode.fromMcws('Playlist'), RepeatMode.playlist);
      expect(RepeatMode.fromMcws('playlist'), RepeatMode.playlist);
      expect(RepeatMode.fromMcws('Track'), RepeatMode.track);
      expect(RepeatMode.fromMcws('TRACK'), RepeatMode.track);
    });

    test('falls back to off for unknown or empty input', () {
      expect(RepeatMode.fromMcws('Off'), RepeatMode.off);
      expect(RepeatMode.fromMcws(''), RepeatMode.off);
      expect(RepeatMode.fromMcws('garbage'), RepeatMode.off);
    });
  });

  group('RepeatMode.toMcws', () {
    test('emits TitleCase MCWS strings', () {
      expect(RepeatMode.off.toMcws(), 'Off');
      expect(RepeatMode.playlist.toMcws(), 'Playlist');
      expect(RepeatMode.track.toMcws(), 'Track');
    });

    test('round-trips through fromMcws', () {
      for (final mode in RepeatMode.values) {
        expect(RepeatMode.fromMcws(mode.toMcws()), mode);
      }
    });
  });
}
