// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloaded_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DownloadedTrack _$DownloadedTrackFromJson(Map<String, dynamic> json) =>
    _DownloadedTrack(
      fileKey: (json['fileKey'] as num).toInt(),
      track: Track.fromJson(json['track'] as Map<String, dynamic>),
      localPath: json['localPath'] as String,
      artworkPath: json['artworkPath'] as String?,
      albumGroupId: json['albumGroupId'] as String,
      albumArtist: json['albumArtist'] as String,
      album: json['album'] as String,
      dateReadable: json['dateReadable'] as String,
      discNumber: (json['discNumber'] as num).toInt(),
      totalDiscs: (json['totalDiscs'] as num).toInt(),
      trackNumber: (json['trackNumber'] as num).toInt(),
      fileSizeBytes: (json['fileSizeBytes'] as num).toInt(),
      downloadedAt: DateTime.parse(json['downloadedAt'] as String),
    );

Map<String, dynamic> _$DownloadedTrackToJson(_DownloadedTrack instance) =>
    <String, dynamic>{
      'fileKey': instance.fileKey,
      'track': instance.track,
      'localPath': instance.localPath,
      'artworkPath': instance.artworkPath,
      'albumGroupId': instance.albumGroupId,
      'albumArtist': instance.albumArtist,
      'album': instance.album,
      'dateReadable': instance.dateReadable,
      'discNumber': instance.discNumber,
      'totalDiscs': instance.totalDiscs,
      'trackNumber': instance.trackNumber,
      'fileSizeBytes': instance.fileSizeBytes,
      'downloadedAt': instance.downloadedAt.toIso8601String(),
    };
