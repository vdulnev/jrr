// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Album {

 String get name; String get albumArtist; String get folderPath; String get parentFolderPath; String get albumGroupId; String get date; int get artworkFileKey; int get totalDiscs; int get discNumber;
/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumCopyWith<Album> get copyWith => _$AlbumCopyWithImpl<Album>(this as Album, _$identity);





@override
String toString() {
  return 'Album(name: $name, albumArtist: $albumArtist, folderPath: $folderPath, parentFolderPath: $parentFolderPath, albumGroupId: $albumGroupId, date: $date, artworkFileKey: $artworkFileKey, totalDiscs: $totalDiscs, discNumber: $discNumber)';
}


}

/// @nodoc
abstract mixin class $AlbumCopyWith<$Res>  {
  factory $AlbumCopyWith(Album value, $Res Function(Album) _then) = _$AlbumCopyWithImpl;
@useResult
$Res call({
 String name, String albumArtist, String folderPath, String parentFolderPath, String albumGroupId, String date, int artworkFileKey, int totalDiscs, int discNumber
});




}
/// @nodoc
class _$AlbumCopyWithImpl<$Res>
    implements $AlbumCopyWith<$Res> {
  _$AlbumCopyWithImpl(this._self, this._then);

  final Album _self;
  final $Res Function(Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? albumArtist = null,Object? folderPath = null,Object? parentFolderPath = null,Object? albumGroupId = null,Object? date = null,Object? artworkFileKey = null,Object? totalDiscs = null,Object? discNumber = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,folderPath: null == folderPath ? _self.folderPath : folderPath // ignore: cast_nullable_to_non_nullable
as String,parentFolderPath: null == parentFolderPath ? _self.parentFolderPath : parentFolderPath // ignore: cast_nullable_to_non_nullable
as String,albumGroupId: null == albumGroupId ? _self.albumGroupId : albumGroupId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,artworkFileKey: null == artworkFileKey ? _self.artworkFileKey : artworkFileKey // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Album].
extension AlbumPatterns on Album {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Album value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Album value)  $default,){
final _that = this;
switch (_that) {
case _Album():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Album value)?  $default,){
final _that = this;
switch (_that) {
case _Album() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String albumArtist,  String folderPath,  String parentFolderPath,  String albumGroupId,  String date,  int artworkFileKey,  int totalDiscs,  int discNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.name,_that.albumArtist,_that.folderPath,_that.parentFolderPath,_that.albumGroupId,_that.date,_that.artworkFileKey,_that.totalDiscs,_that.discNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String albumArtist,  String folderPath,  String parentFolderPath,  String albumGroupId,  String date,  int artworkFileKey,  int totalDiscs,  int discNumber)  $default,) {final _that = this;
switch (_that) {
case _Album():
return $default(_that.name,_that.albumArtist,_that.folderPath,_that.parentFolderPath,_that.albumGroupId,_that.date,_that.artworkFileKey,_that.totalDiscs,_that.discNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String albumArtist,  String folderPath,  String parentFolderPath,  String albumGroupId,  String date,  int artworkFileKey,  int totalDiscs,  int discNumber)?  $default,) {final _that = this;
switch (_that) {
case _Album() when $default != null:
return $default(_that.name,_that.albumArtist,_that.folderPath,_that.parentFolderPath,_that.albumGroupId,_that.date,_that.artworkFileKey,_that.totalDiscs,_that.discNumber);case _:
  return null;

}
}

}

/// @nodoc


class _Album extends Album {
  const _Album({required this.name, required this.albumArtist, required this.folderPath, required this.parentFolderPath, required this.albumGroupId, this.date = '', this.artworkFileKey = -1, this.totalDiscs = 0, this.discNumber = 0}): super._();
  

@override final  String name;
@override final  String albumArtist;
@override final  String folderPath;
@override final  String parentFolderPath;
@override final  String albumGroupId;
@override@JsonKey() final  String date;
@override@JsonKey() final  int artworkFileKey;
@override@JsonKey() final  int totalDiscs;
@override@JsonKey() final  int discNumber;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumCopyWith<_Album> get copyWith => __$AlbumCopyWithImpl<_Album>(this, _$identity);





@override
String toString() {
  return 'Album(name: $name, albumArtist: $albumArtist, folderPath: $folderPath, parentFolderPath: $parentFolderPath, albumGroupId: $albumGroupId, date: $date, artworkFileKey: $artworkFileKey, totalDiscs: $totalDiscs, discNumber: $discNumber)';
}


}

/// @nodoc
abstract mixin class _$AlbumCopyWith<$Res> implements $AlbumCopyWith<$Res> {
  factory _$AlbumCopyWith(_Album value, $Res Function(_Album) _then) = __$AlbumCopyWithImpl;
@override @useResult
$Res call({
 String name, String albumArtist, String folderPath, String parentFolderPath, String albumGroupId, String date, int artworkFileKey, int totalDiscs, int discNumber
});




}
/// @nodoc
class __$AlbumCopyWithImpl<$Res>
    implements _$AlbumCopyWith<$Res> {
  __$AlbumCopyWithImpl(this._self, this._then);

  final _Album _self;
  final $Res Function(_Album) _then;

/// Create a copy of Album
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? albumArtist = null,Object? folderPath = null,Object? parentFolderPath = null,Object? albumGroupId = null,Object? date = null,Object? artworkFileKey = null,Object? totalDiscs = null,Object? discNumber = null,}) {
  return _then(_Album(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,folderPath: null == folderPath ? _self.folderPath : folderPath // ignore: cast_nullable_to_non_nullable
as String,parentFolderPath: null == parentFolderPath ? _self.parentFolderPath : parentFolderPath // ignore: cast_nullable_to_non_nullable
as String,albumGroupId: null == albumGroupId ? _self.albumGroupId : albumGroupId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,artworkFileKey: null == artworkFileKey ? _self.artworkFileKey : artworkFileKey // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
