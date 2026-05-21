import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/data/models/sequence_state_data.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  const tracks = [
    Track(fileKey: 1, name: 'one'),
    Track(fileKey: 2, name: 'two'),
  ];

  SequenceStateData build({int index = 0, Tracks? sequence}) =>
      SequenceStateData(
        sequence: sequence ?? Tracks.fromList(tracks),
        currentIndex: index,
        shuffleIndices: const [0, 1],
        shuffleModeEnabled: false,
        loopMode: LoopMode.off,
      );

  group('SequenceStateData.currentTrack', () {
    test('returns track at currentIndex inside range', () {
      expect(build(index: 0).currentTrack, tracks[0]);
      expect(build(index: 1).currentTrack, tracks[1]);
    });

    test('returns null for negative index', () {
      expect(build(index: -1).currentTrack, isNull);
    });

    test('returns null when index >= length', () {
      expect(build(index: 2).currentTrack, isNull);
    });

    test('returns null when sequence is empty', () {
      expect(build(index: 0, sequence: Tracks.empty).currentTrack, isNull);
    });
  });
}
