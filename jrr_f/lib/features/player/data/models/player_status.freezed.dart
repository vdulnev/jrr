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

 String get zoneId; String get zoneName; PlaybackState get state; Track? get trackInfo; int get positionMs; int get durationMs; String get positionDisplay; double get volume; String get volumeDisplay; bool get isMuted; ShuffleMode get shuffleMode; RepeatMode get repeatMode; int get playingNowPosition; int get playingNowTracks; String get playingNowPositionDisplay; int get playingNowChangeCounter;
/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatusCopyWith<PlayerStatus> get copyWith => _$PlayerStatusCopyWithImpl<PlayerStatus>(this as PlayerStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStatus&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.state, state) || other.state == state)&&(identical(other.trackInfo, trackInfo) || other.trackInfo == trackInfo)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.positionDisplay, positionDisplay) || other.positionDisplay == positionDisplay)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.volumeDisplay, volumeDisplay) || other.volumeDisplay == volumeDisplay)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.playingNowPositionDisplay, playingNowPositionDisplay) || other.playingNowPositionDisplay == playingNowPositionDisplay)&&(identical(other.playingNowChangeCounter, playingNowChangeCounter) || other.playingNowChangeCounter == playingNowChangeCounter));
}


@override
int get hashCode => Object.hash(runtimeType,zoneId,zoneName,state,trackInfo,positionMs,durationMs,positionDisplay,volume,volumeDisplay,isMuted,shuffleMode,repeatMode,playingNowPosition,playingNowTracks,playingNowPositionDisplay,playingNowChangeCounter);

@override
String toString() {
  return 'PlayerStatus(zoneId: $zoneId, zoneName: $zoneName, state: $state, trackInfo: $trackInfo, positionMs: $positionMs, durationMs: $durationMs, positionDisplay: $positionDisplay, volume: $volume, volumeDisplay: $volumeDisplay, isMuted: $isMuted, shuffleMode: $shuffleMode, repeatMode: $repeatMode, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, playingNowPositionDisplay: $playingNowPositionDisplay, playingNowChangeCounter: $playingNowChangeCounter)';
}


}

