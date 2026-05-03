// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlayerStateData {

 bool get playing; ProcessingState get processingState;
/// Create a copy of PlayerStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateDataCopyWith<PlayerStateData> get copyWith => _$PlayerStateDataCopyWithImpl<PlayerStateData>(this as PlayerStateData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStateData&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.processingState, processingState) || other.processingState == processingState));
}


@override
int get hashCode => Object.hash(runtimeType,playing,processingState);

@override
String toString() {
  return 'PlayerStateData(playing: $playing, processingState: $processingState)';
}


}

/// @nodoc
abstract mixin class $PlayerStateDataCopyWith<$Res>  {
  factory $PlayerStateDataCopyWith(PlayerStateData value, $Res Function(PlayerStateData) _then) = _$PlayerStateDataCopyWithImpl;
@useResult
$Res call({
 bool playing, ProcessingState processingState
});




}
/// @nodoc
class _$PlayerStateDataCopyWithImpl<$Res>
    implements $PlayerStateDataCopyWith<$Res> {
  _$PlayerStateDataCopyWithImpl(this._self, this._then);

  final PlayerStateData _self;
  final $Res Function(PlayerStateData) _then;

/// Create a copy of PlayerStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playing = null,Object? processingState = null,}) {
  return _then(_self.copyWith(
playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as ProcessingState,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerStateData].
extension PlayerStateDataPatterns on PlayerStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStateData value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStateData value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool playing,  ProcessingState processingState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStateData() when $default != null:
return $default(_that.playing,_that.processingState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool playing,  ProcessingState processingState)  $default,) {final _that = this;
switch (_that) {
case _PlayerStateData():
return $default(_that.playing,_that.processingState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool playing,  ProcessingState processingState)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStateData() when $default != null:
return $default(_that.playing,_that.processingState);case _:
  return null;

}
}

}

/// @nodoc


class _PlayerStateData extends PlayerStateData {
  const _PlayerStateData({required this.playing, required this.processingState}): super._();
  

@override final  bool playing;
@override final  ProcessingState processingState;

/// Create a copy of PlayerStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateDataCopyWith<_PlayerStateData> get copyWith => __$PlayerStateDataCopyWithImpl<_PlayerStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStateData&&(identical(other.playing, playing) || other.playing == playing)&&(identical(other.processingState, processingState) || other.processingState == processingState));
}


@override
int get hashCode => Object.hash(runtimeType,playing,processingState);

@override
String toString() {
  return 'PlayerStateData(playing: $playing, processingState: $processingState)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateDataCopyWith<$Res> implements $PlayerStateDataCopyWith<$Res> {
  factory _$PlayerStateDataCopyWith(_PlayerStateData value, $Res Function(_PlayerStateData) _then) = __$PlayerStateDataCopyWithImpl;
@override @useResult
$Res call({
 bool playing, ProcessingState processingState
});




}
/// @nodoc
class __$PlayerStateDataCopyWithImpl<$Res>
    implements _$PlayerStateDataCopyWith<$Res> {
  __$PlayerStateDataCopyWithImpl(this._self, this._then);

  final _PlayerStateData _self;
  final $Res Function(_PlayerStateData) _then;

/// Create a copy of PlayerStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playing = null,Object? processingState = null,}) {
  return _then(_PlayerStateData(
playing: null == playing ? _self.playing : playing // ignore: cast_nullable_to_non_nullable
as bool,processingState: null == processingState ? _self.processingState : processingState // ignore: cast_nullable_to_non_nullable
as ProcessingState,
  ));
}


}

// dart format on
