// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrackInfo {

 String get fileKey; String get name; String get artist; String get album; String get imageUrl; int get bitrate; int get bitDepth; int get sampleRate; int get channels;
/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackInfoCopyWith<TrackInfo> get copyWith => _$TrackInfoCopyWithImpl<TrackInfo>(this as TrackInfo, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrackInfo&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,album,imageUrl,bitrate,bitDepth,sampleRate,channels);

@override
String toString() {
  return 'TrackInfo(fileKey: $fileKey, name: $name, artist: $artist, album: $album, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class $TrackInfoCopyWith<$Res>  {
  factory $TrackInfoCopyWith(TrackInfo value, $Res Function(TrackInfo) _then) = _$TrackInfoCopyWithImpl;
@useResult
$Res call({
 String fileKey, String name, String artist, String album, String imageUrl, int bitrate, int bitDepth, int sampleRate, int channels
});




}
/// @nodoc
class _$TrackInfoCopyWithImpl<$Res>
    implements $TrackInfoCopyWith<$Res> {
  _$TrackInfoCopyWithImpl(this._self, this._then);

  final TrackInfo _self;
  final $Res Function(TrackInfo) _then;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,}) {
  return _then(_self.copyWith(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TrackInfo].
extension TrackInfoPatterns on TrackInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrackInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrackInfo value)  $default,){
final _that = this;
switch (_that) {
case _TrackInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrackInfo value)?  $default,){
final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileKey,  String name,  String artist,  String album,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileKey,  String name,  String artist,  String album,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)  $default,) {final _that = this;
switch (_that) {
case _TrackInfo():
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileKey,  String name,  String artist,  String album,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)?  $default,) {final _that = this;
switch (_that) {
case _TrackInfo() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
  return null;

}
}

}

/// @nodoc


class _TrackInfo implements TrackInfo {
  const _TrackInfo({required this.fileKey, required this.name, required this.artist, required this.album, required this.imageUrl, required this.bitrate, required this.bitDepth, required this.sampleRate, required this.channels});
  

@override final  String fileKey;
@override final  String name;
@override final  String artist;
@override final  String album;
@override final  String imageUrl;
@override final  int bitrate;
@override final  int bitDepth;
@override final  int sampleRate;
@override final  int channels;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackInfoCopyWith<_TrackInfo> get copyWith => __$TrackInfoCopyWithImpl<_TrackInfo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrackInfo&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,album,imageUrl,bitrate,bitDepth,sampleRate,channels);

@override
String toString() {
  return 'TrackInfo(fileKey: $fileKey, name: $name, artist: $artist, album: $album, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class _$TrackInfoCopyWith<$Res> implements $TrackInfoCopyWith<$Res> {
  factory _$TrackInfoCopyWith(_TrackInfo value, $Res Function(_TrackInfo) _then) = __$TrackInfoCopyWithImpl;
@override @useResult
$Res call({
 String fileKey, String name, String artist, String album, String imageUrl, int bitrate, int bitDepth, int sampleRate, int channels
});




}
/// @nodoc
class __$TrackInfoCopyWithImpl<$Res>
    implements _$TrackInfoCopyWith<$Res> {
  __$TrackInfoCopyWithImpl(this._self, this._then);

  final _TrackInfo _self;
  final $Res Function(_TrackInfo) _then;

/// Create a copy of TrackInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,}) {
  return _then(_TrackInfo(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
