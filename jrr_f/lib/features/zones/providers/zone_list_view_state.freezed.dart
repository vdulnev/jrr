// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zone_list_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ZoneListViewState {

 Zones? get zones; Object? get error; Zone? get activeZone; PlaybackState? get activePlaybackState;
/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZoneListViewStateCopyWith<ZoneListViewState> get copyWith => _$ZoneListViewStateCopyWithImpl<ZoneListViewState>(this as ZoneListViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZoneListViewState&&(identical(other.zones, zones) || other.zones == zones)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.activeZone, activeZone) || other.activeZone == activeZone)&&(identical(other.activePlaybackState, activePlaybackState) || other.activePlaybackState == activePlaybackState));
}


@override
int get hashCode => Object.hash(runtimeType,zones,const DeepCollectionEquality().hash(error),activeZone,activePlaybackState);

@override
String toString() {
  return 'ZoneListViewState(zones: $zones, error: $error, activeZone: $activeZone, activePlaybackState: $activePlaybackState)';
}


}

/// @nodoc
abstract mixin class $ZoneListViewStateCopyWith<$Res>  {
  factory $ZoneListViewStateCopyWith(ZoneListViewState value, $Res Function(ZoneListViewState) _then) = _$ZoneListViewStateCopyWithImpl;
@useResult
$Res call({
 Zones? zones, Object? error, Zone? activeZone, PlaybackState? activePlaybackState
});


$ZonesCopyWith<$Res>? get zones;$ZoneCopyWith<$Res>? get activeZone;

}
/// @nodoc
class _$ZoneListViewStateCopyWithImpl<$Res>
    implements $ZoneListViewStateCopyWith<$Res> {
  _$ZoneListViewStateCopyWithImpl(this._self, this._then);

  final ZoneListViewState _self;
  final $Res Function(ZoneListViewState) _then;

/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zones = freezed,Object? error = freezed,Object? activeZone = freezed,Object? activePlaybackState = freezed,}) {
  return _then(_self.copyWith(
zones: freezed == zones ? _self.zones : zones // ignore: cast_nullable_to_non_nullable
as Zones?,error: freezed == error ? _self.error : error ,activeZone: freezed == activeZone ? _self.activeZone : activeZone // ignore: cast_nullable_to_non_nullable
as Zone?,activePlaybackState: freezed == activePlaybackState ? _self.activePlaybackState : activePlaybackState // ignore: cast_nullable_to_non_nullable
as PlaybackState?,
  ));
}
/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZonesCopyWith<$Res>? get zones {
    if (_self.zones == null) {
    return null;
  }

  return $ZonesCopyWith<$Res>(_self.zones!, (value) {
    return _then(_self.copyWith(zones: value));
  });
}/// Create a copy of ZoneListViewState
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
}
}


/// Adds pattern-matching-related methods to [ZoneListViewState].
extension ZoneListViewStatePatterns on ZoneListViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZoneListViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZoneListViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZoneListViewState value)  $default,){
final _that = this;
switch (_that) {
case _ZoneListViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZoneListViewState value)?  $default,){
final _that = this;
switch (_that) {
case _ZoneListViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Zones? zones,  Object? error,  Zone? activeZone,  PlaybackState? activePlaybackState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZoneListViewState() when $default != null:
return $default(_that.zones,_that.error,_that.activeZone,_that.activePlaybackState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Zones? zones,  Object? error,  Zone? activeZone,  PlaybackState? activePlaybackState)  $default,) {final _that = this;
switch (_that) {
case _ZoneListViewState():
return $default(_that.zones,_that.error,_that.activeZone,_that.activePlaybackState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Zones? zones,  Object? error,  Zone? activeZone,  PlaybackState? activePlaybackState)?  $default,) {final _that = this;
switch (_that) {
case _ZoneListViewState() when $default != null:
return $default(_that.zones,_that.error,_that.activeZone,_that.activePlaybackState);case _:
  return null;

}
}

}

/// @nodoc


class _ZoneListViewState extends ZoneListViewState {
  const _ZoneListViewState({required this.zones, required this.error, required this.activeZone, required this.activePlaybackState}): super._();
  

@override final  Zones? zones;
@override final  Object? error;
@override final  Zone? activeZone;
@override final  PlaybackState? activePlaybackState;

/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZoneListViewStateCopyWith<_ZoneListViewState> get copyWith => __$ZoneListViewStateCopyWithImpl<_ZoneListViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZoneListViewState&&(identical(other.zones, zones) || other.zones == zones)&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.activeZone, activeZone) || other.activeZone == activeZone)&&(identical(other.activePlaybackState, activePlaybackState) || other.activePlaybackState == activePlaybackState));
}


@override
int get hashCode => Object.hash(runtimeType,zones,const DeepCollectionEquality().hash(error),activeZone,activePlaybackState);

@override
String toString() {
  return 'ZoneListViewState(zones: $zones, error: $error, activeZone: $activeZone, activePlaybackState: $activePlaybackState)';
}


}

/// @nodoc
abstract mixin class _$ZoneListViewStateCopyWith<$Res> implements $ZoneListViewStateCopyWith<$Res> {
  factory _$ZoneListViewStateCopyWith(_ZoneListViewState value, $Res Function(_ZoneListViewState) _then) = __$ZoneListViewStateCopyWithImpl;
@override @useResult
$Res call({
 Zones? zones, Object? error, Zone? activeZone, PlaybackState? activePlaybackState
});


@override $ZonesCopyWith<$Res>? get zones;@override $ZoneCopyWith<$Res>? get activeZone;

}
/// @nodoc
class __$ZoneListViewStateCopyWithImpl<$Res>
    implements _$ZoneListViewStateCopyWith<$Res> {
  __$ZoneListViewStateCopyWithImpl(this._self, this._then);

  final _ZoneListViewState _self;
  final $Res Function(_ZoneListViewState) _then;

/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zones = freezed,Object? error = freezed,Object? activeZone = freezed,Object? activePlaybackState = freezed,}) {
  return _then(_ZoneListViewState(
zones: freezed == zones ? _self.zones : zones // ignore: cast_nullable_to_non_nullable
as Zones?,error: freezed == error ? _self.error : error ,activeZone: freezed == activeZone ? _self.activeZone : activeZone // ignore: cast_nullable_to_non_nullable
as Zone?,activePlaybackState: freezed == activePlaybackState ? _self.activePlaybackState : activePlaybackState // ignore: cast_nullable_to_non_nullable
as PlaybackState?,
  ));
}

/// Create a copy of ZoneListViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ZonesCopyWith<$Res>? get zones {
    if (_self.zones == null) {
    return null;
  }

  return $ZonesCopyWith<$Res>(_self.zones!, (value) {
    return _then(_self.copyWith(zones: value));
  });
}/// Create a copy of ZoneListViewState
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
}
}

// dart format on
