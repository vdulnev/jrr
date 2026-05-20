// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_tile_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LibraryItemTileViewState {

 bool get isOffline; DownloadState get downloadState;
/// Create a copy of LibraryItemTileViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LibraryItemTileViewStateCopyWith<LibraryItemTileViewState> get copyWith => _$LibraryItemTileViewStateCopyWithImpl<LibraryItemTileViewState>(this as LibraryItemTileViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LibraryItemTileViewState&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.downloadState, downloadState) || other.downloadState == downloadState));
}


@override
int get hashCode => Object.hash(runtimeType,isOffline,downloadState);

@override
String toString() {
  return 'LibraryItemTileViewState(isOffline: $isOffline, downloadState: $downloadState)';
}


}

/// @nodoc
abstract mixin class $LibraryItemTileViewStateCopyWith<$Res>  {
  factory $LibraryItemTileViewStateCopyWith(LibraryItemTileViewState value, $Res Function(LibraryItemTileViewState) _then) = _$LibraryItemTileViewStateCopyWithImpl;
@useResult
$Res call({
 bool isOffline, DownloadState downloadState
});




}
/// @nodoc
class _$LibraryItemTileViewStateCopyWithImpl<$Res>
    implements $LibraryItemTileViewStateCopyWith<$Res> {
  _$LibraryItemTileViewStateCopyWithImpl(this._self, this._then);

  final LibraryItemTileViewState _self;
  final $Res Function(LibraryItemTileViewState) _then;

/// Create a copy of LibraryItemTileViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOffline = null,Object? downloadState = null,}) {
  return _then(_self.copyWith(
isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,downloadState: null == downloadState ? _self.downloadState : downloadState // ignore: cast_nullable_to_non_nullable
as DownloadState,
  ));
}

}


/// Adds pattern-matching-related methods to [LibraryItemTileViewState].
extension LibraryItemTileViewStatePatterns on LibraryItemTileViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LibraryItemTileViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LibraryItemTileViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LibraryItemTileViewState value)  $default,){
final _that = this;
switch (_that) {
case _LibraryItemTileViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LibraryItemTileViewState value)?  $default,){
final _that = this;
switch (_that) {
case _LibraryItemTileViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOffline,  DownloadState downloadState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LibraryItemTileViewState() when $default != null:
return $default(_that.isOffline,_that.downloadState);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOffline,  DownloadState downloadState)  $default,) {final _that = this;
switch (_that) {
case _LibraryItemTileViewState():
return $default(_that.isOffline,_that.downloadState);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOffline,  DownloadState downloadState)?  $default,) {final _that = this;
switch (_that) {
case _LibraryItemTileViewState() when $default != null:
return $default(_that.isOffline,_that.downloadState);case _:
  return null;

}
}

}

/// @nodoc


class _LibraryItemTileViewState extends LibraryItemTileViewState {
  const _LibraryItemTileViewState({required this.isOffline, required this.downloadState}): super._();
  

@override final  bool isOffline;
@override final  DownloadState downloadState;

/// Create a copy of LibraryItemTileViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LibraryItemTileViewStateCopyWith<_LibraryItemTileViewState> get copyWith => __$LibraryItemTileViewStateCopyWithImpl<_LibraryItemTileViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LibraryItemTileViewState&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.downloadState, downloadState) || other.downloadState == downloadState));
}


@override
int get hashCode => Object.hash(runtimeType,isOffline,downloadState);

@override
String toString() {
  return 'LibraryItemTileViewState(isOffline: $isOffline, downloadState: $downloadState)';
}


}

/// @nodoc
abstract mixin class _$LibraryItemTileViewStateCopyWith<$Res> implements $LibraryItemTileViewStateCopyWith<$Res> {
  factory _$LibraryItemTileViewStateCopyWith(_LibraryItemTileViewState value, $Res Function(_LibraryItemTileViewState) _then) = __$LibraryItemTileViewStateCopyWithImpl;
@override @useResult
$Res call({
 bool isOffline, DownloadState downloadState
});




}
/// @nodoc
class __$LibraryItemTileViewStateCopyWithImpl<$Res>
    implements _$LibraryItemTileViewStateCopyWith<$Res> {
  __$LibraryItemTileViewStateCopyWithImpl(this._self, this._then);

  final _LibraryItemTileViewState _self;
  final $Res Function(_LibraryItemTileViewState) _then;

/// Create a copy of LibraryItemTileViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOffline = null,Object? downloadState = null,}) {
  return _then(_LibraryItemTileViewState(
isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,downloadState: null == downloadState ? _self.downloadState : downloadState // ignore: cast_nullable_to_non_nullable
as DownloadState,
  ));
}


}

// dart format on
