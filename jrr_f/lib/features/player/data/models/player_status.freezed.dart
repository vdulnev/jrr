// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerStatus {

 String get zoneId; String get zoneName; PlaybackState get state; int get fileKey; int get nextFileKey; int get positionMs; int get durationMs; String get elapsedTimeDisplay; String get remainingTimeDisplay; String get totalTimeDisplay; String get positionDisplay; int get playingNowPosition; int get playingNowTracks; String get playingNowPositionDisplay; int get playingNowChangeCounter; int get bitrate; int get bitDepth; int get sampleRate; int get channels; int get chapter; String? get chapterList; double get volume; String get volumeDisplay; String get imageUrl; String get artist; String get album; String get name; int get rating; String get status; String? get linkedZones;// Internal fields not in the requested list but useful for current UI
 bool get isMuted; ShuffleMode get shuffleMode; RepeatMode get repeatMode;
/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatusCopyWith<PlayerStatus> get copyWith => _$PlayerStatusCopyWithImpl<PlayerStatus>(this as PlayerStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStatus&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.state, state) || other.state == state)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.nextFileKey, nextFileKey) || other.nextFileKey == nextFileKey)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.elapsedTimeDisplay, elapsedTimeDisplay) || other.elapsedTimeDisplay == elapsedTimeDisplay)&&(identical(other.remainingTimeDisplay, remainingTimeDisplay) || other.remainingTimeDisplay == remainingTimeDisplay)&&(identical(other.totalTimeDisplay, totalTimeDisplay) || other.totalTimeDisplay == totalTimeDisplay)&&(identical(other.positionDisplay, positionDisplay) || other.positionDisplay == positionDisplay)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.playingNowPositionDisplay, playingNowPositionDisplay) || other.playingNowPositionDisplay == playingNowPositionDisplay)&&(identical(other.playingNowChangeCounter, playingNowChangeCounter) || other.playingNowChangeCounter == playingNowChangeCounter)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.chapterList, chapterList) || other.chapterList == chapterList)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.volumeDisplay, volumeDisplay) || other.volumeDisplay == volumeDisplay)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.name, name) || other.name == name)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedZones, linkedZones) || other.linkedZones == linkedZones)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode));
}


@override
int get hashCode => Object.hashAll([runtimeType,zoneId,zoneName,state,fileKey,nextFileKey,positionMs,durationMs,elapsedTimeDisplay,remainingTimeDisplay,totalTimeDisplay,positionDisplay,playingNowPosition,playingNowTracks,playingNowPositionDisplay,playingNowChangeCounter,bitrate,bitDepth,sampleRate,channels,chapter,chapterList,volume,volumeDisplay,imageUrl,artist,album,name,rating,status,linkedZones,isMuted,shuffleMode,repeatMode]);

@override
String toString() {
  return 'PlayerStatus(zoneId: $zoneId, zoneName: $zoneName, state: $state, fileKey: $fileKey, nextFileKey: $nextFileKey, positionMs: $positionMs, durationMs: $durationMs, elapsedTimeDisplay: $elapsedTimeDisplay, remainingTimeDisplay: $remainingTimeDisplay, totalTimeDisplay: $totalTimeDisplay, positionDisplay: $positionDisplay, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, playingNowPositionDisplay: $playingNowPositionDisplay, playingNowChangeCounter: $playingNowChangeCounter, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels, chapter: $chapter, chapterList: $chapterList, volume: $volume, volumeDisplay: $volumeDisplay, imageUrl: $imageUrl, artist: $artist, album: $album, name: $name, rating: $rating, status: $status, linkedZones: $linkedZones, isMuted: $isMuted, shuffleMode: $shuffleMode, repeatMode: $repeatMode)';
}


}

