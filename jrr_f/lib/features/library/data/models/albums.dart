import 'package:freezed_annotation/freezed_annotation.dart';

import 'album.dart';

part 'albums.freezed.dart';

@freezed
abstract class Albums with _$Albums {
  const factory Albums({@Default(<Album>[]) List<Album> albums}) = _Albums;

  const Albums._();

  static const Albums empty = Albums(albums: []);

  factory Albums.fromList(List<Album> albums) => Albums(albums: albums);

  int get length => albums.length;
  bool get isEmpty => albums.isEmpty;
  bool get isNotEmpty => albums.isNotEmpty;
  Album operator [](int index) => albums[index];
  Album? get firstOrNull => albums.isEmpty ? null : albums.first;
}
