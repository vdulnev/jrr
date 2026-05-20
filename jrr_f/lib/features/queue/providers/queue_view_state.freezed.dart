// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueViewState {

 Tracks? get tracks; Object? get error; int get currentIndex;
/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueViewStateCopyWith<QueueViewState> get copyWith => _$QueueViewStateCopyWithImpl<QueueViewState>(this as QueueViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueViewState&&(identical(other.tracks, tracks) || other.tracks == tracks)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tracks,const DeepCollectionEquality().hash(error),currentIndex);

@override
String toString() {
  return 'QueueViewState(tracks: $tracks, error: $error, currentIndex: $currentIndex)';
}


}

/// @nodoc
abstract mixin class $QueueViewStateCopyWith<$Res>  {
  factory $QueueViewStateCopyWith(QueueViewState value, $Res Function(QueueViewState) _then) = _$QueueViewStateCopyWithImpl;
@useResult
$Res call({
 Tracks? tracks, Object? error, int currentIndex
});


$TracksCopyWith<$Res>? get tracks;

}
/// @nodoc
class _$QueueViewStateCopyWithImpl<$Res>
    implements $QueueViewStateCopyWith<$Res> {
  _$QueueViewStateCopyWithImpl(this._self, this._then);

  final QueueViewState _self;
  final $Res Function(QueueViewState) _then;

/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tracks = freezed,Object? error = freezed,Object? currentIndex = null,}) {
  return _then(_self.copyWith(
tracks: freezed == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as Tracks?,error: freezed == error ? _self.error : error ,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TracksCopyWith<$Res>? get tracks {
    if (_self.tracks == null) {
    return null;
  }

  return $TracksCopyWith<$Res>(_self.tracks!, (value) {
    return _then(_self.copyWith(tracks: value));
  });
}
}


/// Adds pattern-matching-related methods to [QueueViewState].
extension QueueViewStatePatterns on QueueViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueViewState value)  $default,){
final _that = this;
switch (_that) {
case _QueueViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueViewState value)?  $default,){
final _that = this;
switch (_that) {
case _QueueViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Tracks? tracks,  Object? error,  int currentIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueViewState() when $default != null:
return $default(_that.tracks,_that.error,_that.currentIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Tracks? tracks,  Object? error,  int currentIndex)  $default,) {final _that = this;
switch (_that) {
case _QueueViewState():
return $default(_that.tracks,_that.error,_that.currentIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Tracks? tracks,  Object? error,  int currentIndex)?  $default,) {final _that = this;
switch (_that) {
case _QueueViewState() when $default != null:
return $default(_that.tracks,_that.error,_that.currentIndex);case _:
  return null;

}
}

}

/// @nodoc


class _QueueViewState extends QueueViewState {
  const _QueueViewState({required this.tracks, required this.error, required this.currentIndex}): super._();
  

@override final  Tracks? tracks;
@override final  Object? error;
@override final  int currentIndex;

/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueViewStateCopyWith<_QueueViewState> get copyWith => __$QueueViewStateCopyWithImpl<_QueueViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueViewState&&(identical(other.tracks, tracks) || other.tracks == tracks)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex));
}


@override
int get hashCode => Object.hash(runtimeType,tracks,const DeepCollectionEquality().hash(error),currentIndex);

@override
String toString() {
  return 'QueueViewState(tracks: $tracks, error: $error, currentIndex: $currentIndex)';
}


}

/// @nodoc
abstract mixin class _$QueueViewStateCopyWith<$Res> implements $QueueViewStateCopyWith<$Res> {
  factory _$QueueViewStateCopyWith(_QueueViewState value, $Res Function(_QueueViewState) _then) = __$QueueViewStateCopyWithImpl;
@override @useResult
$Res call({
 Tracks? tracks, Object? error, int currentIndex
});


@override $TracksCopyWith<$Res>? get tracks;

}
/// @nodoc
class __$QueueViewStateCopyWithImpl<$Res>
    implements _$QueueViewStateCopyWith<$Res> {
  __$QueueViewStateCopyWithImpl(this._self, this._then);

  final _QueueViewState _self;
  final $Res Function(_QueueViewState) _then;

/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tracks = freezed,Object? error = freezed,Object? currentIndex = null,}) {
  return _then(_QueueViewState(
tracks: freezed == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as Tracks?,error: freezed == error ? _self.error : error ,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of QueueViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TracksCopyWith<$Res>? get tracks {
    if (_self.tracks == null) {
    return null;
  }

  return $TracksCopyWith<$Res>(_self.tracks!, (value) {
    return _then(_self.copyWith(tracks: value));
  });
}
}

// dart format on
