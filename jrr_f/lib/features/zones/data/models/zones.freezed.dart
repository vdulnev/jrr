// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'zones.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Zones {

 List<Zone> get zones;
/// Create a copy of Zones
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZonesCopyWith<Zones> get copyWith => _$ZonesCopyWithImpl<Zones>(this as Zones, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Zones&&const DeepCollectionEquality().equals(other.zones, zones));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(zones));

@override
String toString() {
  return 'Zones(zones: $zones)';
}


}

/// @nodoc
abstract mixin class $ZonesCopyWith<$Res>  {
  factory $ZonesCopyWith(Zones value, $Res Function(Zones) _then) = _$ZonesCopyWithImpl;
@useResult
$Res call({
 List<Zone> zones
});




}
/// @nodoc
class _$ZonesCopyWithImpl<$Res>
    implements $ZonesCopyWith<$Res> {
  _$ZonesCopyWithImpl(this._self, this._then);

  final Zones _self;
  final $Res Function(Zones) _then;

/// Create a copy of Zones
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? zones = null,}) {
  return _then(_self.copyWith(
zones: null == zones ? _self.zones : zones // ignore: cast_nullable_to_non_nullable
as List<Zone>,
  ));
}

}


/// Adds pattern-matching-related methods to [Zones].
extension ZonesPatterns on Zones {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Zones value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Zones() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Zones value)  $default,){
final _that = this;
switch (_that) {
case _Zones():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Zones value)?  $default,){
final _that = this;
switch (_that) {
case _Zones() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Zone> zones)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Zones() when $default != null:
return $default(_that.zones);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Zone> zones)  $default,) {final _that = this;
switch (_that) {
case _Zones():
return $default(_that.zones);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Zone> zones)?  $default,) {final _that = this;
switch (_that) {
case _Zones() when $default != null:
return $default(_that.zones);case _:
  return null;

}
}

}

/// @nodoc


class _Zones implements Zones {
  const _Zones({required final  List<Zone> zones}): _zones = zones;
  

 final  List<Zone> _zones;
@override List<Zone> get zones {
  if (_zones is EqualUnmodifiableListView) return _zones;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_zones);
}


/// Create a copy of Zones
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZonesCopyWith<_Zones> get copyWith => __$ZonesCopyWithImpl<_Zones>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Zones&&const DeepCollectionEquality().equals(other._zones, _zones));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_zones));

@override
String toString() {
  return 'Zones(zones: $zones)';
}


}

/// @nodoc
abstract mixin class _$ZonesCopyWith<$Res> implements $ZonesCopyWith<$Res> {
  factory _$ZonesCopyWith(_Zones value, $Res Function(_Zones) _then) = __$ZonesCopyWithImpl;
@override @useResult
$Res call({
 List<Zone> zones
});




}
/// @nodoc
class __$ZonesCopyWithImpl<$Res>
    implements _$ZonesCopyWith<$Res> {
  __$ZonesCopyWithImpl(this._self, this._then);

  final _Zones _self;
  final $Res Function(_Zones) _then;

/// Create a copy of Zones
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? zones = null,}) {
  return _then(_Zones(
zones: null == zones ? _self._zones : zones // ignore: cast_nullable_to_non_nullable
as List<Zone>,
  ));
}


}

// dart format on
