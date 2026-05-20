// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mini_player_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MiniPlayerViewState {

 int? get fileKey; String get name; String get artist; double get volume; bool get isMuted; bool get isPlaying; double get progress; bool get hasTracks;
/// Create a copy of MiniPlayerViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MiniPlayerViewStateCopyWith<MiniPlayerViewState> get copyWith => _$MiniPlayerViewStateCopyWithImpl<MiniPlayerViewState>(this as MiniPlayerViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MiniPlayerViewState&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.hasTracks, hasTracks) || other.hasTracks == hasTracks));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,volume,isMuted,isPlaying,progress,hasTracks);

@override
String toString() {
  return 'MiniPlayerViewState(fileKey: $fileKey, name: $name, artist: $artist, volume: $volume, isMuted: $isMuted, isPlaying: $isPlaying, progress: $progress, hasTracks: $hasTracks)';
}


}

/// @nodoc
abstract mixin class $MiniPlayerViewStateCopyWith<$Res>  {
  factory $MiniPlayerViewStateCopyWith(MiniPlayerViewState value, $Res Function(MiniPlayerViewState) _then) = _$MiniPlayerViewStateCopyWithImpl;
@useResult
$Res call({
 int? fileKey, String name, String artist, double volume, bool isMuted, bool isPlaying, double progress, bool hasTracks
});




}
/// @nodoc
class _$MiniPlayerViewStateCopyWithImpl<$Res>
    implements $MiniPlayerViewStateCopyWith<$Res> {
  _$MiniPlayerViewStateCopyWithImpl(this._self, this._then);

  final MiniPlayerViewState _self;
  final $Res Function(MiniPlayerViewState) _then;

/// Create a copy of MiniPlayerViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = freezed,Object? name = null,Object? artist = null,Object? volume = null,Object? isMuted = null,Object? isPlaying = null,Object? progress = null,Object? hasTracks = null,}) {
  return _then(_self.copyWith(
fileKey: freezed == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,hasTracks: null == hasTracks ? _self.hasTracks : hasTracks // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MiniPlayerViewState].
extension MiniPlayerViewStatePatterns on MiniPlayerViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MiniPlayerViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MiniPlayerViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MiniPlayerViewState value)  $default,){
final _that = this;
switch (_that) {
case _MiniPlayerViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MiniPlayerViewState value)?  $default,){
final _that = this;
switch (_that) {
case _MiniPlayerViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? fileKey,  String name,  String artist,  double volume,  bool isMuted,  bool isPlaying,  double progress,  bool hasTracks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MiniPlayerViewState() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.volume,_that.isMuted,_that.isPlaying,_that.progress,_that.hasTracks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? fileKey,  String name,  String artist,  double volume,  bool isMuted,  bool isPlaying,  double progress,  bool hasTracks)  $default,) {final _that = this;
switch (_that) {
case _MiniPlayerViewState():
return $default(_that.fileKey,_that.name,_that.artist,_that.volume,_that.isMuted,_that.isPlaying,_that.progress,_that.hasTracks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? fileKey,  String name,  String artist,  double volume,  bool isMuted,  bool isPlaying,  double progress,  bool hasTracks)?  $default,) {final _that = this;
switch (_that) {
case _MiniPlayerViewState() when $default != null:
return $default(_that.fileKey,_that.name,_that.artist,_that.volume,_that.isMuted,_that.isPlaying,_that.progress,_that.hasTracks);case _:
  return null;

}
}

}

/// @nodoc


class _MiniPlayerViewState implements MiniPlayerViewState {
  const _MiniPlayerViewState({required this.fileKey, required this.name, required this.artist, required this.volume, required this.isMuted, required this.isPlaying, required this.progress, required this.hasTracks});
  

@override final  int? fileKey;
@override final  String name;
@override final  String artist;
@override final  double volume;
@override final  bool isMuted;
@override final  bool isPlaying;
@override final  double progress;
@override final  bool hasTracks;

/// Create a copy of MiniPlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MiniPlayerViewStateCopyWith<_MiniPlayerViewState> get copyWith => __$MiniPlayerViewStateCopyWithImpl<_MiniPlayerViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MiniPlayerViewState&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.volume, volume) || other.volume == volume)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.hasTracks, hasTracks) || other.hasTracks == hasTracks));
}


@override
int get hashCode => Object.hash(runtimeType,fileKey,name,artist,volume,isMuted,isPlaying,progress,hasTracks);

@override
String toString() {
  return 'MiniPlayerViewState(fileKey: $fileKey, name: $name, artist: $artist, volume: $volume, isMuted: $isMuted, isPlaying: $isPlaying, progress: $progress, hasTracks: $hasTracks)';
}


}

/// @nodoc
abstract mixin class _$MiniPlayerViewStateCopyWith<$Res> implements $MiniPlayerViewStateCopyWith<$Res> {
  factory _$MiniPlayerViewStateCopyWith(_MiniPlayerViewState value, $Res Function(_MiniPlayerViewState) _then) = __$MiniPlayerViewStateCopyWithImpl;
@override @useResult
$Res call({
 int? fileKey, String name, String artist, double volume, bool isMuted, bool isPlaying, double progress, bool hasTracks
});




}
/// @nodoc
class __$MiniPlayerViewStateCopyWithImpl<$Res>
    implements _$MiniPlayerViewStateCopyWith<$Res> {
  __$MiniPlayerViewStateCopyWithImpl(this._self, this._then);

  final _MiniPlayerViewState _self;
  final $Res Function(_MiniPlayerViewState) _then;

/// Create a copy of MiniPlayerViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = freezed,Object? name = null,Object? artist = null,Object? volume = null,Object? isMuted = null,Object? isPlaying = null,Object? progress = null,Object? hasTracks = null,}) {
  return _then(_MiniPlayerViewState(
fileKey: freezed == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,volume: null == volume ? _self.volume : volume // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,hasTracks: null == hasTracks ? _self.hasTracks : hasTracks // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
