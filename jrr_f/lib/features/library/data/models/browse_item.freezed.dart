// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'browse_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BrowseItem {

 String get id; String get name;
/// Create a copy of BrowseItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrowseItemCopyWith<BrowseItem> get copyWith => _$BrowseItemCopyWithImpl<BrowseItem>(this as BrowseItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrowseItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'BrowseItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $BrowseItemCopyWith<$Res>  {
  factory $BrowseItemCopyWith(BrowseItem value, $Res Function(BrowseItem) _then) = _$BrowseItemCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$BrowseItemCopyWithImpl<$Res>
    implements $BrowseItemCopyWith<$Res> {
  _$BrowseItemCopyWithImpl(this._self, this._then);

  final BrowseItem _self;
  final $Res Function(BrowseItem) _then;

/// Create a copy of BrowseItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BrowseItem].
extension BrowseItemPatterns on BrowseItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrowseItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrowseItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrowseItem value)  $default,){
final _that = this;
switch (_that) {
case _BrowseItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrowseItem value)?  $default,){
final _that = this;
switch (_that) {
case _BrowseItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrowseItem() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _BrowseItem():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _BrowseItem() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _BrowseItem implements BrowseItem {
  const _BrowseItem({required this.id, required this.name});
  

@override final  String id;
@override final  String name;

/// Create a copy of BrowseItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrowseItemCopyWith<_BrowseItem> get copyWith => __$BrowseItemCopyWithImpl<_BrowseItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrowseItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'BrowseItem(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$BrowseItemCopyWith<$Res> implements $BrowseItemCopyWith<$Res> {
  factory _$BrowseItemCopyWith(_BrowseItem value, $Res Function(_BrowseItem) _then) = __$BrowseItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$BrowseItemCopyWithImpl<$Res>
    implements _$BrowseItemCopyWith<$Res> {
  __$BrowseItemCopyWithImpl(this._self, this._then);

  final _BrowseItem _self;
  final $Res Function(_BrowseItem) _then;

/// Create a copy of BrowseItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_BrowseItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
