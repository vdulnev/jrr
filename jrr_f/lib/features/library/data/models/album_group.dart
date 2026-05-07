import 'package:freezed_annotation/freezed_annotation.dart';

import 'album.dart';

part 'album_group.freezed.dart';

@Freezed(equal: false)
abstract class AlbumGroup with _$AlbumGroup {
  const factory AlbumGroup({
    required Album album,
    @Default(<Album>[]) List<Album> discs,
  }) = _AlbumGroup;

  const AlbumGroup._();

  /// Builds an [AlbumGroup] with [discs] sorted ascending by `discNumber`.
  /// Use this whenever the input order isn't guaranteed; freezed's default
  /// constructor copies [discs] verbatim.
  factory AlbumGroup.sorted({
    required Album album,
    List<Album> discs = const [],
  }) {
    final sorted = [...discs]
      ..sort((a, b) => a.discNumber.compareTo(b.discNumber));
    return AlbumGroup(album: album, discs: sorted);
  }

  bool get isMultiDisc => discs.length > 1;

  String get id =>
      '${album.name.toLowerCase()}|${album.parentFolderPath.toLowerCase()}';

  String get date {
    if (discs.isEmpty) return album.date;
    final dates = discs.map((d) => d.date).where((d) => d.isNotEmpty).toList()
      ..sort();
    return dates.isNotEmpty ? dates.last : album.date;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AlbumGroup) return false;
    return other.album == album &&
        const DeepCollectionEquality().equals(other.discs, discs);
  }

  @override
  int get hashCode =>
      Object.hash(album, const DeepCollectionEquality().hash(discs));
}
