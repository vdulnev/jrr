import 'package:freezed_annotation/freezed_annotation.dart';

import 'track.dart';

part 'album.freezed.dart';

@freezed
abstract class Album with _$Album {
  const factory Album({
    required String name,
    required String artist,
    required String folderPath,
  }) = _Album;

  factory Album.fromTrack(Track track) {
    final folderPath = track.totalDiscs > 1 || track.discNumber > 0
        ? track.parentFolderPath
        : track.folderPath;
    return Album(
      name: track.album,
      artist: track.artist,
      folderPath: folderPath,
    );
  }
}
