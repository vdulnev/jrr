import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/extensions/string_extensions.dart';

import 'track.dart';

part 'album.freezed.dart';

@Freezed(equal: false)
abstract class Album with _$Album {
  const factory Album({
    required String name,
    required String albumArtist,
    required String folderPath,
    required String parentFolderPath,
    required String albumGroupId,
    @Default('') String date,
    @Default(-1) int artworkFileKey,
    @Default(0) int totalDiscs,
    @Default(0) int discNumber,
  }) = _Album;

  const Album._();

  factory Album.fromTrack(Track track) {
    return Album(
      name: track.album,
      albumArtist: track.albumArtistAuto,
      folderPath: track.folderPath,
      parentFolderPath: track.parentFolderPath,
      albumGroupId: track.albumGroupId,
      date: track.dateReadable,
      artworkFileKey: track.fileKey,
      totalDiscs: track.totalDiscs,
      discNumber: track.discNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Album) return false;
    return other.name.equalsIgnoreCase(name) &&
        other.albumArtist.equalsIgnoreCase(albumArtist) &&
        other.folderPath.equalsIgnoreCase(folderPath) &&
        other.parentFolderPath.equalsIgnoreCase(parentFolderPath) &&
        other.date == date &&
        other.artworkFileKey == artworkFileKey &&
        other.totalDiscs == totalDiscs &&
        other.discNumber == discNumber;
  }

  @override
  int get hashCode => Object.hash(
    name.toLowerCase(),
    albumArtist.toLowerCase(),
    folderPath.toLowerCase(),
    parentFolderPath.toLowerCase(),
    date,
    artworkFileKey,
    totalDiscs,
    discNumber,
  );
}