/// @nodoc
abstract mixin class $PlayerStatusCopyWith<$Res>  {
  factory $PlayerStatusCopyWith(PlayerStatus value, $Res Function(PlayerStatus) _then) = _$PlayerStatusCopyWithImpl;
@useResult
$Res call({
 String zoneId, String zoneName, PlaybackState state, int fileKey, int nextFileKey, int positionMs, int durationMs, String elapsedTimeDisplay, String remainingTimeDisplay, String totalTimeDisplay, String positionDisplay, int playingNowPosition, int playingNowTracks, String playingNowPositionDisplay, int playingNowChangeCounter, int bitrate, int bitDepth, int sampleRate, int channels, int chapter, String? chapterList, double volume, String volumeDisplay, String imageUrl, String artist, String album, String name, int rating, String status, String? linkedZones, bool isMuted, ShuffleMode shuffleMode, RepeatMode repeatMode
});




}
/// @nodoc
class _$PlayerStatusCopyWithImpl<$Res>
    implements $PlayerStatusCopyWith<$Res> {
  _$PlayerStatusCopyWithImpl(this._self, this._then);

  final PlayerStatus _self;
  final $Res Function(PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zoneId = null,Object? zoneName = null,Object? state = null,Object? fileKey = null,Object? nextFileKey = null,Object? positionMs = null,Object? durationMs = null,Object? elapsedTimeDisplay = null,Object? remainingTimeDisplay = null,Object? totalTimeDisplay = null,Object? positionDisplay = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? playingNowPositionDisplay = null,Object? playingNowChangeCounter = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,Object? chapter = null,Object? chapterList = freezed,Object? volume = null,Object? volumeDisplay = null,Object? imageUrl = null,Object? artist = null,Object? album = null,Object? name = null,Object? rating = null,Object? status = null,Object? linkedZones = freezed,Object? isMuted = null,Object? shuffleMode = null,Object? repeatMode = null,}) {
  return _then(_self.copyWith(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlaybackState,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,nextFileKey: null == nextFileKey ? _self.nextFileKey : nextFileKey // ignore: cast_nullable_to_non_nullable
as int,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,elapsedTimeDisplay: null == elapsedTimeDisplay ? _self.elapsedTimeDisplay : elapsedTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,remainingTimeDisplay: null == remainingTimeDisplay ? _self.remainingTimeDisplay : remainingTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,totalTimeDisplay: null == totalTimeDisplay ? _self.totalTimeDisplay : totalTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,positionDisplay: null == positionDisplay ? _self.positionDisplay : positionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,playingNowPositionDisplay: null == playingNowPositionDisplay ? _self.playingNowPositionDisplay : playingNowPositionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowChangeCounter: null == playingNowChangeCounter ? _self.playingNowChangeCounter : playingNowChangeCounter // ignore: cast_nullable_to_non_nullable
as int,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,chapterList: freezed == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as String?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,volumeDisplay: null == volumeDisplay ? _self.volumeDisplay : volumeDisplay // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,linkedZones: freezed == linkedZones ? _self.linkedZones : linkedZones // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerStatus].
extension PlayerStatusPatterns on PlayerStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStatus value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStatus value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String zoneId,  String zoneName,  PlaybackState state,  int fileKey,  int nextFileKey,  int positionMs,  int durationMs,  String elapsedTimeDisplay,  String remainingTimeDisplay,  String totalTimeDisplay,  String positionDisplay,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter,  int bitrate,  int bitDepth,  int sampleRate,  int channels,  int chapter,  String? chapterList,  double volume,  String volumeDisplay,  String imageUrl,  String artist,  String album,  String name,  int rating,  String status,  String? linkedZones,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.zoneId,_that.zoneName,_that.state,_that.fileKey,_that.nextFileKey,_that.positionMs,_that.durationMs,_that.elapsedTimeDisplay,_that.remainingTimeDisplay,_that.totalTimeDisplay,_that.positionDisplay,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.chapter,_that.chapterList,_that.volume,_that.volumeDisplay,_that.imageUrl,_that.artist,_that.album,_that.name,_that.rating,_that.status,_that.linkedZones,_that.isMuted,_that.shuffleMode,_that.repeatMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String zoneId,  String zoneName,  PlaybackState state,  int fileKey,  int nextFileKey,  int positionMs,  int durationMs,  String elapsedTimeDisplay,  String remainingTimeDisplay,  String totalTimeDisplay,  String positionDisplay,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter,  int bitrate,  int bitDepth,  int sampleRate,  int channels,  int chapter,  String? chapterList,  double volume,  String volumeDisplay,  String imageUrl,  String artist,  String album,  String name,  int rating,  String status,  String? linkedZones,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode)  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus():
return $default(_that.zoneId,_that.zoneName,_that.state,_that.fileKey,_that.nextFileKey,_that.positionMs,_that.durationMs,_that.elapsedTimeDisplay,_that.remainingTimeDisplay,_that.totalTimeDisplay,_that.positionDisplay,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.chapter,_that.chapterList,_that.volume,_that.volumeDisplay,_that.imageUrl,_that.artist,_that.album,_that.name,_that.rating,_that.status,_that.linkedZones,_that.isMuted,_that.shuffleMode,_that.repeatMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String zoneId,  String zoneName,  PlaybackState state,  int fileKey,  int nextFileKey,  int positionMs,  int durationMs,  String elapsedTimeDisplay,  String remainingTimeDisplay,  String totalTimeDisplay,  String positionDisplay,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter,  int bitrate,  int bitDepth,  int sampleRate,  int channels,  int chapter,  String? chapterList,  double volume,  String volumeDisplay,  String imageUrl,  String artist,  String album,  String name,  int rating,  String status,  String? linkedZones,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.zoneId,_that.zoneName,_that.state,_that.fileKey,_that.nextFileKey,_that.positionMs,_that.durationMs,_that.elapsedTimeDisplay,_that.remainingTimeDisplay,_that.totalTimeDisplay,_that.positionDisplay,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter,_that.bitrate,_that.bitDepth,_that.sampleRate,_that.channels,_that.chapter,_that.chapterList,_that.volume,_that.volumeDisplay,_that.imageUrl,_that.artist,_that.album,_that.name,_that.rating,_that.status,_that.linkedZones,_that.isMuted,_that.shuffleMode,_that.repeatMode);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerStatus implements PlayerStatus {
  const _PlayerStatus({required this.zoneId, required this.zoneName, required this.state, this.fileKey = -1, this.nextFileKey = -1, required this.positionMs, required this.durationMs, this.elapsedTimeDisplay = '', this.remainingTimeDisplay = '', this.totalTimeDisplay = '', required this.positionDisplay, required this.playingNowPosition, required this.playingNowTracks, required this.playingNowPositionDisplay, required this.playingNowChangeCounter, this.bitrate = 0, this.bitDepth = 0, this.sampleRate = 0, this.channels = 0, this.chapter = 0, this.chapterList, required this.volume, required this.volumeDisplay, this.imageUrl = '', this.artist = '', this.album = '', this.name = '', this.rating = 0, this.status = '', this.linkedZones, this.isMuted = false, this.shuffleMode = ShuffleMode.off, this.repeatMode = RepeatMode.off});
  

@override final  String zoneId;
@override final  String zoneName;
@override final  PlaybackState state;
@override@JsonKey() final  int fileKey;
@override@JsonKey() final  int nextFileKey;
@override final  int positionMs;
@override final  int durationMs;
@override@JsonKey() final  String elapsedTimeDisplay;
@override@JsonKey() final  String remainingTimeDisplay;
@override@JsonKey() final  String totalTimeDisplay;
@override final  String positionDisplay;
@override final  int playingNowPosition;
@override final  int playingNowTracks;
@override final  String playingNowPositionDisplay;
@override final  int playingNowChangeCounter;
@override@JsonKey() final  int bitrate;
@override@JsonKey() final  int bitDepth;
@override@JsonKey() final  int sampleRate;
@override@JsonKey() final  int channels;
@override@JsonKey() final  int chapter;
@override final  String? chapterList;
@override final  double volume;
@override final  String volumeDisplay;
@override@JsonKey() final  String imageUrl;
@override@JsonKey() final  String artist;
@override@JsonKey() final  String album;
@override@JsonKey() final  String name;
@override@JsonKey() final  int rating;
@override@JsonKey() final  String status;
@override final  String? linkedZones;
// Internal fields not in the requested list but useful for current UI
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  ShuffleMode shuffleMode;
@override@JsonKey() final  RepeatMode repeatMode;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatusCopyWith<_PlayerStatus> get copyWith => __$PlayerStatusCopyWithImpl<_PlayerStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStatus&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.state, state) || other.state == state)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.nextFileKey, nextFileKey) || other.nextFileKey == nextFileKey)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.elapsedTimeDisplay, elapsedTimeDisplay) || other.elapsedTimeDisplay == elapsedTimeDisplay)&&(identical(other.remainingTimeDisplay, remainingTimeDisplay) || other.remainingTimeDisplay == remainingTimeDisplay)&&(identical(other.totalTimeDisplay, totalTimeDisplay) || other.totalTimeDisplay == totalTimeDisplay)&&(identical(other.positionDisplay, positionDisplay) || other.positionDisplay == positionDisplay)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.playingNowPositionDisplay, playingNowPositionDisplay) || other.playingNowPositionDisplay == playingNowPositionDisplay)&&(identical(other.playingNowChangeCounter, playingNowChangeCounter) || other.playingNowChangeCounter == playingNowChangeCounter)&&(identical(other.bitrate, bitrate) || other.bitrate == bitrate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate)&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.chapter, chapter) || other.chapter == chapter)&&(identical(other.chapterList, chapterList) || other.chapterList == chapterList)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.volumeDisplay, volumeDisplay) || other.volumeDisplay == volumeDisplay)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.name, name) || other.name == name)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.status, status) || other.status == status)&&(identical(other.linkedZones, linkedZones) || other.linkedZones == linkedZones)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode));
}


