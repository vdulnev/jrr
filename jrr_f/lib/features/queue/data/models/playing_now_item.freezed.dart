// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playing_now_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayingNowItem {

 int get index; String get fileKey; String get name; String get artist; String get album;
/// Create a copy of PlayingNowItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayingNowItemCopyWith<PlayingNowItem> get copyWith => _$PlayingNowItemCopyWithImpl<PlayingNowItem>(this as PlayingNowItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayingNowItem&&(identical(other.index, index) || other.index == index)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album));
}


@override
int get hashCode => Object.hash(runtimeType,index,fileKey,name,artist,album);

@override
String toString() {
  return 'PlayingNowItem(index: $index, fileKey: $fileKey, name: $name, artist: $artist, album: $album)';
}


}

/// @nodoc
abstract mixin class $PlayingNowItemCopyWith<$Res>  {
  factory $PlayingNowItemCopyWith(PlayingNowItem value, $Res Function(PlayingNowItem) _then) = _$PlayingNowItemCopyWithImpl;
@useResult
$Res call({
 int index, String fileKey, String name, String artist, String album
});




}
/// @nodoc
class _$PlayingNowItemCopyWithImpl<$Res>
    implements $PlayingNowItemCopyWith<$Res> {
  _$PlayingNowItemCopyWithImpl(this._self, this._then);

  final PlayingNowItem _self;
  final $Res Function(PlayingNowItem) _then;

/// Create a copy of PlayingNowItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayingNowItem].
extension PlayingNowItemPatterns on PlayingNowItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayingNowItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayingNowItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayingNowItem value)  $default,){
final _that = this;
switch (_that) {
case _PlayingNowItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayingNowItem value)?  $default,){
final _that = this;
switch (_that) {
case _PlayingNowItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  String fileKey,  String name,  String artist,  String album)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayingNowItem() when $default != null:
return $default(_that.index,_that.fileKey,_that.name,_that.artist,_that.album);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  String fileKey,  String name,  String artist,  String album)  $default,) {final _that = this;
switch (_that) {
case _PlayingNowItem():
return $default(_that.index,_that.fileKey,_that.name,_that.artist,_that.album);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  String fileKey,  String name,  String artist,  String album)?  $default,) {final _that = this;
switch (_that) {
case _PlayingNowItem() when $default != null:
return $default(_that.index,_that.fileKey,_that.name,_that.artist,_that.album);case _:
  return null;

}
}

}

/// @nodoc


class _PlayingNowItem implements PlayingNowItem {
  const _PlayingNowItem({required this.index, required this.fileKey, required this.name, required this.artist, required this.album});
  

@override final  int index;
@override final  String fileKey;
@override final  String name;
@override final  String artist;
@override final  String album;

/// Create a copy of PlayingNowItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayingNowItemCopyWith<_PlayingNowItem> get copyWith => __$PlayingNowItemCopyWithImpl<_PlayingNowItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayingNowItem&&(identical(other.index, index) || other.index == index)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album));
}


@override
int get hashCode => Object.hash(runtimeType,index,fileKey,name,artist,album);

@override
String toString() {
  return 'PlayingNowItem(index: $index, fileKey: $fileKey, name: $name, artist: $artist, album: $album)';
}


}

/// @nodoc
abstract mixin class _$PlayingNowItemCopyWith<$Res> implements $PlayingNowItemCopyWith<$Res> {
  factory _$PlayingNowItemCopyWith(_PlayingNowItem value, $Res Function(_PlayingNowItem) _then) = __$PlayingNowItemCopyWithImpl;
@override @useResult
$Res call({
 int index, String fileKey, String name, String artist, String album
});




}
/// @nodoc
class __$PlayingNowItemCopyWithImpl<$Res>
    implements _$PlayingNowItemCopyWith<$Res> {
  __$PlayingNowItemCopyWithImpl(this._self, this._then);

  final _PlayingNowItem _self;
  final $Res Function(_PlayingNowItem) _then;

/// Create a copy of PlayingNowItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,}) {
  return _then(_PlayingNowItem(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
