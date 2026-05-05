import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../library/data/models/track.dart';
import 'download_state.dart';

part 'download_job.freezed.dart';
part 'download_job.g.dart';

@freezed
abstract class DownloadJob with _$DownloadJob {
  const factory DownloadJob({
    required int fileKey,
    required Track track,
    required DownloadState state,
    @Default(0) int bytesDone,
    @Default(-1) int bytesTotal,
    required DateTime enqueuedAt,
    DateTime? startedAt,
    String? error,
  }) = _DownloadJob;

  factory DownloadJob.fromJson(Map<String, dynamic> json) =>
      _$DownloadJobFromJson(json);
}
