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

 SequenceState get sequenceState; ProcessingState get processingState; bool get playing; Duration get position; Duration? get duration; double get volume; bool get shuffleModeEnabled; LoopMode get loopMode;
/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocalPlaybackStateCopyWith<LocalPlaybackState> get copyWith => _$LocalPlaybackStateCopyWithImpl<LocalPlaybackState>(this as LocalPlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LocalPlaybackState&&(identical(other.sequenceState, sequenceState) || other.sequenceState == sequenceState)&&(identical(other.processingState, processingState) || other.processingState == processingState)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode));
}


@override
int get hashCode => Object.hash(runtimeType,sequenceState,processingState,playing,position,duration,volume,shuffleModeEnabled,loopMode);

@override
String toString() {
  return 'LocalPlaybackState(sequenceState: $sequenceState, processingState: $processingState, playing: $playing, position: $position, duration: $duration, volume: $volume, shuffleModeEnabled: $shuffleModeEnabled, loopMode: $loopMode)';
}


}

/// @nodoc
abstract mixin class $LocalPlaybackStateCopyWith<$Res>  {
  factory $LocalPlaybackStateCopyWith(LocalPlaybackState value, $Res Function(LocalPlaybackState) _then) = _$LocalPlaybackStateCopyWithImpl;
@useResult
$Res call({
 SequenceState sequenceState, ProcessingState processingState, bool playing, Duration position, Duration? duration, double volume, bool shuffleModeEnabled, LoopMode loopMode
});




}
/// @nodoc
class _$LocalPlaybackStateCopyWithImpl<$Res>
    implements $LocalPlaybackStateCopyWith<$Res> {
  _$LocalPlaybackStateCopyWithImpl(this._self, this._then);

  final LocalPlaybackState _self;
  final $Res Function(LocalPlaybackState) _then;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sequenceState = null,Object? processingState = null,Object? playing = null,Object? position = null,Object? duration = freezed,Object? volume = null,Object? shuffleModeEnabled = null,Object? loopMode = null,}) {
  return _then(_self.copyWith(
sequenceState: null == sequenceState ? _self.sequenceState : sequenceState // ignore: cast_nullable_to_non_nullable
as SequenceState,processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as ProcessingState,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as LoopMode,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SequenceState sequenceState,  ProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  double volume,  bool shuffleModeEnabled,  LoopMode loopMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
return $default(_that.sequenceState,_that.processingState,_that.playing,_that.position,_that.duration,_that.volume,_that.shuffleModeEnabled,_that.loopMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SequenceState sequenceState,  ProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  double volume,  bool shuffleModeEnabled,  LoopMode loopMode)  $default,) {final _that = this;
switch (_that) {
case _LocalPlaybackState():
return $default(_that.sequenceState,_that.processingState,_that.playing,_that.position,_that.duration,_that.volume,_that.shuffleModeEnabled,_that.loopMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SequenceState sequenceState,  ProcessingState processingState,  bool playing,  Duration position,  Duration? duration,  double volume,  bool shuffleModeEnabled,  LoopMode loopMode)?  $default,) {final _that = this;
switch (_that) {
case _LocalPlaybackState() when $default != null:
return $default(_that.sequenceState,_that.processingState,_that.playing,_that.position,_that.duration,_that.volume,_that.shuffleModeEnabled,_that.loopMode);case _:
  return null;

}
}

}

/// @nodoc


class _LocalPlaybackState implements LocalPlaybackState {
  const _LocalPlaybackState({required this.sequenceState, required this.processingState, required this.playing, required this.position, this.duration, required this.volume, required this.shuffleModeEnabled, required this.loopMode});
  

@override final  SequenceState sequenceState;
@override final  ProcessingState processingState;
@override final  bool playing;
@override final  Duration position;
@override final  Duration? duration;
@override final  double volume;
@override final  bool shuffleModeEnabled;
@override final  LoopMode loopMode;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocalPlaybackStateCopyWith<_LocalPlaybackState> get copyWith => __$LocalPlaybackStateCopyWithImpl<_LocalPlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LocalPlaybackState&&(identical(other.sequenceState, sequenceState) || other.sequenceState == sequenceState)&&(identical(other.processingState, processingState) || other.processingState == processingState)&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode));
}


@override
int get hashCode => Object.hash(runtimeType,sequenceState,processingState,playing,position,duration,volume,shuffleModeEnabled,loopMode);

@override
String toString() {
  return 'LocalPlaybackState(sequenceState: $sequenceState, processingState: $processingState, playing: $playing, position: $position, duration: $duration, volume: $volume, shuffleModeEnabled: $shuffleModeEnabled, loopMode: $loopMode)';
}


}

/// @nodoc
abstract mixin class _$LocalPlaybackStateCopyWith<$Res> implements $LocalPlaybackStateCopyWith<$Res> {
  factory _$LocalPlaybackStateCopyWith(_LocalPlaybackState value, $Res Function(_LocalPlaybackState) _then) = __$LocalPlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 SequenceState sequenceState, ProcessingState processingState, bool playing, Duration position, Duration? duration, double volume, bool shuffleModeEnabled, LoopMode loopMode
});




}
/// @nodoc
class __$LocalPlaybackStateCopyWithImpl<$Res>
    implements _$LocalPlaybackStateCopyWith<$Res> {
  __$LocalPlaybackStateCopyWithImpl(this._self, this._then);

  final _LocalPlaybackState _self;
  final $Res Function(_LocalPlaybackState) _then;

/// Create a copy of LocalPlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sequenceState = null,Object? processingState = null,Object? playing = null,Object? position = null,Object? duration = freezed,Object? volume = null,Object? shuffleModeEnabled = null,Object? loopMode = null,}) {
  return _then(_LocalPlaybackState(
sequenceState: null == sequenceState ? _self.sequenceState : sequenceState // ignore: cast_nullable_to_non_nullable
as SequenceState,processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as ProcessingState,playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration?,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as LoopMode,
  ));
}


}

// dart format on
