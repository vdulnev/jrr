import 'package:freezed_annotation/freezed_annotation.dart';

part 'library_item.freezed.dart';

@freezed
abstract class LibraryItem with _$LibraryItem {
  const factory LibraryItem({
    required String fileKey,
    required String name,
    required String artist,
    required String album,
  }) = _LibraryItem;
}
