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

@JsonKey(name: 'Key')@ForceIntConverter() int get fileKey;@JsonKey(name: 'Name')@ForceStringConverter() String get name;@JsonKey(name: 'Artist')@ForceStringConverter() String get artist;@JsonKey(name: 'Album')@ForceStringConverter() String get album;@JsonKey(name: 'Album Artist')@ForceStringConverter() String get albumArtist;@JsonKey(name: 'Genre') String get genre;@JsonKey(name: 'Duration') double get duration;@JsonKey(name: 'Playback Range') String get playbackRange;@JsonKey(name: 'Track #') int get trackNumber;@JsonKey(name: 'Disc #') int get discNumber;@JsonKey(name: 'Total Discs') int get totalDiscs;@JsonKey(name: 'Image File') String get imageUrl;@JsonKey(name: 'Bitrate') int get bitrate;@JsonKey(name: 'Bit Depth') int get bitDepth;@JsonKey(name: 'Sample Rate') int get sampleRate;@JsonKey(name: 'Channels') int get channels;@JsonKey(name: 'Total Tracks') int get totalTracks;@JsonKey(name: 'Filename') String get filePath;@JsonKey(name: 'Date (readable)')@ForceStringConverter() String get dateReadable;
/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackCopyWith<Track> get copyWith => _$TrackCopyWithImpl<Track>(this as Track, _$identity);

  /// Serializes this Track to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Track&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.albumArtist, albumArtist) || other.albumArtist == albumArtist)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playbackRange, playbackRange) || other.playbackRange == playbackRange)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.totalDiscs, totalDiscs) || other.totalDiscs == totalDiscs)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.dateReadable, dateReadable) || other.dateReadable == dateReadable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fileKey,name,artist,album,albumArtist,genre,duration,playbackRange,trackNumber,discNumber,totalDiscs,imageUrl,bitrate,bitDepth,sampleRate,channels,totalTracks,filePath,dateReadable]);

@override
String toString() {
  return 'Track(fileKey: $fileKey, name: $name, artist: $artist, album: $album, albumArtist: $albumArtist, genre: $genre, duration: $duration, playbackRange: $playbackRange, trackNumber: $trackNumber, discNumber: $discNumber, totalDiscs: $totalDiscs, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels, totalTracks: $totalTracks, filePath: $filePath, dateReadable: $dateReadable)';
}


}

