import 'package:freezed_annotation/freezed_annotation.dart';

part 'browse_item.freezed.dart';

@freezed
abstract class BrowseItem with _$BrowseItem {
  const factory BrowseItem({required String id, required String name}) =
      _BrowseItem;
}
