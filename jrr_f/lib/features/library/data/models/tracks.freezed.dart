// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Tracks {

 List<Track> get tracks;
/// Create a copy of Tracks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TracksCopyWith<Tracks> get copyWith => _$TracksCopyWithImpl<Tracks>(this as Tracks, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tracks&&const DeepCollectionEquality().equals(other.tracks, tracks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tracks));

@override
String toString() {
  return 'Tracks(tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class $TracksCopyWith<$Res>  {
  factory $TracksCopyWith(Tracks value, $Res Function(Tracks) _then) = _$TracksCopyWithImpl;
@useResult
$Res call({
 List<Track> tracks
});




}
/// @nodoc
class _$TracksCopyWithImpl<$Res>
    implements $TracksCopyWith<$Res> {
  _$TracksCopyWithImpl(this._self, this._then);

  final Tracks _self;
  final $Res Function(Tracks) _then;

/// Create a copy of Tracks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tracks = null,}) {
  return _then(_self.copyWith(
tracks: null == tracks ? _self.tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,
  ));
}

}


/// Adds pattern-matching-related methods to [Tracks].
extension TracksPatterns on Tracks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tracks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tracks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tracks value)  $default,){
final _that = this;
switch (_that) {
case _Tracks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tracks value)?  $default,){
final _that = this;
switch (_that) {
case _Tracks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Track> tracks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tracks() when $default != null:
return $default(_that.tracks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Track> tracks)  $default,) {final _that = this;
switch (_that) {
case _Tracks():
return $default(_that.tracks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Track> tracks)?  $default,) {final _that = this;
switch (_that) {
case _Tracks() when $default != null:
return $default(_that.tracks);case _:
  return null;

}
}

}

/// @nodoc


class _Tracks extends Tracks {
  const _Tracks({final  List<Track> tracks = const <Track>[]}): _tracks = tracks,super._();
  

 final  List<Track> _tracks;
@override@JsonKey() List<Track> get tracks {
  if (_tracks is EqualUnmodifiableListView) return _tracks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tracks);
}


/// Create a copy of Tracks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TracksCopyWith<_Tracks> get copyWith => __$TracksCopyWithImpl<_Tracks>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tracks&&const DeepCollectionEquality().equals(other._tracks, _tracks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tracks));

@override
String toString() {
  return 'Tracks(tracks: $tracks)';
}


}

/// @nodoc
abstract mixin class _$TracksCopyWith<$Res> implements $TracksCopyWith<$Res> {
  factory _$TracksCopyWith(_Tracks value, $Res Function(_Tracks) _then) = __$TracksCopyWithImpl;
@override @useResult
$Res call({
 List<Track> tracks
});




}
/// @nodoc
class __$TracksCopyWithImpl<$Res>
    implements _$TracksCopyWith<$Res> {
  __$TracksCopyWithImpl(this._self, this._then);

  final _Tracks _self;
  final $Res Function(_Tracks) _then;

/// Create a copy of Tracks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tracks = null,}) {
  return _then(_Tracks(
tracks: null == tracks ? _self._tracks : tracks // ignore: cast_nullable_to_non_nullable
as List<Track>,
  ));
}


}

// dart format on