/// @nodoc
abstract mixin class $PlayerStatusCopyWith<$Res>  {
  factory $PlayerStatusCopyWith(PlayerStatus value, $Res Function(PlayerStatus) _then) = _$PlayerStatusCopyWithImpl;
@useResult
$Res call({
 String zoneId, String zoneName, PlaybackState state, Track? trackInfo, int positionMs, int durationMs, String positionDisplay, double volume, String volumeDisplay, bool isMuted, ShuffleMode shuffleMode, RepeatMode repeatMode, int playingNowPosition, int playingNowTracks, String playingNowPositionDisplay, int playingNowChangeCounter
});


$TrackCopyWith<$Res>? get trackInfo;

}
/// @nodoc
class _$PlayerStatusCopyWithImpl<$Res>
    implements $PlayerStatusCopyWith<$Res> {
  _$PlayerStatusCopyWithImpl(this._self, this._then);

  final PlayerStatus _self;
  final $Res Function(PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zoneId = null,Object? zoneName = null,Object? state = null,Object? trackInfo = freezed,Object? positionMs = null,Object? durationMs = null,Object? positionDisplay = null,Object? volume = null,Object? volumeDisplay = null,Object? isMuted = null,Object? shuffleMode = null,Object? repeatMode = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? playingNowPositionDisplay = null,Object? playingNowChangeCounter = null,}) {
  return _then(_self.copyWith(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlaybackState,trackInfo: freezed == trackInfo ? _self.trackInfo : trackInfo // ignore: cast_nullable_to_non_nullable
as Track?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,positionDisplay: null == positionDisplay ? _self.positionDisplay : positionDisplay // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,volumeDisplay: null == volumeDisplay ? _self.volumeDisplay : volumeDisplay // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,playingNowPositionDisplay: null == playingNowPositionDisplay ? _self.playingNowPositionDisplay : playingNowPositionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowChangeCounter: null == playingNowChangeCounter ? _self.playingNowChangeCounter : playingNowChangeCounter // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res>? get trackInfo {
    if (_self.trackInfo == null) {
    return null;
  }

  return $TrackCopyWith<$Res>(_self.trackInfo!, (value) {
    return _then(_self.copyWith(trackInfo: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String zoneId,  String zoneName,  PlaybackState state,  Track? trackInfo,  int positionMs,  int durationMs,  String positionDisplay,  double volume,  String volumeDisplay,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.zoneId,_that.zoneName,_that.state,_that.trackInfo,_that.positionMs,_that.durationMs,_that.positionDisplay,_that.volume,_that.volumeDisplay,_that.isMuted,_that.shuffleMode,_that.repeatMode,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String zoneId,  String zoneName,  PlaybackState state,  Track? trackInfo,  int positionMs,  int durationMs,  String positionDisplay,  double volume,  String volumeDisplay,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter)  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus():
return $default(_that.zoneId,_that.zoneName,_that.state,_that.trackInfo,_that.positionMs,_that.durationMs,_that.positionDisplay,_that.volume,_that.volumeDisplay,_that.isMuted,_that.shuffleMode,_that.repeatMode,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String zoneId,  String zoneName,  PlaybackState state,  Track? trackInfo,  int positionMs,  int durationMs,  String positionDisplay,  double volume,  String volumeDisplay,  bool isMuted,  ShuffleMode shuffleMode,  RepeatMode repeatMode,  int playingNowPosition,  int playingNowTracks,  String playingNowPositionDisplay,  int playingNowChangeCounter)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStatus() when $default != null:
return $default(_that.zoneId,_that.zoneName,_that.state,_that.trackInfo,_that.positionMs,_that.durationMs,_that.positionDisplay,_that.volume,_that.volumeDisplay,_that.isMuted,_that.shuffleMode,_that.repeatMode,_that.playingNowPosition,_that.playingNowTracks,_that.playingNowPositionDisplay,_that.playingNowChangeCounter);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerStatus implements PlayerStatus {
  const _PlayerStatus({required this.zoneId, required this.zoneName, required this.state, this.trackInfo, required this.positionMs, required this.durationMs, required this.positionDisplay, required this.volume, required this.volumeDisplay, required this.isMuted, this.shuffleMode = ShuffleMode.off, this.repeatMode = RepeatMode.off, required this.playingNowPosition, required this.playingNowTracks, required this.playingNowPositionDisplay, required this.playingNowChangeCounter});
  

@override final  String zoneId;
@override final  String zoneName;
@override final  PlaybackState state;
@override final  Track? trackInfo;
@override final  int positionMs;
@override final  int durationMs;
@override final  String positionDisplay;
@override final  double volume;
@override final  String volumeDisplay;
@override final  bool isMuted;
@override@JsonKey() final  ShuffleMode shuffleMode;
@override@JsonKey() final  RepeatMode repeatMode;
@override final  int playingNowPosition;
@override final  int playingNowTracks;
@override final  String playingNowPositionDisplay;
@override final  int playingNowChangeCounter;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatusCopyWith<_PlayerStatus> get copyWith => __$PlayerStatusCopyWithImpl<_PlayerStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStatus&&(identical(other.zoneId, zoneId) || other.zoneId == zoneId)&&(identical(other.zoneName, zoneName) || other.zoneName == zoneName)&&(identical(other.state, state) || other.state == state)&&(identical(other.trackInfo, trackInfo) || other.trackInfo == trackInfo)&&(identical(other.positionMs, positionMs) || other.positionMs == positionMs)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.positionDisplay, positionDisplay) || other.positionDisplay == positionDisplay)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.volumeDisplay, volumeDisplay) || other.volumeDisplay == volumeDisplay)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.shuffleMode, shuffleMode) || other.shuffleMode == shuffleMode)&&(identical(other.repeatMode, repeatMode) || other.repeatMode == repeatMode)&&(identical(other.playingNowPosition, playingNowPosition) || other.playingNowPosition == playingNowPosition)&&(identical(other.playingNowTracks, playingNowTracks) || other.playingNowTracks == playingNowTracks)&&(identical(other.playingNowPositionDisplay, playingNowPositionDisplay) || other.playingNowPositionDisplay == playingNowPositionDisplay)&&(identical(other.playingNowChangeCounter, playingNowChangeCounter) || other.playingNowChangeCounter == playingNowChangeCounter));
}


