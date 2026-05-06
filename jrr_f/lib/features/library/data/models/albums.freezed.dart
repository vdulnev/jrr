// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'albums.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Albums {

 List<Album> get albums;
/// Create a copy of Albums
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumsCopyWith<Albums> get copyWith => _$AlbumsCopyWithImpl<Albums>(this as Albums, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Albums&&const DeepCollectionEquality().equals(other.albums, albums));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(albums));

@override
String toString() {
  return 'Albums(albums: $albums)';
}


}

/// @nodoc
abstract mixin class $AlbumsCopyWith<$Res>  {
  factory $AlbumsCopyWith(Albums value, $Res Function(Albums) _then) = _$AlbumsCopyWithImpl;
@useResult
$Res call({
 List<Album> albums
});




}
/// @nodoc
class _$AlbumsCopyWithImpl<$Res>
    implements $AlbumsCopyWith<$Res> {
  _$AlbumsCopyWithImpl(this._self, this._then);

  final Albums _self;
  final $Res Function(Albums) _then;

/// Create a copy of Albums
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? albums = null,}) {
  return _then(_self.copyWith(
albums: null == albums ? _self.albums : albums // ignore: cast_nullable_to_non_nullable
as List<Album>,
  ));
}

}


/// Adds pattern-matching-related methods to [Albums].
extension AlbumsPatterns on Albums {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Albums value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Albums() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Albums value)  $default,){
final _that = this;
switch (_that) {
case _Albums():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Albums value)?  $default,){
final _that = this;
switch (_that) {
case _Albums() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Album> albums)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Albums() when $default != null:
return $default(_that.albums);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Album> albums)  $default,) {final _that = this;
switch (_that) {
case _Albums():
return $default(_that.albums);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Album> albums)?  $default,) {final _that = this;
switch (_that) {
case _Albums() when $default != null:
return $default(_that.albums);case _:
  return null;

}
}

}

/// @nodoc


class _Albums extends Albums {
  const _Albums({final  List<Album> albums = const <Album>[]}): _albums = albums,super._();
  

 final  List<Album> _albums;
@override@JsonKey() List<Album> get albums {
  if (_albums is EqualUnmodifiableListView) return _albums;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_albums);
}


/// Create a copy of Albums
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumsCopyWith<_Albums> get copyWith => __$AlbumsCopyWithImpl<_Albums>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Albums&&const DeepCollectionEquality().equals(other._albums, _albums));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_albums));

@override
String toString() {
  return 'Albums(albums: $albums)';
}


}

/// @nodoc
abstract mixin class _$AlbumsCopyWith<$Res> implements $AlbumsCopyWith<$Res> {
  factory _$AlbumsCopyWith(_Albums value, $Res Function(_Albums) _then) = __$AlbumsCopyWithImpl;
@override @useResult
$Res call({
 List<Album> albums
});




}
/// @nodoc
class __$AlbumsCopyWithImpl<$Res>
    implements _$AlbumsCopyWith<$Res> {
  __$AlbumsCopyWithImpl(this._self, this._then);

  final _Albums _self;
  final $Res Function(_Albums) _then;

/// Create a copy of Albums
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? albums = null,}) {
  return _then(_Albums(
albums: null == albums ? _self._albums : albums // ignore: cast_nullable_to_non_nullable
as List<Album>,
  ));
}


}

// dart format on
