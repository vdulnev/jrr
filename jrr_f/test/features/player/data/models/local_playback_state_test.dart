import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/data/models/local_palyback_state.dart';
import 'package:jrr_f/features/player/data/models/player_state_data.dart';
import 'package:jrr_f/features/player/data/models/sequence_state_data.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  group('LocalPlaybackState.toString', () {
    const idle = PlayerStateData(
      playing: false,
      processingState: ProcessingState.idle,
    );

    test('reports None track when sequenceState is null', () {
      const state = LocalPlaybackState(
        playerState: idle,
        position: Duration.zero,
        volume: 0,
      );
      final str = state.toString();
      expect(str, contains('track: None'));
      expect(str, contains('FileKey: null'));
      expect(str, contains('vol: 0%'));
      expect(str, contains('pos: 00:00:00 / 00:00:00'));
    });

    test('formats duration components and includes track info', () {
      final sequence = SequenceStateData(
        sequence: Tracks.fromList(const [Track(fileKey: 42, name: 'Hello')]),
        currentIndex: 0,
        shuffleIndices: const [0],
        shuffleModeEnabled: true,
        loopMode: LoopMode.one,
      );
      const playing = PlayerStateData(
        playing: true,
        processingState: ProcessingState.ready,
      );
      final state = LocalPlaybackState(
        sequenceState: sequence,
        playerState: playing,
        position: const Duration(hours: 1, minutes: 2, seconds: 3),
        duration: const Duration(minutes: 5, seconds: 7),
        volume: 0.42,
      );
      final str = state.toString();
      expect(str, contains('playing: true'));
      expect(str, contains('pos: 01:02:03 / 00:05:07'));
      expect(str, contains('vol: 42%'));
      expect(str, contains('shuffle: true'));
      expect(str, contains('repeat: LoopMode.one'));
      expect(str, contains('track: Hello'));
      expect(str, contains('FileKey: 42'));
      expect(str, contains('queue: 1'));
    });
  });
}
