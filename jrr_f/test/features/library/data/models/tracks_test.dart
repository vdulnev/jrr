import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';

void main() {
  group('Tracks', () {
    test('empty constant has zero length', () {
      expect(Tracks.empty.length, 0);
      expect(Tracks.empty.isEmpty, isTrue);
      expect(Tracks.empty.isNotEmpty, isFalse);
      expect(Tracks.empty.firstOrNull, isNull);
    });

    test('fromList wraps a list', () {
      const t1 = Track(fileKey: 1, name: 'a');
      const t2 = Track(fileKey: 2, name: 'b');
      final tracks = Tracks.fromList(const [t1, t2]);
      expect(tracks.length, 2);
      expect(tracks.isNotEmpty, isTrue);
      expect(tracks[0], t1);
      expect(tracks[1], t2);
      expect(tracks.firstOrNull, t1);
    });

    test('default constructor uses empty tracks list', () {
      const tracks = Tracks();
      expect(tracks.tracks, isEmpty);
    });
  });
}
