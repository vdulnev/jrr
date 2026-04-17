import 'package:freezed_annotation/freezed_annotation.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@freezed
abstract class Track with _$Track {
  @JsonSerializable()
  const factory Track({
    @JsonKey(name: 'Key') @ForceIntConverter() required int fileKey,
    @JsonKey(name: 'Name') @ForceStringConverter() @Default('') String name,
    @JsonKey(name: 'Artist') @ForceStringConverter() @Default('') String artist,
    @JsonKey(name: 'Album') @ForceStringConverter() @Default('') String album,
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
    @JsonKey(name: 'Filename') @Default('') String filePath,
  }) = _Track;

  const Track._();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  String get folderPath {
    if (filePath.isEmpty) return '';
    final lastBackslash = filePath.lastIndexOf('\\');
    final lastSlash = filePath.lastIndexOf('/');
    final sep = lastBackslash > lastSlash ? lastBackslash : lastSlash;
    return sep >= 0 ? filePath.substring(0, sep + 1) : '';
  }
}

class ForceStringConverter implements JsonConverter<String, dynamic> {
  const ForceStringConverter();

  @override
  String fromJson(dynamic json) => json?.toString() ?? '';

  @override
  dynamic toJson(String object) => object;
}

class ForceIntConverter implements JsonConverter<int, dynamic> {
  const ForceIntConverter();

  @override
  int fromJson(dynamic json) {
    if (json is int) return json;
    if (json is num) return json.toInt();
    if (json is String) return int.tryParse(json) ?? 0;
    return 0;
  }

  @override
  dynamic toJson(int object) => object;
}
