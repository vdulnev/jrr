import 'package:freezed_annotation/freezed_annotation.dart';

part 'playing_now_item.freezed.dart';

@freezed
abstract class PlayingNowItem with _$PlayingNowItem {
  const factory PlayingNowItem({
    required int index,
    required String fileKey,
    required String name,
    required String artist,
    required String album,
  }) = _PlayingNowItem;
}