/// @nodoc
abstract mixin class $TrackCopyWith<$Res>  {
  factory $TrackCopyWith(Track value, $Res Function(Track) _then) = _$TrackCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'Key')@ForceIntConverter() int fileKey,@JsonKey(name: 'Name')@ForceStringConverter() String name,@JsonKey(name: 'Artist')@ForceStringConverter() String artist,@JsonKey(name: 'Album')@ForceStringConverter() String album,@JsonKey(name: 'Album Artist')@ForceStringConverter() String albumArtist,@JsonKey(name: 'Genre') String genre,@JsonKey(name: 'Duration') double duration,@JsonKey(name: 'Playback Range') String playbackRange,@JsonKey(name: 'Track #') int trackNumber,@JsonKey(name: 'Disc #') int discNumber,@JsonKey(name: 'Total Discs') int totalDiscs,@JsonKey(name: 'Image File') String imageUrl,@JsonKey(name: 'Bitrate') int bitrate,@JsonKey(name: 'Bit Depth') int bitDepth,@JsonKey(name: 'Sample Rate') int sampleRate,@JsonKey(name: 'Channels') int channels,@JsonKey(name: 'Total Tracks') int totalTracks,@JsonKey(name: 'Filename') String filePath,@JsonKey(name: 'Date (readable)')@ForceStringConverter() String dateReadable
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
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? albumArtist = null,Object? genre = null,Object? duration = null,Object? playbackRange = null,Object? trackNumber = null,Object? discNumber = null,Object? totalDiscs = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,Object? totalTracks = null,Object? filePath = null,Object? dateReadable = null,}) {
  return _then(_self.copyWith(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,playbackRange: null == playbackRange ? _self.playbackRange : playbackRange // ignore: cast_nullable_to_non_nullable
as String,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,totalTracks: null == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,dateReadable: null == dateReadable ? _self.dateReadable : dateReadable // ignore: cast_nullable_to_non_nullable
as String,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'Key')@ForceIntConverter()  int fileKey, @JsonKey(name: 'Name')@ForceStringConverter()  String name, @JsonKey(name: 'Artist')@ForceStringConverter()  String artist, @JsonKey(name: 'Album')@ForceStringConverter()  String album, @JsonKey(name: 'Album Artist')@ForceStringConverter()  String albumArtist, @JsonKey(name: 'Genre')  String genre, @JsonKey(name: 'Duration')  double duration, @JsonKey(name: 'Playback Range')  String playbackRange, @JsonKey(name: 'Track #')  int trackNumber, @JsonKey(name: 'Disc #')  int discNumber, @JsonKey(name: 'Total Discs')  int totalDiscs, @JsonKey(name: 'Image File')  String imageUrl, @JsonKey(name: 'Bitrate')  int bitrate, @JsonKey(name: 'Bit Depth')  int bitDepth, @JsonKey(name: 'Sample Rate')  int sampleRate, @JsonKey(name: 'Channels')  int channels, @JsonKey(name: 'Total Tracks')  int totalTracks, @JsonKey(name: 'Filename')  String filePath, @JsonKey(name: 'Date (readable)')@ForceStringConverter()  String dateReadable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.albumArtist,_that.genre,_that.duration,_that.playbackRange,_that.trackNumber,_that.discNumber,_that.totalDiscs,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.totalTracks,_that.filePath,_that.dateReadable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'Key')@ForceIntConverter()  int fileKey, @JsonKey(name: 'Name')@ForceStringConverter()  String name, @JsonKey(name: 'Artist')@ForceStringConverter()  String artist, @JsonKey(name: 'Album')@ForceStringConverter()  String album, @JsonKey(name: 'Album Artist')@ForceStringConverter()  String albumArtist, @JsonKey(name: 'Genre')  String genre, @JsonKey(name: 'Duration')  double duration, @JsonKey(name: 'Playback Range')  String playbackRange, @JsonKey(name: 'Track #')  int trackNumber, @JsonKey(name: 'Disc #')  int discNumber, @JsonKey(name: 'Total Discs')  int totalDiscs, @JsonKey(name: 'Image File')  String imageUrl, @JsonKey(name: 'Bitrate')  int bitrate, @JsonKey(name: 'Bit Depth')  int bitDepth, @JsonKey(name: 'Sample Rate')  int sampleRate, @JsonKey(name: 'Channels')  int channels, @JsonKey(name: 'Total Tracks')  int totalTracks, @JsonKey(name: 'Filename')  String filePath, @JsonKey(name: 'Date (readable)')@ForceStringConverter()  String dateReadable)  $default,) {final _that = this;
switch (_that) {
case _Track():
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.albumArtist,_that.genre,_that.duration,_that.playbackRange,_that.trackNumber,_that.discNumber,_that.totalDiscs,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.totalTracks,_that.filePath,_that.dateReadable);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'Key')@ForceIntConverter()  int fileKey, @JsonKey(name: 'Name')@ForceStringConverter()  String name, @JsonKey(name: 'Artist')@ForceStringConverter()  String artist, @JsonKey(name: 'Album')@ForceStringConverter()  String album, @JsonKey(name: 'Album Artist')@ForceStringConverter()  String albumArtist, @JsonKey(name: 'Genre')  String genre, @JsonKey(name: 'Duration')  double duration, @JsonKey(name: 'Playback Range')  String playbackRange, @JsonKey(name: 'Track #')  int trackNumber, @JsonKey(name: 'Disc #')  int discNumber, @JsonKey(name: 'Total Discs')  int totalDiscs, @JsonKey(name: 'Image File')  String imageUrl, @JsonKey(name: 'Bitrate')  int bitrate, @JsonKey(name: 'Bit Depth')  int bitDepth, @JsonKey(name: 'Sample Rate')  int sampleRate, @JsonKey(name: 'Channels')  int channels, @JsonKey(name: 'Total Tracks')  int totalTracks, @JsonKey(name: 'Filename')  String filePath, @JsonKey(name: 'Date (readable)')@ForceStringConverter()  String dateReadable)?  $default,) {final _that = this;
switch (_that) {
case _Track() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.album,_that.albumArtist,_that.genre,_that.duration,_that.playbackRange,_that.trackNumber,_that.discNumber,_that.totalDiscs,_that.imageUrl,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.totalTracks,_that.filePath,_that.dateReadable);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable()
class _Track extends Track {
  const _Track({@JsonKey(name: 'Key')@ForceIntConverter() required this.fileKey, @JsonKey(name: 'Name')@ForceStringConverter() this.name = '', @JsonKey(name: 'Artist')@ForceStringConverter() this.artist = '', @JsonKey(name: 'Album')@ForceStringConverter() this.album = '', @JsonKey(name: 'Album Artist')@ForceStringConverter() this.albumArtist = '', @JsonKey(name: 'Genre') this.genre = '', @JsonKey(name: 'Duration') this.duration = 0, @JsonKey(name: 'Playback Range') this.playbackRange = '', @JsonKey(name: 'Track #') this.trackNumber = 0, @JsonKey(name: 'Disc #') this.discNumber = 0, @JsonKey(name: 'Total Discs') this.totalDiscs = 0, @JsonKey(name: 'Image File') this.imageUrl = '', @JsonKey(name: 'Bitrate') this.bitrate = 0, @JsonKey(name: 'Bit Depth') this.bitDepth = 0, @JsonKey(name: 'Sample Rate') this.sampleRate = 0, @JsonKey(name: 'Channels') this.channels = 0, @JsonKey(name: 'Total Tracks') this.totalTracks = 0, @JsonKey(name: 'Filename') this.filePath = '', @JsonKey(name: 'Date (readable)')@ForceStringConverter() this.dateReadable = ''}): super._();
  factory _Track.fromJson(Map<String, dynamic> json) => _$TrackFromJson(json);

@override@JsonKey(name: 'Key')@ForceIntConverter() final  int fileKey;
@override@JsonKey(name: 'Name')@ForceStringConverter() final  String name;
@override@JsonKey(name: 'Artist')@ForceStringConverter() final  String artist;
@override@JsonKey(name: 'Album')@ForceStringConverter() final  String album;
@override@JsonKey(name: 'Album Artist')@ForceStringConverter() final  String albumArtist;
@override@JsonKey(name: 'Genre') final  String genre;
@override@JsonKey(name: 'Duration') final  double duration;
@override@JsonKey(name: 'Playback Range') final  String playbackRange;
@override@JsonKey(name: 'Track #') final  int trackNumber;
@override@JsonKey(name: 'Disc #') final  int discNumber;
@override@JsonKey(name: 'Total Discs') final  int totalDiscs;
@override@JsonKey(name: 'Image File') final  String imageUrl;
@override@JsonKey(name: 'Bitrate') final  int bitrate;
@override@JsonKey(name: 'Bit Depth') final  int bitDepth;
@override@JsonKey(name: 'Sample Rate') final  int sampleRate;
@override@JsonKey(name: 'Channels') final  int channels;
@override@JsonKey(name: 'Total Tracks') final  int totalTracks;
@override@JsonKey(name: 'Filename') final  String filePath;
@override@JsonKey(name: 'Date (readable)')@ForceStringConverter() final  String dateReadable;

/// Create a copy of Track
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackCopyWith<_Track> get copyWith => __$TrackCopyWithImpl<_Track>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Track&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.albumArtist, albumArtist) || other.albumArtist == albumArtist)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.playbackRange, playbackRange) || other.playbackRange == playbackRange)&&(identical(other.trackNumber, trackNumber) || other.trackNumber == trackNumber)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.totalDiscs, totalDiscs) || other.totalDiscs == totalDiscs)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.totalTracks, totalTracks) || other.totalTracks == totalTracks)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.dateReadable, dateReadable) || other.dateReadable == dateReadable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,fileKey,name,artist,album,albumArtist,genre,duration,playbackRange,trackNumber,discNumber,totalDiscs,imageUrl,bitrate,bitDepth,sampleRate,channels,totalTracks,filePath,dateReadable]);

