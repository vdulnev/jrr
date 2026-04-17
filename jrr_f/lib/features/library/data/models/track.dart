import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
abstract class Track with _$Track {
  @JsonSerializable()
  const factory Track({
    @JsonKey(name: 'Key') required String fileKey,
    @JsonKey(name: 'Name') @Default('') String name,
    @JsonKey(name: 'Artist') @Default('') String artist,
    @JsonKey(name: 'Album') @Default('') String album,
    @JsonKey(name: 'Genre') @Default('') String genre,
    @JsonKey(name: 'Duration') @Default(0) double duration,
    @JsonKey(name: 'Track #') @Default(0) int trackNumber,
    @JsonKey(name: 'Disc #') @Default(0) int discNumber,
    @JsonKey(name: 'Total Discs') @Default(0) int totalDiscs,
    @JsonKey(name: 'Image File') @Default('') String imageUrl,
    @JsonKey(name: 'Bitrate') @Default(0) int bitrate,
    @JsonKey(name: 'Bit Depth') @Default(0) int bitDepth,
    @JsonKey(name: 'Sample Rate') @Default(0) int sampleRate,
    @JsonKey(name: 'Channels') @Default(0) int channels,
  }) = _Track;

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);
}
