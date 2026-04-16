import 'package:freezed_annotation/freezed_annotation.dart';

part 'album.freezed.dart';

@freezed
abstract class Album with _$Album {
  const factory Album({
    required String name,
    required String artist,
    required String folderPath,
  }) = _Album;
}
