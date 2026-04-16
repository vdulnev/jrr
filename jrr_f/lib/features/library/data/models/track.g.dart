// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Track _$TrackFromJson(Map<String, dynamic> json) => _Track(
  fileKey: json['Key'] as String,
  name: json['Name'] as String,
  artist: json['Artist'] as String,
  album: json['Album'] as String,
  genre: json['Genre'] as String? ?? '',
  duration: (json['Duration'] as num?)?.toDouble() ?? 0,
  trackNumber: (json['Track #'] as num?)?.toInt() ?? 0,
  discNumber: (json['Disc #'] as num?)?.toInt() ?? 0,
  totalDiscs: (json['Total Discs'] as num?)?.toInt() ?? 0,
  imageUrl: json['Image File'] as String? ?? '',
  bitrate: (json['Bitrate'] as num?)?.toInt() ?? 0,
  bitDepth: (json['Bit Depth'] as num?)?.toInt() ?? 0,
  sampleRate: (json['Sample Rate'] as num?)?.toInt() ?? 0,
  channels: (json['Channels'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TrackToJson(_Track instance) => <String, dynamic>{
  'Key': instance.fileKey,
  'Name': instance.name,
  'Artist': instance.artist,
  'Album': instance.album,
  'Genre': instance.genre,
  'Duration': instance.duration,
  'Track #': instance.trackNumber,
  'Disc #': instance.discNumber,
  'Total Discs': instance.totalDiscs,
  'Image File': instance.imageUrl,
  'Bitrate': instance.bitrate,
  'Bit Depth': instance.bitDepth,
  'Sample Rate': instance.sampleRate,
  'Channels': instance.channels,
};
