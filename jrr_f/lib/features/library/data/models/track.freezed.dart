// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Track {

 String get fileKey; String get name; String get artist; String get album; String get genre; double get duration; int get trackNumber; int get discNumber; String get imageUrl; int get bitrate; int get bitDepth; int get sampleRate; int get channels;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,album,genre,duration,trackNumber,discNumber,imageUrl,bitrate,bitDepth,sampleRate,channels);

@override
String toString() {
  return 'Track(fileKey: $fileKey, name: $name, artist: $artist, album: $album, genre: $genre, duration: $duration, trackNumber: $trackNumber, discNumber: $discNumber, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
 String fileKey, String name, String artist, String album, String genre, double duration, int trackNumber, int discNumber, String imageUrl, int bitrate, int bitDepth, int sampleRate, int channels
});




}
/// @nodoc
class _$TrackCopyWithImpl<$Res>
    implements $TrackCopyWith<$Res> {
  _$TrackCopyWithImpl(this._self, this._then);

  final Track _self;
  final $Res Function(Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? genre = null,Object? duration = null,Object? trackNumber = null,Object? discNumber = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,}) {
  return _then(_self.copyWith(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Track].
extension TrackPatterns on Track {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Track value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Track value)  $default,){
final _that = this;
switch (_that) {
case _Track():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Track value)?  $default,){
final _that = this;
switch (_that) {
case _Track() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fileKey,  String name,  String artist,  String album,  String genre,  double duration,  int trackNumber,  int discNumber,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.genre,_that.duration,_that.trackNumber,_that.discNumber,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fileKey,  String name,  String artist,  String album,  String genre,  double duration,  int trackNumber,  int discNumber,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.genre,_that.duration,_that.trackNumber,_that.discNumber,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fileKey,  String name,  String artist,  String album,  String genre,  double duration,  int trackNumber,  int discNumber,  String imageUrl,  int bitrate,  int bitDepth,  int sampleRate,  int channels)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.genre,_that.duration,_that.trackNumber,_that.discNumber,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels);case _:
  return null;

}
}

}

/// @nodoc


class _Track implements Track {
  const _Track({required this.fileKey, required this.name, required this.artist, required this.album, this.genre = '', this.duration = 0, this.trackNumber = 0, this.discNumber = 0, this.imageUrl = '', this.bitrate = 0, this.bitDepth = 0, this.sampleRate = 0, this.channels = 0});
  

@override final  String fileKey;
@override final  String name;
@override final  String artist;
@override final  String album;
@override@JsonKey() final  String genre;
@override@JsonKey() final  double duration;
@override@JsonKey() final  int trackNumber;
@override@JsonKey() final  int discNumber;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  int bitrate;
@override@JsonKey() final  int bitDepth;
@override@JsonKey() final  int sampleRate;
@override@JsonKey() final  int channels;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,album,genre,duration,trackNumber,discNumber,imageUrl,bitrate,bitDepth,sampleRate,channels);

@override
String toString() {
  return 'Track(fileKey: $fileKey, name: $name, artist: $artist, album: $album, genre: $genre, duration: $duration, trackNumber: $trackNumber, discNumber: $discNumber, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
 String fileKey, String name, String artist, String album, String genre, double duration, int trackNumber, int discNumber, String imageUrl, int bitrate, int bitDepth, int sampleRate, int channels
});




}
/// @nodoc
class __$TrackCopyWithImpl<$Res>
    implements _$TrackCopyWith<$Res> {
  __$TrackCopyWithImpl(this._self, this._then);

  final _Track _self;
  final $Res Function(_Track) _then;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? genre = null,Object? duration = null,Object? trackNumber = null,Object? discNumber = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,}) {
  return _then(_Track(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
