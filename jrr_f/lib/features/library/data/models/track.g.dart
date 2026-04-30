// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Track _$TrackFromJson(Map<String, dynamic> json) => _Track(
  fileKey: const ForceIntConverter().fromJson(json['Key']),
  name: json['Name'] == null
      ? ''
      : const ForceStringConverter().fromJson(json['Name']),
  artist: json['Artist'] == null
      ? ''
      : const ForceStringConverter().fromJson(json['Artist']),
  album: json['Album'] == null
      ? ''
      : const ForceStringConverter().fromJson(json['Album']),
  albumArtist: json['Album Artist'] == null
      ? ''
      : const ForceStringConverter().fromJson(json['Album Artist']),
  genre: json['Genre'] as String? ?? '',
  duration: (json['Duration'] as num?)?.toDouble() ?? 0,
  playbackRange: json['Playback Range'] as String? ?? '',
  trackNumber: (json['Track #'] as num?)?.toInt() ?? 0,
  discNumber: (json['Disc #'] as num?)?.toInt() ?? 0,
  totalDiscs: (json['Total Discs'] as num?)?.toInt() ?? 0,
  imageUrl: json['Image File'] as String? ?? '',
  bitrate: (json['Bitrate'] as num?)?.toInt() ?? 0,
  bitDepth: (json['Bit Depth'] as num?)?.toInt() ?? 0,
  sampleRate: (json['Sample Rate'] as num?)?.toInt() ?? 0,
  channels: (json['Channels'] as num?)?.toInt() ?? 0,
  totalTracks: (json['Total Tracks'] as num?)?.toInt() ?? 0,
  filePath: json['Filename'] as String? ?? '',
  dateReadable: json['Date (readable)'] == null
      ? ''
      : const ForceStringConverter().fromJson(json['Date (readable)']),
);

Map<String, dynamic> _$TrackToJson(_Track instance) => <String, dynamic>{
  'Key': const ForceIntConverter().toJson(instance.fileKey),
  'Name': const ForceStringConverter().toJson(instance.name),
  'Artist': const ForceStringConverter().toJson(instance.artist),
  'Album': const ForceStringConverter().toJson(instance.album),
  'Album Artist': const ForceStringConverter().toJson(instance.albumArtist),
  'Genre': instance.genre,
  'Duration': instance.duration,
  'Playback Range': instance.playbackRange,
  'Track #': instance.trackNumber,
  'Disc #': instance.discNumber,
  'Total Discs': instance.totalDiscs,
  'Image File': instance.imageUrl,
  'Bitrate': instance.bitrate,
  'Bit Depth': instance.bitDepth,
  'Sample Rate': instance.sampleRate,
  'Channels': instance.channels,
  'Total Tracks': instance.totalTracks,
  'Filename': instance.filePath,
  'Date (readable)': const ForceStringConverter().toJson(instance.dateReadable),
};