@override
String toString() {
  return 'Track(fileKey: $fileKey, name: $name, artist: $artist, album: $album, albumArtist: $albumArtist, genre: $genre, duration: $duration, playbackRange: $playbackRange, trackNumber: $trackNumber, discNumber: $discNumber, totalDiscs: $totalDiscs, imageUrl: $imageUrl, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels, totalTracks: $totalTracks, filePath: $filePath, dateReadable: $dateReadable)';
}


}

/// @nodoc
abstract mixin class _$TrackCopyWith<$Res> implements $TrackCopyWith<$Res> {
  factory _$TrackCopyWith(_Track value, $Res Function(_Track) _then) = __$TrackCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'Key')@ForceIntConverter() int fileKey,@JsonKey(name: 'Name')@ForceStringConverter() String name,@JsonKey(name: 'Artist')@ForceStringConverter() String artist,@JsonKey(name: 'Album')@ForceStringConverter() String album,@JsonKey(name: 'Album Artist')@ForceStringConverter() String albumArtist,@JsonKey(name: 'Genre') String genre,@JsonKey(name: 'Duration') double duration,@JsonKey(name: 'Playback Range') String playbackRange,@JsonKey(name: 'Track #') int trackNumber,@JsonKey(name: 'Disc #') int discNumber,@JsonKey(name: 'Total Discs') int totalDiscs,@JsonKey(name: 'Image File') String imageUrl,@JsonKey(name: 'Bitrate') int bitrate,@JsonKey(name: 'Bit Depth') int bitDepth,@JsonKey(name: 'Sample Rate') int sampleRate,@JsonKey(name: 'Channels') int channels,@JsonKey(name: 'Total Tracks') int totalTracks,@JsonKey(name: 'Filename') String filePath,@JsonKey(name: 'Date (readable)')@ForceStringConverter() String dateReadable
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
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = null,Object? name = null,Object? artist = null,Object? album = null,Object? albumArtist = null,Object? genre = null,Object? duration = null,Object? playbackRange = null,Object? trackNumber = null,Object? discNumber = null,Object? totalDiscs = null,Object? imageUrl = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,Object? totalTracks = null,Object? filePath = null,Object? dateReadable = null,}) {
  return _then(_Track(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,genre: null == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,playbackRange: null == playbackRange ? _self.playbackRange : playbackRange // ignore: cast_nullable_to_non_nullable
as String,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,totalTracks: null == totalTracks ? _self.totalTracks : totalTracks // ignore: cast_nullable_to_non_nullable
as int,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,dateReadable: null == dateReadable ? _self.dateReadable : dateReadable // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