@override
int get hashCode => Object.hash(runtimeType,zoneId,zoneName,state,trackInfo,positionMs,durationMs,positionDisplay,volume,volumeDisplay,isMuted,shuffleMode,repeatMode,playingNowPosition,playingNowTracks,playingNowPositionDisplay,playingNowChangeCounter);

@override
String toString() {
  return 'PlayerStatus(zoneId: $zoneId, zoneName: $zoneName, state: $state, trackInfo: $trackInfo, positionMs: $positionMs, durationMs: $durationMs, positionDisplay: $positionDisplay, volume: $volume, volumeDisplay: $volumeDisplay, isMuted: $isMuted, shuffleMode: $shuffleMode, repeatMode: $repeatMode, playingNowPosition: $playingNowPosition, playingNowTracks: $playingNowTracks, playingNowPositionDisplay: $playingNowPositionDisplay, playingNowChangeCounter: $playingNowChangeCounter)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatusCopyWith<$Res> implements $PlayerStatusCopyWith<$Res> {
  factory _$PlayerStatusCopyWith(_PlayerStatus value, $Res Function(_PlayerStatus) _then) = __$PlayerStatusCopyWithImpl;
@override @useResult
$Res call({
 String zoneId, String zoneName, PlaybackState state, Track? trackInfo, int positionMs, int durationMs, String positionDisplay, double volume, String volumeDisplay, bool isMuted, ShuffleMode shuffleMode, RepeatMode repeatMode, int playingNowPosition, int playingNowTracks, String playingNowPositionDisplay, int playingNowChangeCounter
});


@override $TrackCopyWith<$Res>? get trackInfo;

}
/// @nodoc
class __$PlayerStatusCopyWithImpl<$Res>
    implements _$PlayerStatusCopyWith<$Res> {
  __$PlayerStatusCopyWithImpl(this._self, this._then);

  final _PlayerStatus _self;
  final $Res Function(_PlayerStatus) _then;

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zoneId = null,Object? zoneName = null,Object? state = null,Object? trackInfo = freezed,Object? positionMs = null,Object? durationMs = null,Object? positionDisplay = null,Object? volume = null,Object? volumeDisplay = null,Object? isMuted = null,Object? shuffleMode = null,Object? repeatMode = null,Object? playingNowPosition = null,Object? playingNowTracks = null,Object? playingNowPositionDisplay = null,Object? playingNowChangeCounter = null,}) {
  return _then(_PlayerStatus(
zoneId: null == zoneId ? _self.zoneId : zoneId // ignore: cast_nullable_to_non_nullable
as String,zoneName: null == zoneName ? _self.zoneName : zoneName // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as PlaybackState,trackInfo: freezed == trackInfo ? _self.trackInfo : trackInfo // ignore: cast_nullable_to_non_nullable
as Track?,positionMs: null == positionMs ? _self.positionMs : positionMs // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,positionDisplay: null == positionDisplay ? _self.positionDisplay : positionDisplay // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,volumeDisplay: null == volumeDisplay ? _self.volumeDisplay : volumeDisplay // ignore: cast_nullable_to_non_nullable
as String,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,shuffleMode: null == shuffleMode ? _self.shuffleMode : shuffleMode // ignore: cast_nullable_to_non_nullable
as ShuffleMode,repeatMode: null == repeatMode ? _self.repeatMode : repeatMode // ignore: cast_nullable_to_non_nullable
as RepeatMode,playingNowPosition: null == playingNowPosition ? _self.playingNowPosition : playingNowPosition // ignore: cast_nullable_to_non_nullable
as int,playingNowTracks: null == playingNowTracks ? _self.playingNowTracks : playingNowTracks // ignore: cast_nullable_to_non_nullable
as int,playingNowPositionDisplay: null == playingNowPositionDisplay ? _self.playingNowPositionDisplay : playingNowPositionDisplay // ignore: cast_nullable_to_non_nullable
as String,playingNowChangeCounter: null == playingNowChangeCounter ? _self.playingNowChangeCounter : playingNowChangeCounter // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlayerStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res>? get trackInfo {
    if (_self.trackInfo == null) {
    return null;
  }

  return $TrackCopyWith<$Res>(_self.trackInfo!, (value) {
    return _then(_self.copyWith(trackInfo: value));
  });
}
}

// dart format on
