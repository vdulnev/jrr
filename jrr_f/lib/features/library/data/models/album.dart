import 'package:freezed_annotation/freezed_annotation.dart';

import 'track.dart';

part 'album.freezed.dart';

@freezed
abstract class Album with _$Album {
  const factory Album({
    required String name,
    required String albumArtist,
    required String folderPath,
    required String parentFolderPath,
    @Default('') String date,
    @Default(-1) int artworkFileKey,
    @Default(0) int totalDiscs,
    @Default(0) int discNumber,
  }) = _Album;

  factory Album.fromTrack(Track track) {
    return Album(
      name: track.album,
      albumArtist: track.albumArtistAuto,
      folderPath: track.folderPath,
      parentFolderPath: track.parentFolderPath,
      date: track.dateReadable,
      artworkFileKey: track.fileKey,
      totalDiscs: track.totalDiscs,
      discNumber: track.discNumber,
    );
  }
}
