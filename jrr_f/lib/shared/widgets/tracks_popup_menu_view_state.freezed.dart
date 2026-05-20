// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracks_popup_menu_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TracksPopupMenuViewState {

 bool get isOffline; bool get hidden; bool get showDownload; bool get showCancel; bool get showDelete; bool get showRetry;
/// Create a copy of TracksPopupMenuViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TracksPopupMenuViewStateCopyWith<TracksPopupMenuViewState> get copyWith => _$TracksPopupMenuViewStateCopyWithImpl<TracksPopupMenuViewState>(this as TracksPopupMenuViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TracksPopupMenuViewState&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.showDownload, showDownload) || other.showDownload == showDownload)&&(identical(other.showCancel, showCancel) || other.showCancel == showCancel)&&(identical(other.showDelete, showDelete) || other.showDelete == showDelete)&&(identical(other.showRetry, showRetry) || other.showRetry == showRetry));
}


@override
int get hashCode => Object.hash(runtimeType,isOffline,hidden,showDownload,showCancel,showDelete,showRetry);

@override
String toString() {
  return 'TracksPopupMenuViewState(isOffline: $isOffline, hidden: $hidden, showDownload: $showDownload, showCancel: $showCancel, showDelete: $showDelete, showRetry: $showRetry)';
}


}

/// @nodoc
abstract mixin class $TracksPopupMenuViewStateCopyWith<$Res>  {
  factory $TracksPopupMenuViewStateCopyWith(TracksPopupMenuViewState value, $Res Function(TracksPopupMenuViewState) _then) = _$TracksPopupMenuViewStateCopyWithImpl;
@useResult
$Res call({
 bool isOffline, bool hidden, bool showDownload, bool showCancel, bool showDelete, bool showRetry
});




}
/// @nodoc
class _$TracksPopupMenuViewStateCopyWithImpl<$Res>
    implements $TracksPopupMenuViewStateCopyWith<$Res> {
  _$TracksPopupMenuViewStateCopyWithImpl(this._self, this._then);

  final TracksPopupMenuViewState _self;
  final $Res Function(TracksPopupMenuViewState) _then;

/// Create a copy of TracksPopupMenuViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isOffline = null,Object? hidden = null,Object? showDownload = null,Object? showCancel = null,Object? showDelete = null,Object? showRetry = null,}) {
  return _then(_self.copyWith(
isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,showDownload: null == showDownload ? _self.showDownload : showDownload // ignore: cast_nullable_to_non_nullable
as bool,showCancel: null == showCancel ? _self.showCancel : showCancel // ignore: cast_nullable_to_non_nullable
as bool,showDelete: null == showDelete ? _self.showDelete : showDelete // ignore: cast_nullable_to_non_nullable
as bool,showRetry: null == showRetry ? _self.showRetry : showRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TracksPopupMenuViewState].
extension TracksPopupMenuViewStatePatterns on TracksPopupMenuViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TracksPopupMenuViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TracksPopupMenuViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TracksPopupMenuViewState value)  $default,){
final _that = this;
switch (_that) {
case _TracksPopupMenuViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TracksPopupMenuViewState value)?  $default,){
final _that = this;
switch (_that) {
case _TracksPopupMenuViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isOffline,  bool hidden,  bool showDownload,  bool showCancel,  bool showDelete,  bool showRetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TracksPopupMenuViewState() when $default != null:
return $default(_that.isOffline,_that.hidden,_that.showDownload,_that.showCancel,_that.showDelete,_that.showRetry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isOffline,  bool hidden,  bool showDownload,  bool showCancel,  bool showDelete,  bool showRetry)  $default,) {final _that = this;
switch (_that) {
case _TracksPopupMenuViewState():
return $default(_that.isOffline,_that.hidden,_that.showDownload,_that.showCancel,_that.showDelete,_that.showRetry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isOffline,  bool hidden,  bool showDownload,  bool showCancel,  bool showDelete,  bool showRetry)?  $default,) {final _that = this;
switch (_that) {
case _TracksPopupMenuViewState() when $default != null:
return $default(_that.isOffline,_that.hidden,_that.showDownload,_that.showCancel,_that.showDelete,_that.showRetry);case _:
  return null;

}
}

}

/// @nodoc


class _TracksPopupMenuViewState implements TracksPopupMenuViewState {
  const _TracksPopupMenuViewState({required this.isOffline, required this.hidden, required this.showDownload, required this.showCancel, required this.showDelete, required this.showRetry});
  

@override final  bool isOffline;
@override final  bool hidden;
@override final  bool showDownload;
@override final  bool showCancel;
@override final  bool showDelete;
@override final  bool showRetry;

/// Create a copy of TracksPopupMenuViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TracksPopupMenuViewStateCopyWith<_TracksPopupMenuViewState> get copyWith => __$TracksPopupMenuViewStateCopyWithImpl<_TracksPopupMenuViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TracksPopupMenuViewState&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.showDownload, showDownload) || other.showDownload == showDownload)&&(identical(other.showCancel, showCancel) || other.showCancel == showCancel)&&(identical(other.showDelete, showDelete) || other.showDelete == showDelete)&&(identical(other.showRetry, showRetry) || other.showRetry == showRetry));
}


@override
int get hashCode => Object.hash(runtimeType,isOffline,hidden,showDownload,showCancel,showDelete,showRetry);

@override
String toString() {
  return 'TracksPopupMenuViewState(isOffline: $isOffline, hidden: $hidden, showDownload: $showDownload, showCancel: $showCancel, showDelete: $showDelete, showRetry: $showRetry)';
}


}

/// @nodoc
abstract mixin class _$TracksPopupMenuViewStateCopyWith<$Res> implements $TracksPopupMenuViewStateCopyWith<$Res> {
  factory _$TracksPopupMenuViewStateCopyWith(_TracksPopupMenuViewState value, $Res Function(_TracksPopupMenuViewState) _then) = __$TracksPopupMenuViewStateCopyWithImpl;
@override @useResult
$Res call({
 bool isOffline, bool hidden, bool showDownload, bool showCancel, bool showDelete, bool showRetry
});




}
/// @nodoc
class __$TracksPopupMenuViewStateCopyWithImpl<$Res>
    implements _$TracksPopupMenuViewStateCopyWith<$Res> {
  __$TracksPopupMenuViewStateCopyWithImpl(this._self, this._then);

  final _TracksPopupMenuViewState _self;
  final $Res Function(_TracksPopupMenuViewState) _then;

/// Create a copy of TracksPopupMenuViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isOffline = null,Object? hidden = null,Object? showDownload = null,Object? showCancel = null,Object? showDelete = null,Object? showRetry = null,}) {
  return _then(_TracksPopupMenuViewState(
isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,showDownload: null == showDownload ? _self.showDownload : showDownload // ignore: cast_nullable_to_non_nullable
as bool,showCancel: null == showCancel ? _self.showCancel : showCancel // ignore: cast_nullable_to_non_nullable
as bool,showDelete: null == showDelete ? _self.showDelete : showDelete // ignore: cast_nullable_to_non_nullable
as bool,showRetry: null == showRetry ? _self.showRetry : showRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
