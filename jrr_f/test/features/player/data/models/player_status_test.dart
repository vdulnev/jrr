import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/data/models/player_status.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';

PlayerStatus _base({
  String zoneId = 'z',
  PlaybackState state = PlaybackState.stopped,
}) => PlayerStatus(
  zoneId: zoneId,
  zoneName: 'Zone',
  state: state,
  positionMs: 0,
  durationMs: 0,
  positionDisplay: '0:00',
  playingNowPosition: 0,
  playingNowTracks: 0,
  playingNowPositionDisplay: '0/0',
  playingNowChangeCounter: 0,
  volume: 0,
  volumeDisplay: '0',
);

void main() {
  group('PlayerStatus', () {
    test('applies sensible defaults', () {
      final status = _base();
      expect(status.fileKey, -1);
      expect(status.nextFileKey, -1);
      expect(status.bitrate, 0);
      expect(status.bitDepth, 0);
      expect(status.sampleRate, 0);
      expect(status.channels, 0);
      expect(status.chapter, 0);
      expect(status.chapterList, isNull);
      expect(status.imageUrl, isEmpty);
      expect(status.artist, isEmpty);
      expect(status.album, isEmpty);
      expect(status.name, isEmpty);
      expect(status.rating, 0);
      expect(status.status, isEmpty);
      expect(status.linkedZones, isNull);
      expect(status.isMuted, isFalse);
      expect(status.shuffleMode, ShuffleMode.off);
      expect(status.repeatMode, RepeatMode.off);
    });

    test('equality compares by value', () {
      final a = _base(state: PlaybackState.playing);
      final b = _base(state: PlaybackState.playing);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when state differs', () {
      final a = _base(state: PlaybackState.playing);
      final b = _base(state: PlaybackState.paused);
      expect(a, isNot(equals(b)));
    });

    test('copyWith updates volume', () {
      final a = _base();
      final b = a.copyWith(volume: 0.5, volumeDisplay: '50');
      expect(b.volume, 0.5);
      expect(b.volumeDisplay, '50');
      expect(a.volume, 0);
    });
  });
}
