import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/models/player_state_data.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  group('PlayerStateData', () {
    test('stores playing and processingState', () {
      const data = PlayerStateData(
        playing: true,
        processingState: ProcessingState.ready,
      );
      expect(data.playing, isTrue);
      expect(data.processingState, ProcessingState.ready);
    });

    test('equality compares by value', () {
      const a = PlayerStateData(
        playing: false,
        processingState: ProcessingState.idle,
      );
      const b = PlayerStateData(
        playing: false,
        processingState: ProcessingState.idle,
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when fields differ', () {
      const a = PlayerStateData(
        playing: true,
        processingState: ProcessingState.ready,
      );
      const b = PlayerStateData(
        playing: false,
        processingState: ProcessingState.ready,
      );
      expect(a, isNot(equals(b)));
    });

    test('copyWith replaces playing', () {
      const a = PlayerStateData(
        playing: false,
        processingState: ProcessingState.ready,
      );
      expect(a.copyWith(playing: true).playing, isTrue);
    });
  });
}
