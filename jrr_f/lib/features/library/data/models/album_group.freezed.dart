// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AlbumGroup {

 Album get album; List<Album> get discs;
/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumGroupCopyWith<AlbumGroup> get copyWith => _$AlbumGroupCopyWithImpl<AlbumGroup>(this as AlbumGroup, _$identity);





@override
String toString() {
  return 'AlbumGroup(album: $album, discs: $discs)';
}


}

/// @nodoc
abstract mixin class $AlbumGroupCopyWith<$Res>  {
  factory $AlbumGroupCopyWith(AlbumGroup value, $Res Function(AlbumGroup) _then) = _$AlbumGroupCopyWithImpl;
@useResult
$Res call({
 Album album, List<Album> discs
});


$AlbumCopyWith<$Res> get album;

}
/// @nodoc
class _$AlbumGroupCopyWithImpl<$Res>
    implements $AlbumGroupCopyWith<$Res> {
  _$AlbumGroupCopyWithImpl(this._self, this._then);

  final AlbumGroup _self;
  final $Res Function(AlbumGroup) _then;

/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? album = null,Object? discs = null,}) {
  return _then(_self.copyWith(
album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as Album,discs: null == discs ? _self.discs : discs // ignore: cast_nullable_to_non_nullable
as List<Album>,
  ));
}
/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumCopyWith<$Res> get album {
  
  return $AlbumCopyWith<$Res>(_self.album, (value) {
    return _then(_self.copyWith(album: value));
  });
}
}


/// Adds pattern-matching-related methods to [AlbumGroup].
extension AlbumGroupPatterns on AlbumGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AlbumGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AlbumGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AlbumGroup value)  $default,){
final _that = this;
switch (_that) {
case _AlbumGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AlbumGroup value)?  $default,){
final _that = this;
switch (_that) {
case _AlbumGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Album album,  List<Album> discs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AlbumGroup() when $default != null:
return $default(_that.album,_that.discs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Album album,  List<Album> discs)  $default,) {final _that = this;
switch (_that) {
case _AlbumGroup():
return $default(_that.album,_that.discs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Album album,  List<Album> discs)?  $default,) {final _that = this;
switch (_that) {
case _AlbumGroup() when $default != null:
return $default(_that.album,_that.discs);case _:
  return null;

}
}

}

/// @nodoc


class _AlbumGroup extends AlbumGroup {
  const _AlbumGroup({required this.album, final  List<Album> discs = const <Album>[]}): _discs = discs,super._();
  

@override final  Album album;
 final  List<Album> _discs;
@override@JsonKey() List<Album> get discs {
  if (_discs is EqualUnmodifiableListView) return _discs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_discs);
}


/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumGroupCopyWith<_AlbumGroup> get copyWith => __$AlbumGroupCopyWithImpl<_AlbumGroup>(this, _$identity);





@override
String toString() {
  return 'AlbumGroup(album: $album, discs: $discs)';
}


}

/// @nodoc
abstract mixin class _$AlbumGroupCopyWith<$Res> implements $AlbumGroupCopyWith<$Res> {
  factory _$AlbumGroupCopyWith(_AlbumGroup value, $Res Function(_AlbumGroup) _then) = __$AlbumGroupCopyWithImpl;
@override @useResult
$Res call({
 Album album, List<Album> discs
});


@override $AlbumCopyWith<$Res> get album;

}
/// @nodoc
class __$AlbumGroupCopyWithImpl<$Res>
    implements _$AlbumGroupCopyWith<$Res> {
  __$AlbumGroupCopyWithImpl(this._self, this._then);

  final _AlbumGroup _self;
  final $Res Function(_AlbumGroup) _then;

/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? album = null,Object? discs = null,}) {
  return _then(_AlbumGroup(
album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as Album,discs: null == discs ? _self._discs : discs // ignore: cast_nullable_to_non_nullable
as List<Album>,
  ));
}

/// Create a copy of AlbumGroup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumCopyWith<$Res> get album {
  
  return $AlbumCopyWith<$Res>(_self.album, (value) {
    return _then(_self.copyWith(album: value));
  });
}
}

// dart format on
