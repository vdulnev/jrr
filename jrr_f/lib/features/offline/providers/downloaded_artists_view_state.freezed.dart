// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_artists_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadedArtistsViewState {

 List<String>? get artists; Object? get error;
/// Create a copy of DownloadedArtistsViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedArtistsViewStateCopyWith<DownloadedArtistsViewState> get copyWith => _$DownloadedArtistsViewStateCopyWithImpl<DownloadedArtistsViewState>(this as DownloadedArtistsViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadedArtistsViewState&&const DeepCollectionEquality().equals(other.artists, artists)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(artists),const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'DownloadedArtistsViewState(artists: $artists, error: $error)';
}


}

/// @nodoc
abstract mixin class $DownloadedArtistsViewStateCopyWith<$Res>  {
  factory $DownloadedArtistsViewStateCopyWith(DownloadedArtistsViewState value, $Res Function(DownloadedArtistsViewState) _then) = _$DownloadedArtistsViewStateCopyWithImpl;
@useResult
$Res call({
 List<String>? artists, Object? error
});




}
/// @nodoc
class _$DownloadedArtistsViewStateCopyWithImpl<$Res>
    implements $DownloadedArtistsViewStateCopyWith<$Res> {
  _$DownloadedArtistsViewStateCopyWithImpl(this._self, this._then);

  final DownloadedArtistsViewState _self;
  final $Res Function(DownloadedArtistsViewState) _then;

/// Create a copy of DownloadedArtistsViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? artists = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
artists: freezed == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>?,error: freezed == error ? _self.error : error ,
  ));
}

}


/// Adds pattern-matching-related methods to [DownloadedArtistsViewState].
extension DownloadedArtistsViewStatePatterns on DownloadedArtistsViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadedArtistsViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadedArtistsViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadedArtistsViewState value)  $default,){
final _that = this;
switch (_that) {
case _DownloadedArtistsViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadedArtistsViewState value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadedArtistsViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String>? artists,  Object? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadedArtistsViewState() when $default != null:
return $default(_that.artists,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String>? artists,  Object? error)  $default,) {final _that = this;
switch (_that) {
case _DownloadedArtistsViewState():
return $default(_that.artists,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String>? artists,  Object? error)?  $default,) {final _that = this;
switch (_that) {
case _DownloadedArtistsViewState() when $default != null:
return $default(_that.artists,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _DownloadedArtistsViewState extends DownloadedArtistsViewState {
  const _DownloadedArtistsViewState({required final  List<String>? artists, required this.error}): _artists = artists,super._();
  

 final  List<String>? _artists;
@override List<String>? get artists {
  final value = _artists;
  if (value == null) return null;
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  Object? error;

/// Create a copy of DownloadedArtistsViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadedArtistsViewStateCopyWith<_DownloadedArtistsViewState> get copyWith => __$DownloadedArtistsViewStateCopyWithImpl<_DownloadedArtistsViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadedArtistsViewState&&const DeepCollectionEquality().equals(other._artists, _artists)&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_artists),const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'DownloadedArtistsViewState(artists: $artists, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DownloadedArtistsViewStateCopyWith<$Res> implements $DownloadedArtistsViewStateCopyWith<$Res> {
  factory _$DownloadedArtistsViewStateCopyWith(_DownloadedArtistsViewState value, $Res Function(_DownloadedArtistsViewState) _then) = __$DownloadedArtistsViewStateCopyWithImpl;
@override @useResult
$Res call({
 List<String>? artists, Object? error
});




}
/// @nodoc
class __$DownloadedArtistsViewStateCopyWithImpl<$Res>
    implements _$DownloadedArtistsViewStateCopyWith<$Res> {
  __$DownloadedArtistsViewStateCopyWithImpl(this._self, this._then);

  final _DownloadedArtistsViewState _self;
  final $Res Function(_DownloadedArtistsViewState) _then;

/// Create a copy of DownloadedArtistsViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? artists = freezed,Object? error = freezed,}) {
  return _then(_DownloadedArtistsViewState(
artists: freezed == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<String>?,error: freezed == error ? _self.error : error ,
  ));
}


}

// dart format on
