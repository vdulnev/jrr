import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';

@freezed
abstract class Track with _$Track {
  const factory Track({
    required String fileKey,
    required String name,
    required String artist,
    required String album,
    @Default('') String genre,
    @Default(0) double duration,
    @Default(0) int trackNumber,
    @Default(0) int discNumber,
    @Default('') String imageUrl,
    @Default(0) int bitrate,
    @Default(0) int bitDepth,
    @Default(0) int sampleRate,
    @Default(0) int channels,
  }) = _Track;
}
