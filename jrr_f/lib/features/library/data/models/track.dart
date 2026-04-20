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
    @JsonKey(name: 'Date') @ForceIntConverter() @Default(0) int date,
  }) = _Track;

  const Track._();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  String get dateDisplay {
    if (date <= 0) return '';
    // If it's a 4-digit year already
    if (date > 1000 && date < 3000) return date.toString();

    // JRiver dates are days since 1899-12-30.
    // 30000 days is approx year 1982. 50000 is year 2036.
    if (date >= 1) {
      final dt = jriverDateToDateTime(date.toDouble());
      return dt.year.toString();
    }
    return '';
  }

  static DateTime jriverDateToDateTime(double value) {
    // JRiver base date: 1899-12-30
    final base = DateTime(1899, 12, 30);
    return base.add(Duration(days: value.toInt()));
  }

  String get folderPath => parentPath(filePath);

  String get parentFolderPath => parentPath(folderPath);

  static String parentPath(String path) {
    if (path.isEmpty) return '';

    // Strip trailing separator if present
    final trimmed = (path.endsWith('\\') || path.endsWith('/'))
        ? path.substring(0, path.length - 1)
        : path;

    if (trimmed.isEmpty) return path;
    if (trimmed.endsWith(':')) return path;

    final lastBackslash = trimmed.lastIndexOf('\\');
    final lastSlash = trimmed.lastIndexOf('/');
    final sep = lastBackslash > lastSlash ? lastBackslash : lastSlash;

    return sep >= 0 ? trimmed.substring(0, sep + 1) : '';
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
