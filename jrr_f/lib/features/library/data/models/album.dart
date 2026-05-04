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

class AlbumGroup {
  final Album album;
  final List<Album> discs;

  AlbumGroup({required this.album, List<Album> discs = const []})
    : discs = [...discs]..sort((a, b) => a.discNumber.compareTo(b.discNumber));

  bool get isMultiDisc => discs.length > 1;

  String get id => '${album.name}|${album.parentFolderPath}';

  String get date {
    if (discs.isEmpty) return album.date;
    // Extract dates, filter empty, sort and take latest
    final dates = discs.map((d) => d.date).where((d) => d.isNotEmpty).toList()
      ..sort();
    return dates.isNotEmpty ? dates.last : album.date;
  }
}
