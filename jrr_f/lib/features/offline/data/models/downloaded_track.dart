import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/extensions/string_extensions.dart';
import '../../../library/data/models/track.dart';

part 'downloaded_track.freezed.dart';
part 'downloaded_track.g.dart';

@Freezed(equal: false)
abstract class DownloadedTrack with _$DownloadedTrack {
  const factory DownloadedTrack({
    required int fileKey,
    required Track track,
    required String localPath,
    String? artworkPath,
    required String albumGroupId,
    required String albumArtist,
    required String album,
    required String dateReadable,
    required int discNumber,
    required int totalDiscs,
    required int trackNumber,
    required int fileSizeBytes,
    required DateTime downloadedAt,
  }) = _DownloadedTrack;

  const DownloadedTrack._();

  factory DownloadedTrack.fromJson(Map<String, dynamic> json) =>
      _$DownloadedTrackFromJson(json);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! DownloadedTrack) return false;
    return other.fileKey == fileKey &&
        other.track == track &&
        other.localPath == localPath &&
        other.artworkPath == artworkPath &&
        other.albumGroupId == albumGroupId &&
        other.albumArtist.equalsIgnoreCase(albumArtist) &&
        other.album.equalsIgnoreCase(album) &&
        other.dateReadable == dateReadable &&
        other.discNumber == discNumber &&
        other.totalDiscs == totalDiscs &&
        other.trackNumber == trackNumber &&
        other.fileSizeBytes == fileSizeBytes &&
        other.downloadedAt == downloadedAt;
  }

  @override
  int get hashCode => Object.hash(
    fileKey,
    track,
    localPath,
    artworkPath,
    albumGroupId,
    albumArtist.toLowerCase(),
    album.toLowerCase(),
    dateReadable,
    discNumber,
    totalDiscs,
    trackNumber,
    fileSizeBytes,
    downloadedAt,
  );
}
