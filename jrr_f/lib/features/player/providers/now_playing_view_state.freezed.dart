// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'now_playing_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NowPlayingViewState {

 Zone? get activeZone; int get fileKey; Track? get track; String get name; String get artist; String get album; int get positionMs; int get durationMs; double get volume; bool get isMuted; bool get isPlaying; RepeatMode get repeatMode; ShuffleMode get shuffleMode; int get playingNowPosition; int get playingNowTracks; String get fileType; int get bitDepth; int get sampleRate;
/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingViewStateCopyWith<NowPlayingViewState> get copyWith => _$NowPlayingViewStateCopyWithImpl<NowPlayingViewState>(this as NowPlayingViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlayingViewState&&(identical(other.activeZone, activeZone) || other.activeZone == activeZone)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hash(runtimeType,activeZone,fileKey,track,name,artist,album,positionMs,durationMs,volume,isMuted,isPlaying,repeatMode,shuffleMode,playingNowPosition,playingNowTracks,fileType,bitDepth,sampleRate);

@override
String toString() {
  return 'NowPlayingViewState(activeZone: $activeZone, fileKey: $fileKey, track: $track, name: $name, artist: $artist, album: $album, positionMs: $positionMs, durationMs: $durationMs, volume: $volume, isMuted: $isMuted, isPlaying: $isPlaying, repeatMode: $repeatMode, shuffleMode: $shuffleMode, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, fileType: $fileType, bitDepth: $bitDepth, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class $NowPlayingViewStateCopyWith<$Res>  {
  factory $NowPlayingViewStateCopyWith(NowPlayingViewState value, $Res Function(NowPlayingViewState) _then) = _$NowPlayingViewStateCopyWithImpl;
@useResult
$Res call({
 Zone? activeZone, int fileKey, Track? track, String name, String artist, String album, int positionMs, int durationMs, double volume, bool isMuted, bool isPlaying, RepeatMode repeatMode, ShuffleMode shuffleMode, int playingNowPosition, int playingNowTracks, String fileType, int bitDepth, int sampleRate
});


$ZoneCopyWith<$Res>? get activeZone;$TrackCopyWith<$Res>? get track;

}
/// @nodoc
class _$NowPlayingViewStateCopyWithImpl<$Res>
    implements $NowPlayingViewStateCopyWith<$Res> {
  _$NowPlayingViewStateCopyWithImpl(this._self, this._then);

  final NowPlayingViewState _self;
  final $Res Function(NowPlayingViewState) _then;

/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activeZone = freezed,Object? fileKey = null,Object? track = freezed,Object? name = null,Object? artist = null,Object? album = null,Object? positionMs = null,Object? durationMs = null,Object? volume = null,Object? isMuted = null,Object? isPlaying = null,Object? repeatMode = null,Object? shuffleMode = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? fileType = null,Object? bitDepth = null,Object? sampleRate = null,}) {
  return _then(_self.copyWith(
activeZone: freezed == activeZone ? _self.activeZone : activeZone // ignore: cast_nullable_to_non_nullable
as Zone?,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneCopyWith<$Res>? get activeZone {
    if (_self.activeZone == null) {
    return null;
  }

  return $ZoneCopyWith<$Res>(_self.activeZone!, (value) {
    return _then(_self.copyWith(activeZone: value));
  });
}/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $TrackCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [NowPlayingViewState].
extension NowPlayingViewStatePatterns on NowPlayingViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NowPlayingViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NowPlayingViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NowPlayingViewState value)  $default,){
final _that = this;
switch (_that) {
case _NowPlayingViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NowPlayingViewState value)?  $default,){
final _that = this;
switch (_that) {
case _NowPlayingViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Zone? activeZone,  int fileKey,  Track? track,  String name,  String artist,  String album,  int positionMs,  int durationMs,  double volume,  bool isMuted,  bool isPlaying,  RepeatMode repeatMode,  ShuffleMode shuffleMode,  int playingNowPosition,  int playingNowTracks,  String fileType,  int bitDepth,  int sampleRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NowPlayingViewState() when $default != null:
return $default(_that.activeZone,_that.fileKey,_that.track,_that.name,_that.artist,_that.album,_that.positionMs,_that.durationMs,_that.volume,_that.isMuted,_that.isPlaying,_that.repeatMode,_that.shuffleMode,_that.playingNowPosition,_that.playingNowTracks,_that.fileType,_that.bitDepth,_that.sampleRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Zone? activeZone,  int fileKey,  Track? track,  String name,  String artist,  String album,  int positionMs,  int durationMs,  double volume,  bool isMuted,  bool isPlaying,  RepeatMode repeatMode,  ShuffleMode shuffleMode,  int playingNowPosition,  int playingNowTracks,  String fileType,  int bitDepth,  int sampleRate)  $default,) {final _that = this;
switch (_that) {
case _NowPlayingViewState():
return $default(_that.activeZone,_that.fileKey,_that.track,_that.name,_that.artist,_that.album,_that.positionMs,_that.durationMs,_that.volume,_that.isMuted,_that.isPlaying,_that.repeatMode,_that.shuffleMode,_that.playingNowPosition,_that.playingNowTracks,_that.fileType,_that.bitDepth,_that.sampleRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Zone? activeZone,  int fileKey,  Track? track,  String name,  String artist,  String album,  int positionMs,  int durationMs,  double volume,  bool isMuted,  bool isPlaying,  RepeatMode repeatMode,  ShuffleMode shuffleMode,  int playingNowPosition,  int playingNowTracks,  String fileType,  int bitDepth,  int sampleRate)?  $default,) {final _that = this;
switch (_that) {
case _NowPlayingViewState() when $default != null:
return $default(_that.activeZone,_that.fileKey,_that.track,_that.name,_that.artist,_that.album,_that.positionMs,_that.durationMs,_that.volume,_that.isMuted,_that.isPlaying,_that.repeatMode,_that.shuffleMode,_that.playingNowPosition,_that.playingNowTracks,_that.fileType,_that.bitDepth,_that.sampleRate);case _:
  return null;

}
}

}

/// @nodoc


class _NowPlayingViewState extends NowPlayingViewState {
  const _NowPlayingViewState({required this.activeZone, required this.fileKey, required this.track, required this.name, required this.artist, required this.album, required this.positionMs, required this.durationMs, required this.volume, required this.isMuted, required this.isPlaying, required this.repeatMode, required this.shuffleMode, required this.playingNowPosition, required this.playingNowTracks, required this.fileType, required this.bitDepth, required this.sampleRate}): super._();
  

@override final  Zone? activeZone;
@override final  int fileKey;
@override final  Track? track;
@override final  String name;
@override final  String artist;
@override final  String album;
@override final  int positionMs;
@override final  int durationMs;
@override final  double volume;
@override final  bool isMuted;
@override final  bool isPlaying;
@override final  RepeatMode repeatMode;
@override final  ShuffleMode shuffleMode;
@override final  int playingNowPosition;
@override final  int playingNowTracks;
@override final  String fileType;
@override final  int bitDepth;
@override final  int sampleRate;

/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NowPlayingViewStateCopyWith<_NowPlayingViewState> get copyWith => __$NowPlayingViewStateCopyWithImpl<_NowPlayingViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NowPlayingViewState&&(identical(other.activeZone, activeZone) || other.activeZone == activeZone)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.track, track) || other.track == track)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.fileType, fileType) || other.fileType == fileType)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}


