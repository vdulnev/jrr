import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/extensions/string_extensions.dart';

part 'track.freezed.dart';
part 'track.g.dart';

@Freezed(equal: false)
abstract class Track with _$Track {
  @JsonSerializable()
  const factory Track({
    @JsonKey(name: 'Key') @ForceIntConverter() required int fileKey,
    @JsonKey(name: 'Name') @ForceStringConverter() @Default('') String name,
    @JsonKey(name: 'Artist') @ForceStringConverter() @Default('') String artist,
    @JsonKey(name: 'Album') @ForceStringConverter() @Default('') String album,
    @JsonKey(name: 'Album Artist')
    @ForceStringConverter()
    @Default('')
    String albumArtist,
    @JsonKey(name: 'Album Artist (auto)')
    @ForceStringConverter()
    @Default('')
    String albumArtistAuto,
    @JsonKey(name: 'Genre') @Default('') String genre,
    @JsonKey(name: 'Duration') @Default(0) double duration,
    @JsonKey(name: 'Track #') @Default(0) int trackNumber,
    @JsonKey(name: 'Disc #') @Default(0) int discNumber,
    @JsonKey(name: 'Total Discs') @Default(0) int totalDiscs,
    @JsonKey(name: 'Image File') @Default('') String imageUrl,
    @JsonKey(name: 'Bitrate') @Default(0) int bitrate,
    @JsonKey(name: 'Bit Depth') @Default(0) int bitDepth,
    @JsonKey(name: 'Sample Rate') @Default(0) int sampleRate,
    @JsonKey(name: 'File Type') @Default('') String fileType,
    @JsonKey(name: 'Channels') @Default(0) int channels,
    @JsonKey(name: 'Total Tracks') @Default(0) int totalTracks,
    @JsonKey(name: 'Filename') @Default('') String filePath,
    @JsonKey(name: 'Date (readable)')
    @ForceStringConverter()
    @Default('')
    String dateReadable,
  }) = _Track;

  const Track._();

  factory Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Track) return false;
    return other.fileKey == fileKey &&
        other.name.equalsIgnoreCase(name) &&
        other.artist.equalsIgnoreCase(artist) &&
        other.album.equalsIgnoreCase(album) &&
        other.albumArtist == albumArtist &&
        other.albumArtistAuto == albumArtistAuto &&
        other.genre.equalsIgnoreCase(genre) &&
        other.duration == duration &&
        other.trackNumber == trackNumber &&
        other.discNumber == discNumber &&
        other.totalDiscs == totalDiscs &&
        other.imageUrl == imageUrl &&
        other.bitrate == bitrate &&
        other.bitDepth == bitDepth &&
        other.sampleRate == sampleRate &&
        other.fileType.equalsIgnoreCase(fileType) &&
        other.channels == channels &&
        other.totalTracks == totalTracks &&
        other.filePath == filePath &&
        other.dateReadable == dateReadable;
  }

  @override
  int get hashCode => Object.hashAll([
    fileKey,
    name.toLowerCase(),
    artist.toLowerCase(),
    album.toLowerCase(),
    albumArtist,
    albumArtistAuto,
    genre.toLowerCase(),
    duration,
    trackNumber,
    discNumber,
    totalDiscs,
    imageUrl,
    bitrate,
    bitDepth,
    sampleRate,
    fileType.toLowerCase(),
    channels,
    totalTracks,
    filePath,
    dateReadable,
  ]);

  String get albumGroupId => (totalDiscs > 1 && discNumber > 0)
      ? '${album.toLowerCase()}|${parentFolderPath.toLowerCase()}'
      : '${album.toLowerCase()}|${folderPath.toLowerCase()}';

  String get date => dateReadable;

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
