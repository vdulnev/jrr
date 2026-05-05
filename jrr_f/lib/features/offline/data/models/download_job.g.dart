// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadJob _$DownloadJobFromJson(Map<String, dynamic> json) => _DownloadJob(
  fileKey: (json['fileKey'] as num).toInt(),
  track: Track.fromJson(json['track'] as Map<String, dynamic>),
  state: $enumDecode(_$DownloadStateEnumMap, json['state']),
  bytesDone: (json['bytesDone'] as num?)?.toInt() ?? 0,
  bytesTotal: (json['bytesTotal'] as num?)?.toInt() ?? -1,
  enqueuedAt: DateTime.parse(json['enqueuedAt'] as String),
  startedAt: json['startedAt'] == null
      ? null
      : DateTime.parse(json['startedAt'] as String),
  error: json['error'] as String?,
);

Map<String, dynamic> _$DownloadJobToJson(_DownloadJob instance) =>
    <String, dynamic>{
      'fileKey': instance.fileKey,
      'track': instance.track,
      'state': _$DownloadStateEnumMap[instance.state]!,
      'bytesDone': instance.bytesDone,
      'bytesTotal': instance.bytesTotal,
      'enqueuedAt': instance.enqueuedAt.toIso8601String(),
      'startedAt': instance.startedAt?.toIso8601String(),
      'error': instance.error,
    };

const _$DownloadStateEnumMap = {
  DownloadState.notDownloaded: 'notDownloaded',
  DownloadState.queued: 'queued',
  DownloadState.running: 'running',
  DownloadState.downloaded: 'downloaded',
  DownloadState.failed: 'failed',
  DownloadState.cancelled: 'cancelled',
};