@override
int get hashCode => Object.hash(runtimeType,activeZone,fileKey,track,name,artist,album,positionMs,durationMs,volume,isMuted,isPlaying,repeatMode,shuffleMode,playingNowPosition,playingNowTracks,fileType,bitDepth,sampleRate);

@override
String toString() {
  return 'NowPlayingViewState(activeZone: $activeZone, fileKey: $fileKey, track: $track, name: $name, artist: $artist, album: $album, positionMs: $positionMs, durationMs: $durationMs, volume: $volume, isMuted: $isMuted, isPlaying: $isPlaying, repeatMode: $repeatMode, shuffleMode: $shuffleMode, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, fileType: $fileType, bitDepth: $bitDepth, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class _$NowPlayingViewStateCopyWith<$Res> implements $NowPlayingViewStateCopyWith<$Res> {
  factory _$NowPlayingViewStateCopyWith(_NowPlayingViewState value, $Res Function(_NowPlayingViewState) _then) = __$NowPlayingViewStateCopyWithImpl;
@override @useResult
$Res call({
 Zone? activeZone, int fileKey, Track? track, String name, String artist, String album, int positionMs, int durationMs, double volume, bool isMuted, bool isPlaying, RepeatMode repeatMode, ShuffleMode shuffleMode, int playingNowPosition, int playingNowTracks, String fileType, int bitDepth, int sampleRate
});


@override $ZoneCopyWith<$Res>? get activeZone;@override $TrackCopyWith<$Res>? get track;

}
/// @nodoc
class __$NowPlayingViewStateCopyWithImpl<$Res>
    implements _$NowPlayingViewStateCopyWith<$Res> {
  __$NowPlayingViewStateCopyWithImpl(this._self, this._then);

  final _NowPlayingViewState _self;
  final $Res Function(_NowPlayingViewState) _then;

/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activeZone = freezed,Object? fileKey = null,Object? track = freezed,Object? name = null,Object? artist = null,Object? album = null,Object? positionMs = null,Object? durationMs = null,Object? volume = null,Object? isMuted = null,Object? isPlaying = null,Object? repeatMode = null,Object? shuffleMode = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? fileType = null,Object? bitDepth = null,Object? sampleRate = null,}) {
  return _then(_NowPlayingViewState(
activeZone: freezed == activeZone ? _self.activeZone : activeZone // ignore: cast_nullable_to_non_nullable
as Zone?,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,fileType: null == fileType ? _self.fileType : fileType // ignore: cast_nullable_to_non_nullable
as String,bitDepth: null == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZoneCopyWith<$Res>? get activeZone {
    if (_self.activeZone == null) {
    return null;
  }

  return $ZoneCopyWith<$Res>(_self.activeZone!, (value) {
    return _then(_self.copyWith(activeZone: value));
  });
}/// Create a copy of NowPlayingViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res>? get track {
    if (_self.track == null) {
    return null;
  }

  return $TrackCopyWith<$Res>(_self.track!, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}

// dart format on
