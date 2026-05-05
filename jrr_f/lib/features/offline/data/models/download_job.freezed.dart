// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'download_job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadJob {

 int get fileKey; Track get track; DownloadState get state; int get bytesDone; int get bytesTotal; DateTime get enqueuedAt; DateTime? get startedAt; String? get error;
/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadJobCopyWith<DownloadJob> get copyWith => _$DownloadJobCopyWithImpl<DownloadJob>(this as DownloadJob, _$identity);

  /// Serializes this DownloadJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadJob&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.track, track) || other.track == track)&&(identical(other.state, state) || other.state == state)&&(identical(other.bytesDone, bytesDone) || other.bytesDone == bytesDone)&&(identical(other.bytesTotal, bytesTotal) || other.bytesTotal == bytesTotal)&&(identical(other.enqueuedAt, enqueuedAt) || other.enqueuedAt == enqueuedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileKey,track,state,bytesDone,bytesTotal,enqueuedAt,startedAt,error);

@override
String toString() {
  return 'DownloadJob(fileKey: $fileKey, track: $track, state: $state, bytesDone: $bytesDone, bytesTotal: $bytesTotal, enqueuedAt: $enqueuedAt, startedAt: $startedAt, error: $error)';
}


}

/// @nodoc
abstract mixin class $DownloadJobCopyWith<$Res>  {
  factory $DownloadJobCopyWith(DownloadJob value, $Res Function(DownloadJob) _then) = _$DownloadJobCopyWithImpl;
@useResult
$Res call({
 int fileKey, Track track, DownloadState state, int bytesDone, int bytesTotal, DateTime enqueuedAt, DateTime? startedAt, String? error
});


$TrackCopyWith<$Res> get track;

}
/// @nodoc
class _$DownloadJobCopyWithImpl<$Res>
    implements $DownloadJobCopyWith<$Res> {
  _$DownloadJobCopyWithImpl(this._self, this._then);

  final DownloadJob _self;
  final $Res Function(DownloadJob) _then;

/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = null,Object? track = null,Object? state = null,Object? bytesDone = null,Object? bytesTotal = null,Object? enqueuedAt = null,Object? startedAt = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as DownloadState,bytesDone: null == bytesDone ? _self.bytesDone : bytesDone // ignore: cast_nullable_to_non_nullable
as int,bytesTotal: null == bytesTotal ? _self.bytesTotal : bytesTotal // ignore: cast_nullable_to_non_nullable
as int,enqueuedAt: null == enqueuedAt ? _self.enqueuedAt : enqueuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res> get track {
  
  return $TrackCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [DownloadJob].
extension DownloadJobPatterns on DownloadJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadJob value)  $default,){
final _that = this;
switch (_that) {
case _DownloadJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadJob value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fileKey,  Track track,  DownloadState state,  int bytesDone,  int bytesTotal,  DateTime enqueuedAt,  DateTime? startedAt,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadJob() when $default != null:
return $default(_that.fileKey,_that.track,_that.state,_that.bytesDone,_that.bytesTotal,_that.enqueuedAt,_that.startedAt,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fileKey,  Track track,  DownloadState state,  int bytesDone,  int bytesTotal,  DateTime enqueuedAt,  DateTime? startedAt,  String? error)  $default,) {final _that = this;
switch (_that) {
case _DownloadJob():
return $default(_that.fileKey,_that.track,_that.state,_that.bytesDone,_that.bytesTotal,_that.enqueuedAt,_that.startedAt,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fileKey,  Track track,  DownloadState state,  int bytesDone,  int bytesTotal,  DateTime enqueuedAt,  DateTime? startedAt,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _DownloadJob() when $default != null:
return $default(_that.fileKey,_that.track,_that.state,_that.bytesDone,_that.bytesTotal,_that.enqueuedAt,_that.startedAt,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadJob implements DownloadJob {
  const _DownloadJob({required this.fileKey, required this.track, required this.state, this.bytesDone = 0, this.bytesTotal = -1, required this.enqueuedAt, this.startedAt, this.error});
  factory _DownloadJob.fromJson(Map<String, dynamic> json) => _$DownloadJobFromJson(json);

@override final  int fileKey;
@override final  Track track;
@override final  DownloadState state;
@override@JsonKey() final  int bytesDone;
@override@JsonKey() final  int bytesTotal;
@override final  DateTime enqueuedAt;
@override final  DateTime? startedAt;
@override final  String? error;

/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadJobCopyWith<_DownloadJob> get copyWith => __$DownloadJobCopyWithImpl<_DownloadJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DownloadJob&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey)&&(identical(other.track, track) || other.track == track)&&(identical(other.state, state) || other.state == state)&&(identical(other.bytesDone, bytesDone) || other.bytesDone == bytesDone)&&(identical(other.bytesTotal, bytesTotal) || other.bytesTotal == bytesTotal)&&(identical(other.enqueuedAt, enqueuedAt) || other.enqueuedAt == enqueuedAt)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,fileKey,track,state,bytesDone,bytesTotal,enqueuedAt,startedAt,error);

@override
String toString() {
  return 'DownloadJob(fileKey: $fileKey, track: $track, state: $state, bytesDone: $bytesDone, bytesTotal: $bytesTotal, enqueuedAt: $enqueuedAt, startedAt: $startedAt, error: $error)';
}


}

/// @nodoc
abstract mixin class _$DownloadJobCopyWith<$Res> implements $DownloadJobCopyWith<$Res> {
  factory _$DownloadJobCopyWith(_DownloadJob value, $Res Function(_DownloadJob) _then) = __$DownloadJobCopyWithImpl;
@override @useResult
$Res call({
 int fileKey, Track track, DownloadState state, int bytesDone, int bytesTotal, DateTime enqueuedAt, DateTime? startedAt, String? error
});


@override $TrackCopyWith<$Res> get track;

}
/// @nodoc
class __$DownloadJobCopyWithImpl<$Res>
    implements _$DownloadJobCopyWith<$Res> {
  __$DownloadJobCopyWithImpl(this._self, this._then);

  final _DownloadJob _self;
  final $Res Function(_DownloadJob) _then;

/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = null,Object? track = null,Object? state = null,Object? bytesDone = null,Object? bytesTotal = null,Object? enqueuedAt = null,Object? startedAt = freezed,Object? error = freezed,}) {
  return _then(_DownloadJob(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as DownloadState,bytesDone: null == bytesDone ? _self.bytesDone : bytesDone // ignore: cast_nullable_to_non_nullable
as int,bytesTotal: null == bytesTotal ? _self.bytesTotal : bytesTotal // ignore: cast_nullable_to_non_nullable
as int,enqueuedAt: null == enqueuedAt ? _self.enqueuedAt : enqueuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DownloadJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res> get track {
  
  return $TrackCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}

// dart format on
