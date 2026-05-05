import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../library/data/models/track.dart';

part 'downloaded_track.freezed.dart';
part 'downloaded_track.g.dart';

@freezed
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

  factory DownloadedTrack.fromJson(Map<String, dynamic> json) =>
      _$DownloadedTrackFromJson(json);
}
