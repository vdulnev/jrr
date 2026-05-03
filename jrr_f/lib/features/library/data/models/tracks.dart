import 'package:freezed_annotation/freezed_annotation.dart';

import 'track.dart';

part 'tracks.freezed.dart';

@freezed
abstract class Tracks with _$Tracks {
  const factory Tracks({@Default(<Track>[]) List<Track> tracks}) = _Tracks;

  const Tracks._();

  static const Tracks empty = Tracks(tracks: []);

  factory Tracks.fromList(List<Track> tracks) => Tracks(tracks: tracks);

  int get length => tracks.length;
  bool get isEmpty => tracks.isEmpty;
  bool get isNotEmpty => tracks.isNotEmpty;
  Track operator [](int index) => tracks[index];
  Track? get firstOrNull => tracks.isEmpty ? null : tracks.first;
}
