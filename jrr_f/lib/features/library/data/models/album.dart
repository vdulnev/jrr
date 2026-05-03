import 'package:freezed_annotation/freezed_annotation.dart';

import 'track.dart';

part 'album.freezed.dart';

@freezed
abstract class Album with _$Album {
  const factory Album({
    required String name,
    required String artist,
    required String albumArtist,
    required String folderPath,
    @Default('') String date,
    @Default(-1) int artworkFileKey,
  }) = _Album;

  factory Album.fromTrack(Track track) {
    final folderPath = track.totalDiscs > 1 || track.discNumber > 0
        ? track.parentFolderPath
        : track.folderPath;
    final date = track.dateReadable;
    return Album(
      name: track.album,
      artist: track.artist,
      albumArtist: track.albumArtist,
      folderPath: folderPath,
      date: date,
      artworkFileKey: track.fileKey,
    );
  }
}