@override
int get hashCode => Object.hashAll([runtimeType,zoneId,zoneName,state,fileKey,nextFileKey,positionMs,durationMs,elapsedTimeDisplay,remainingTimeDisplay,totalTimeDisplay,positionDisplay,playingNowPosition,playingNowTracks,playingNowPositionDisplay,playingNowChangeCounter,bitrate,bitDepth,sampleRate,channels,chapter,chapterList,volume,volumeDisplay,imageUrl,artist,album,name,rating,status,linkedZones,isMuted,shuffleMode,repeatMode]);

@override
String toString() {
  return 'PlayerStatus(zoneId: $zoneId, zoneName: $zoneName, state: $state, fileKey: $fileKey, nextFileKey: $nextFileKey, positionMs: $positionMs, durationMs: $durationMs, elapsedTimeDisplay: $elapsedTimeDisplay, remainingTimeDisplay: $remainingTimeDisplay, totalTimeDisplay: $totalTimeDisplay, positionDisplay: $positionDisplay, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, playingNowPositionDisplay: $playingNowPositionDisplay, playingNowChangeCounter: $playingNowChangeCounter, bitrate: $bitrate, bitDepth: $bitDepth, sampleRate: $sampleRate, channels: $channels, chapter: $chapter, chapterList: $chapterList, volume: $volume, volumeDisplay: $volumeDisplay, imageUrl: $imageUrl, artist: $artist, album: $album, name: $name, rating: $rating, status: $status, linkedZones: $linkedZones, isMuted: $isMuted, shuffleMode: $shuffleMode, repeatMode: $repeatMode)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatusCopyWith<$Res> implements $PlayerStatusCopyWith<$Res> {
  factory _$PlayerStatusCopyWith(_PlayerStatus value, $Res Function(_PlayerStatus) _then) = __$PlayerStatusCopyWithImpl;
@override @useResult
$Res call({
 String zoneId, String zoneName, PlaybackState state, int fileKey, int nextFileKey, int positionMs, int durationMs, String elapsedTimeDisplay, String remainingTimeDisplay, String totalTimeDisplay, String positionDisplay, int playingNowPosition, int playingNowTracks, String playingNowPositionDisplay, int playingNowChangeCounter, int bitrate, int bitDepth, int sampleRate, int channels, int chapter, String? chapterList, double volume, String volumeDisplay, String imageUrl, String artist, String album, String name, int rating, String status, String? linkedZones, bool isMuted, ShuffleMode shuffleMode, RepeatMode repeatMode
});




}
/// @nodoc
class __$PlayerStatusCopyWithImpl<$Res>
    implements _$PlayerStatusCopyWith<$Res> {
  __$PlayerStatusCopyWithImpl(this._self, this._then);

  final _PlayerStatus _self;
  final $Res Function(_PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zoneId = null,Object? zoneName = null,Object? state = null,Object? fileKey = null,Object? nextFileKey = null,Object? positionMs = null,Object? durationMs = null,Object? elapsedTimeDisplay = null,Object? remainingTimeDisplay = null,Object? totalTimeDisplay = null,Object? positionDisplay = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? playingNowPositionDisplay = null,Object? playingNowChangeCounter = null,Object? bitrate = null,Object? bitDepth = null,Object? sampleRate = null,Object? channels = null,Object? chapter = null,Object? chapterList = freezed,Object? volume = null,Object? volumeDisplay = null,Object? imageUrl = null,Object? artist = null,Object? album = null,Object? name = null,Object? rating = null,Object? status = null,Object? linkedZones = freezed,Object? isMuted = null,Object? shuffleMode = null,Object? repeatMode = null,}) {
  return _then(_PlayerStatus(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlaybackState,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,nextFileKey: null == nextFileKey ? _self.nextFileKey : nextFileKey // ignore: cast_nullable_to_non_nullable
as int,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,elapsedTimeDisplay: null == elapsedTimeDisplay ? _self.elapsedTimeDisplay : elapsedTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,remainingTimeDisplay: null == remainingTimeDisplay ? _self.remainingTimeDisplay : remainingTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,totalTimeDisplay: null == totalTimeDisplay ? _self.totalTimeDisplay : totalTimeDisplay // ignore: cast_nullable_to_non_nullable
as String,positionDisplay: null == positionDisplay ? _self.positionDisplay : positionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,playingNowPositionDisplay: null == playingNowPositionDisplay ? _self.playingNowPositionDisplay : playingNowPositionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowChangeCounter: null == playingNowChangeCounter ? _self.playingNowChangeCounter : playingNowChangeCounter // ignore: cast_nullable_to_non_nullable
as int,bitrate: null == bitrate ? _self.bitrate : bitrate // ignore: cast_nullable_to_non_nullable
as int,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,chapter: null == chapter ? _self.chapter : chapter // ignore: cast_nullable_to_non_nullable
as int,chapterList: freezed == chapterList ? _self.chapterList : chapterList // ignore: cast_nullable_to_non_nullable
as String?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,volumeDisplay: null == volumeDisplay ? _self.volumeDisplay : volumeDisplay // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,linkedZones: freezed == linkedZones ? _self.linkedZones : linkedZones // ignore: cast_nullable_to_non_nullable
as String?,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,
  ));
}


}

// dart format on
