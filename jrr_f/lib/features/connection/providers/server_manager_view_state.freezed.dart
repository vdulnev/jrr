// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_manager_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerManagerViewState {

 ServerInfo? get serverInfo; int get downloadedTracksCount; int get downloadedTotalBytes; List<DownloadJob> get failedJobs;
/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerManagerViewStateCopyWith<ServerManagerViewState> get copyWith => _$ServerManagerViewStateCopyWithImpl<ServerManagerViewState>(this as ServerManagerViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerManagerViewState&&(identical(other.serverInfo, serverInfo) || other.serverInfo == serverInfo)&&(identical(other.downloadedTracksCount, downloadedTracksCount) || other.downloadedTracksCount == downloadedTracksCount)&&(identical(other.downloadedTotalBytes, downloadedTotalBytes) || other.downloadedTotalBytes == downloadedTotalBytes)&&const DeepCollectionEquality().equals(other.failedJobs, failedJobs));
}


@override
int get hashCode => Object.hash(runtimeType,serverInfo,downloadedTracksCount,downloadedTotalBytes,const DeepCollectionEquality().hash(failedJobs));

@override
String toString() {
  return 'ServerManagerViewState(serverInfo: $serverInfo, downloadedTracksCount: $downloadedTracksCount, downloadedTotalBytes: $downloadedTotalBytes, failedJobs: $failedJobs)';
}


}

/// @nodoc
abstract mixin class $ServerManagerViewStateCopyWith<$Res>  {
  factory $ServerManagerViewStateCopyWith(ServerManagerViewState value, $Res Function(ServerManagerViewState) _then) = _$ServerManagerViewStateCopyWithImpl;
@useResult
$Res call({
 ServerInfo? serverInfo, int downloadedTracksCount, int downloadedTotalBytes, List<DownloadJob> failedJobs
});


$ServerInfoCopyWith<$Res>? get serverInfo;

}
/// @nodoc
class _$ServerManagerViewStateCopyWithImpl<$Res>
    implements $ServerManagerViewStateCopyWith<$Res> {
  _$ServerManagerViewStateCopyWithImpl(this._self, this._then);

  final ServerManagerViewState _self;
  final $Res Function(ServerManagerViewState) _then;

/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverInfo = freezed,Object? downloadedTracksCount = null,Object? downloadedTotalBytes = null,Object? failedJobs = null,}) {
  return _then(_self.copyWith(
serverInfo: freezed == serverInfo ? _self.serverInfo : serverInfo // ignore: cast_nullable_to_non_nullable
as ServerInfo?,downloadedTracksCount: null == downloadedTracksCount ? _self.downloadedTracksCount : downloadedTracksCount // ignore: cast_nullable_to_non_nullable
as int,downloadedTotalBytes: null == downloadedTotalBytes ? _self.downloadedTotalBytes : downloadedTotalBytes // ignore: cast_nullable_to_non_nullable
as int,failedJobs: null == failedJobs ? _self.failedJobs : failedJobs // ignore: cast_nullable_to_non_nullable
as List<DownloadJob>,
  ));
}
/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerInfoCopyWith<$Res>? get serverInfo {
    if (_self.serverInfo == null) {
    return null;
  }

  return $ServerInfoCopyWith<$Res>(_self.serverInfo!, (value) {
    return _then(_self.copyWith(serverInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerManagerViewState].
extension ServerManagerViewStatePatterns on ServerManagerViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerManagerViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerManagerViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerManagerViewState value)  $default,){
final _that = this;
switch (_that) {
case _ServerManagerViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerManagerViewState value)?  $default,){
final _that = this;
switch (_that) {
case _ServerManagerViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ServerInfo? serverInfo,  int downloadedTracksCount,  int downloadedTotalBytes,  List<DownloadJob> failedJobs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerManagerViewState() when $default != null:
return $default(_that.serverInfo,_that.downloadedTracksCount,_that.downloadedTotalBytes,_that.failedJobs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ServerInfo? serverInfo,  int downloadedTracksCount,  int downloadedTotalBytes,  List<DownloadJob> failedJobs)  $default,) {final _that = this;
switch (_that) {
case _ServerManagerViewState():
return $default(_that.serverInfo,_that.downloadedTracksCount,_that.downloadedTotalBytes,_that.failedJobs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ServerInfo? serverInfo,  int downloadedTracksCount,  int downloadedTotalBytes,  List<DownloadJob> failedJobs)?  $default,) {final _that = this;
switch (_that) {
case _ServerManagerViewState() when $default != null:
return $default(_that.serverInfo,_that.downloadedTracksCount,_that.downloadedTotalBytes,_that.failedJobs);case _:
  return null;

}
}

}

/// @nodoc


class _ServerManagerViewState extends ServerManagerViewState {
  const _ServerManagerViewState({required this.serverInfo, required this.downloadedTracksCount, required this.downloadedTotalBytes, required final  List<DownloadJob> failedJobs}): _failedJobs = failedJobs,super._();
  

@override final  ServerInfo? serverInfo;
@override final  int downloadedTracksCount;
@override final  int downloadedTotalBytes;
 final  List<DownloadJob> _failedJobs;
@override List<DownloadJob> get failedJobs {
  if (_failedJobs is EqualUnmodifiableListView) return _failedJobs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedJobs);
}


/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerManagerViewStateCopyWith<_ServerManagerViewState> get copyWith => __$ServerManagerViewStateCopyWithImpl<_ServerManagerViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerManagerViewState&&(identical(other.serverInfo, serverInfo) || other.serverInfo == serverInfo)&&(identical(other.downloadedTracksCount, downloadedTracksCount) || other.downloadedTracksCount == downloadedTracksCount)&&(identical(other.downloadedTotalBytes, downloadedTotalBytes) || other.downloadedTotalBytes == downloadedTotalBytes)&&const DeepCollectionEquality().equals(other._failedJobs, _failedJobs));
}


@override
int get hashCode => Object.hash(runtimeType,serverInfo,downloadedTracksCount,downloadedTotalBytes,const DeepCollectionEquality().hash(_failedJobs));

@override
String toString() {
  return 'ServerManagerViewState(serverInfo: $serverInfo, downloadedTracksCount: $downloadedTracksCount, downloadedTotalBytes: $downloadedTotalBytes, failedJobs: $failedJobs)';
}


}

