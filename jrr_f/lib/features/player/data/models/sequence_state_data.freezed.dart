// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sequence_state_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SequenceStateData {

 Tracks get sequence; int get currentIndex; List<int> get shuffleIndices; bool get shuffleModeEnabled; LoopMode get loopMode;
/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SequenceStateDataCopyWith<SequenceStateData> get copyWith => _$SequenceStateDataCopyWithImpl<SequenceStateData>(this as SequenceStateData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SequenceStateData&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other.shuffleIndices, shuffleIndices)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode));
}


@override
int get hashCode => Object.hash(runtimeType,sequence,currentIndex,const DeepCollectionEquality().hash(shuffleIndices),shuffleModeEnabled,loopMode);

@override
String toString() {
  return 'SequenceStateData(sequence: $sequence, currentIndex: $currentIndex, shuffleIndices: $shuffleIndices, shuffleModeEnabled: $shuffleModeEnabled, loopMode: $loopMode)';
}


}

/// @nodoc
abstract mixin class $SequenceStateDataCopyWith<$Res>  {
  factory $SequenceStateDataCopyWith(SequenceStateData value, $Res Function(SequenceStateData) _then) = _$SequenceStateDataCopyWithImpl;
@useResult
$Res call({
 Tracks sequence, int currentIndex, List<int> shuffleIndices, bool shuffleModeEnabled, LoopMode loopMode
});


$TracksCopyWith<$Res> get sequence;

}
/// @nodoc
class _$SequenceStateDataCopyWithImpl<$Res>
    implements $SequenceStateDataCopyWith<$Res> {
  _$SequenceStateDataCopyWithImpl(this._self, this._then);

  final SequenceStateData _self;
  final $Res Function(SequenceStateData) _then;

/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sequence = null,Object? currentIndex = null,Object? shuffleIndices = null,Object? shuffleModeEnabled = null,Object? loopMode = null,}) {
  return _then(_self.copyWith(
sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as Tracks,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,shuffleIndices: null == shuffleIndices ? _self.shuffleIndices : shuffleIndices // ignore: cast_nullable_to_non_nullable
as List<int>,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as LoopMode,
  ));
}
/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TracksCopyWith<$Res> get sequence {
  
  return $TracksCopyWith<$Res>(_self.sequence, (value) {
    return _then(_self.copyWith(sequence: value));
  });
}
}


/// Adds pattern-matching-related methods to [SequenceStateData].
extension SequenceStateDataPatterns on SequenceStateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SequenceStateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SequenceStateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SequenceStateData value)  $default,){
final _that = this;
switch (_that) {
case _SequenceStateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SequenceStateData value)?  $default,){
final _that = this;
switch (_that) {
case _SequenceStateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Tracks sequence,  int currentIndex,  List<int> shuffleIndices,  bool shuffleModeEnabled,  LoopMode loopMode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SequenceStateData() when $default != null:
return $default(_that.sequence,_that.currentIndex,_that.shuffleIndices,_that.shuffleModeEnabled,_that.loopMode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Tracks sequence,  int currentIndex,  List<int> shuffleIndices,  bool shuffleModeEnabled,  LoopMode loopMode)  $default,) {final _that = this;
switch (_that) {
case _SequenceStateData():
return $default(_that.sequence,_that.currentIndex,_that.shuffleIndices,_that.shuffleModeEnabled,_that.loopMode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Tracks sequence,  int currentIndex,  List<int> shuffleIndices,  bool shuffleModeEnabled,  LoopMode loopMode)?  $default,) {final _that = this;
switch (_that) {
case _SequenceStateData() when $default != null:
return $default(_that.sequence,_that.currentIndex,_that.shuffleIndices,_that.shuffleModeEnabled,_that.loopMode);case _:
  return null;

}
}

}

/// @nodoc


class _SequenceStateData extends SequenceStateData {
  const _SequenceStateData({required this.sequence, required this.currentIndex, required final  List<int> shuffleIndices, required this.shuffleModeEnabled, required this.loopMode}): _shuffleIndices = shuffleIndices,super._();
  

@override final  Tracks sequence;
@override final  int currentIndex;
 final  List<int> _shuffleIndices;
@override List<int> get shuffleIndices {
  if (_shuffleIndices is EqualUnmodifiableListView) return _shuffleIndices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shuffleIndices);
}

@override final  bool shuffleModeEnabled;
@override final  LoopMode loopMode;

/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SequenceStateDataCopyWith<_SequenceStateData> get copyWith => __$SequenceStateDataCopyWithImpl<_SequenceStateData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SequenceStateData&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.currentIndex, currentIndex) || other.currentIndex == currentIndex)&&const DeepCollectionEquality().equals(other._shuffleIndices, _shuffleIndices)&&(identical(other.shuffleModeEnabled, shuffleModeEnabled) || other.shuffleModeEnabled == shuffleModeEnabled)&&(identical(other.loopMode, loopMode) || other.loopMode == loopMode));
}


@override
int get hashCode => Object.hash(runtimeType,sequence,currentIndex,const DeepCollectionEquality().hash(_shuffleIndices),shuffleModeEnabled,loopMode);

@override
String toString() {
  return 'SequenceStateData(sequence: $sequence, currentIndex: $currentIndex, shuffleIndices: $shuffleIndices, shuffleModeEnabled: $shuffleModeEnabled, loopMode: $loopMode)';
}


}

/// @nodoc
abstract mixin class _$SequenceStateDataCopyWith<$Res> implements $SequenceStateDataCopyWith<$Res> {
  factory _$SequenceStateDataCopyWith(_SequenceStateData value, $Res Function(_SequenceStateData) _then) = __$SequenceStateDataCopyWithImpl;
@override @useResult
$Res call({
 Tracks sequence, int currentIndex, List<int> shuffleIndices, bool shuffleModeEnabled, LoopMode loopMode
});


@override $TracksCopyWith<$Res> get sequence;

}
/// @nodoc
class __$SequenceStateDataCopyWithImpl<$Res>
    implements _$SequenceStateDataCopyWith<$Res> {
  __$SequenceStateDataCopyWithImpl(this._self, this._then);

  final _SequenceStateData _self;
  final $Res Function(_SequenceStateData) _then;

/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sequence = null,Object? currentIndex = null,Object? shuffleIndices = null,Object? shuffleModeEnabled = null,Object? loopMode = null,}) {
  return _then(_SequenceStateData(
sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as Tracks,currentIndex: null == currentIndex ? _self.currentIndex : currentIndex // ignore: cast_nullable_to_non_nullable
as int,shuffleIndices: null == shuffleIndices ? _self._shuffleIndices : shuffleIndices // ignore: cast_nullable_to_non_nullable
as List<int>,shuffleModeEnabled: null == shuffleModeEnabled ? _self.shuffleModeEnabled : shuffleModeEnabled // ignore: cast_nullable_to_non_nullable
as bool,loopMode: null == loopMode ? _self.loopMode : loopMode // ignore: cast_nullable_to_non_nullable
as LoopMode,
  ));
}

/// Create a copy of SequenceStateData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TracksCopyWith<$Res> get sequence {
  
  return $TracksCopyWith<$Res>(_self.sequence, (value) {
    return _then(_self.copyWith(sequence: value));
  });
}
}

// dart format on
