import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_info.freezed.dart';

@freezed
abstract class TrackInfo with _$TrackInfo {
  const factory TrackInfo({
    required String fileKey,
    required String name,
    required String artist,
    required String album,
    required String imageUrl,
    required int bitrate,
    required int bitDepth,
    required int sampleRate,
    required int channels,
  }) = _TrackInfo;
}