/// @nodoc
abstract mixin class _$ServerManagerViewStateCopyWith<$Res> implements $ServerManagerViewStateCopyWith<$Res> {
  factory _$ServerManagerViewStateCopyWith(_ServerManagerViewState value, $Res Function(_ServerManagerViewState) _then) = __$ServerManagerViewStateCopyWithImpl;
@override @useResult
$Res call({
 ServerInfo? serverInfo, int downloadedTracksCount, int downloadedTotalBytes, List<DownloadJob> failedJobs
});


@override $ServerInfoCopyWith<$Res>? get serverInfo;

}
/// @nodoc
class __$ServerManagerViewStateCopyWithImpl<$Res>
    implements _$ServerManagerViewStateCopyWith<$Res> {
  __$ServerManagerViewStateCopyWithImpl(this._self, this._then);

  final _ServerManagerViewState _self;
  final $Res Function(_ServerManagerViewState) _then;

/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverInfo = freezed,Object? downloadedTracksCount = null,Object? downloadedTotalBytes = null,Object? failedJobs = null,}) {
  return _then(_ServerManagerViewState(
serverInfo: freezed == serverInfo ? _self.serverInfo : serverInfo // ignore: cast_nullable_to_non_nullable
as ServerInfo?,downloadedTracksCount: null == downloadedTracksCount ? _self.downloadedTracksCount : downloadedTracksCount // ignore: cast_nullable_to_non_nullable
as int,downloadedTotalBytes: null == downloadedTotalBytes ? _self.downloadedTotalBytes : downloadedTotalBytes // ignore: cast_nullable_to_non_nullable
as int,failedJobs: null == failedJobs ? _self._failedJobs : failedJobs // ignore: cast_nullable_to_non_nullable
as List<DownloadJob>,
  ));
}

/// Create a copy of ServerManagerViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerInfoCopyWith<$Res>? get serverInfo {
    if (_self.serverInfo == null) {
    return null;
  }

  return $ServerInfoCopyWith<$Res>(_self.serverInfo!, (value) {
    return _then(_self.copyWith(serverInfo: value));
  });
}
}

// dart format on
