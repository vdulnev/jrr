// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'local_palyback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LocalPlaybackState {

 SequenceStateData? get sequenceState; PlayerStateData get playerState; Duration get position; Duration? get duration; double get volume;
/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPlaybackStateCopyWith<LocalPlaybackState> get copyWith => _$LocalPlaybackStateCopyWithImpl<LocalPlaybackState>(this as LocalPlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPlaybackState&&(identical(other.sequenceState, sequenceState) || other.sequenceState == sequenceState)&&(identical(other.playerState, playerState) || other.playerState == playerState)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,sequenceState,playerState,position,duration,volume);



}

/// @nodoc
abstract mixin class $LocalPlaybackStateCopyWith<$Res>  {
  factory $LocalPlaybackStateCopyWith(LocalPlaybackState value, $Res Function(LocalPlaybackState) _then) = _$LocalPlaybackStateCopyWithImpl;
@useResult
$Res call({
 SequenceStateData? sequenceState, PlayerStateData playerState, Duration position, Duration? duration, double volume
});


$SequenceStateDataCopyWith<$Res>? get sequenceState;$PlayerStateDataCopyWith<$Res> get playerState;

}
/// @nodoc
class _$LocalPlaybackStateCopyWithImpl<$Res>
    implements $LocalPlaybackStateCopyWith<$Res> {
  _$LocalPlaybackStateCopyWithImpl(this._self, this._then);

  final LocalPlaybackState _self;
  final $Res Function(LocalPlaybackState) _then;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sequenceState = freezed,Object? playerState = null,Object? position = null,Object? duration = freezed,Object? volume = null,}) {
  return _then(_self.copyWith(
sequenceState: freezed == sequenceState ? _self.sequenceState : sequenceState // ignore: cast_nullable_to_non_nullable
as SequenceStateData?,playerState: null == playerState ? _self.playerState : playerState // ignore: cast_nullable_to_non_nullable
as PlayerStateData,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SequenceStateDataCopyWith<$Res>? get sequenceState {
    if (_self.sequenceState == null) {
    return null;
  }

  return $SequenceStateDataCopyWith<$Res>(_self.sequenceState!, (value) {
    return _then(_self.copyWith(sequenceState: value));
  });
}/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStateDataCopyWith<$Res> get playerState {
  
  return $PlayerStateDataCopyWith<$Res>(_self.playerState, (value) {
    return _then(_self.copyWith(playerState: value));
  });
}
}


/// Adds pattern-matching-related methods to [LocalPlaybackState].
extension LocalPlaybackStatePatterns on LocalPlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LocalPlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LocalPlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _LocalPlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LocalPlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SequenceStateData? sequenceState,  PlayerStateData playerState,  Duration position,  Duration? duration,  double volume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
return $default(_that.sequenceState,_that.playerState,_that.position,_that.duration,_that.volume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SequenceStateData? sequenceState,  PlayerStateData playerState,  Duration position,  Duration? duration,  double volume)  $default,) {final _that = this;
switch (_that) {
case _LocalPlaybackState():
return $default(_that.sequenceState,_that.playerState,_that.position,_that.duration,_that.volume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SequenceStateData? sequenceState,  PlayerStateData playerState,  Duration position,  Duration? duration,  double volume)?  $default,) {final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
return $default(_that.sequenceState,_that.playerState,_that.position,_that.duration,_that.volume);case _:
  return null;

}
}

}

/// @nodoc


class _LocalPlaybackState extends LocalPlaybackState {
  const _LocalPlaybackState({this.sequenceState, required this.playerState, required this.position, this.duration, required this.volume}): super._();
  

@override final  SequenceStateData? sequenceState;
@override final  PlayerStateData playerState;
@override final  Duration position;
@override final  Duration? duration;
@override final  double volume;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPlaybackStateCopyWith<_LocalPlaybackState> get copyWith => __$LocalPlaybackStateCopyWithImpl<_LocalPlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPlaybackState&&(identical(other.sequenceState, sequenceState) || other.sequenceState == sequenceState)&&(identical(other.playerState, playerState) || other.playerState == playerState)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume));
}


@override
int get hashCode => Object.hash(runtimeType,sequenceState,playerState,position,duration,volume);



}

/// @nodoc
abstract mixin class _$LocalPlaybackStateCopyWith<$Res> implements $LocalPlaybackStateCopyWith<$Res> {
  factory _$LocalPlaybackStateCopyWith(_LocalPlaybackState value, $Res Function(_LocalPlaybackState) _then) = __$LocalPlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 SequenceStateData? sequenceState, PlayerStateData playerState, Duration position, Duration? duration, double volume
});


@override $SequenceStateDataCopyWith<$Res>? get sequenceState;@override $PlayerStateDataCopyWith<$Res> get playerState;

}
/// @nodoc
class __$LocalPlaybackStateCopyWithImpl<$Res>
    implements _$LocalPlaybackStateCopyWith<$Res> {
  __$LocalPlaybackStateCopyWithImpl(this._self, this._then);

  final _LocalPlaybackState _self;
  final $Res Function(_LocalPlaybackState) _then;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sequenceState = freezed,Object? playerState = null,Object? position = null,Object? duration = freezed,Object? volume = null,}) {
  return _then(_LocalPlaybackState(
sequenceState: freezed == sequenceState ? _self.sequenceState : sequenceState // ignore: cast_nullable_to_non_nullable
as SequenceStateData?,playerState: null == playerState ? _self.playerState : playerState // ignore: cast_nullable_to_non_nullable
as PlayerStateData,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SequenceStateDataCopyWith<$Res>? get sequenceState {
    if (_self.sequenceState == null) {
    return null;
  }

  return $SequenceStateDataCopyWith<$Res>(_self.sequenceState!, (value) {
    return _then(_self.copyWith(sequenceState: value));
  });
}/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStateDataCopyWith<$Res> get playerState {
  
  return $PlayerStateDataCopyWith<$Res>(_self.playerState, (value) {
    return _then(_self.copyWith(playerState: value));
  });
}
}

// dart format on
