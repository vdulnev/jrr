// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'server_setup_view_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ServerSetupPrefill {

 String get host; int get port; String get username; String? get password; bool get useSsl; int get sslPort;
/// Create a copy of ServerSetupPrefill
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerSetupPrefillCopyWith<ServerSetupPrefill> get copyWith => _$ServerSetupPrefillCopyWithImpl<ServerSetupPrefill>(this as ServerSetupPrefill, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerSetupPrefill&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.useSsl, useSsl) || other.useSsl == useSsl)&&(identical(other.sslPort, sslPort) || other.sslPort == sslPort));
}


@override
int get hashCode => Object.hash(runtimeType,host,port,username,password,useSsl,sslPort);

@override
String toString() {
  return 'ServerSetupPrefill(host: $host, port: $port, username: $username, password: $password, useSsl: $useSsl, sslPort: $sslPort)';
}


}

/// @nodoc
abstract mixin class $ServerSetupPrefillCopyWith<$Res>  {
  factory $ServerSetupPrefillCopyWith(ServerSetupPrefill value, $Res Function(ServerSetupPrefill) _then) = _$ServerSetupPrefillCopyWithImpl;
@useResult
$Res call({
 String host, int port, String username, String? password, bool useSsl, int sslPort
});




}
/// @nodoc
class _$ServerSetupPrefillCopyWithImpl<$Res>
    implements $ServerSetupPrefillCopyWith<$Res> {
  _$ServerSetupPrefillCopyWithImpl(this._self, this._then);

  final ServerSetupPrefill _self;
  final $Res Function(ServerSetupPrefill) _then;

/// Create a copy of ServerSetupPrefill
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? host = null,Object? port = null,Object? username = null,Object? password = freezed,Object? useSsl = null,Object? sslPort = null,}) {
  return _then(_self.copyWith(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,useSsl: null == useSsl ? _self.useSsl : useSsl // ignore: cast_nullable_to_non_nullable
as bool,sslPort: null == sslPort ? _self.sslPort : sslPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServerSetupPrefill].
extension ServerSetupPrefillPatterns on ServerSetupPrefill {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerSetupPrefill value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerSetupPrefill() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerSetupPrefill value)  $default,){
final _that = this;
switch (_that) {
case _ServerSetupPrefill():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerSetupPrefill value)?  $default,){
final _that = this;
switch (_that) {
case _ServerSetupPrefill() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String host,  int port,  String username,  String? password,  bool useSsl,  int sslPort)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerSetupPrefill() when $default != null:
return $default(_that.host,_that.port,_that.username,_that.password,_that.useSsl,_that.sslPort);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String host,  int port,  String username,  String? password,  bool useSsl,  int sslPort)  $default,) {final _that = this;
switch (_that) {
case _ServerSetupPrefill():
return $default(_that.host,_that.port,_that.username,_that.password,_that.useSsl,_that.sslPort);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String host,  int port,  String username,  String? password,  bool useSsl,  int sslPort)?  $default,) {final _that = this;
switch (_that) {
case _ServerSetupPrefill() when $default != null:
return $default(_that.host,_that.port,_that.username,_that.password,_that.useSsl,_that.sslPort);case _:
  return null;

}
}

}

/// @nodoc


class _ServerSetupPrefill implements ServerSetupPrefill {
  const _ServerSetupPrefill({required this.host, required this.port, required this.username, required this.password, required this.useSsl, required this.sslPort});
  

@override final  String host;
@override final  int port;
@override final  String username;
@override final  String? password;
@override final  bool useSsl;
@override final  int sslPort;

/// Create a copy of ServerSetupPrefill
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerSetupPrefillCopyWith<_ServerSetupPrefill> get copyWith => __$ServerSetupPrefillCopyWithImpl<_ServerSetupPrefill>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerSetupPrefill&&(identical(other.host, host) || other.host == host)&&(identical(other.port, port) || other.port == port)&&(identical(other.username, username) || other.username == username)&&(identical(other.password, password) || other.password == password)&&(identical(other.useSsl, useSsl) || other.useSsl == useSsl)&&(identical(other.sslPort, sslPort) || other.sslPort == sslPort));
}


@override
int get hashCode => Object.hash(runtimeType,host,port,username,password,useSsl,sslPort);

@override
String toString() {
  return 'ServerSetupPrefill(host: $host, port: $port, username: $username, password: $password, useSsl: $useSsl, sslPort: $sslPort)';
}


}

/// @nodoc
abstract mixin class _$ServerSetupPrefillCopyWith<$Res> implements $ServerSetupPrefillCopyWith<$Res> {
  factory _$ServerSetupPrefillCopyWith(_ServerSetupPrefill value, $Res Function(_ServerSetupPrefill) _then) = __$ServerSetupPrefillCopyWithImpl;
@override @useResult
$Res call({
 String host, int port, String username, String? password, bool useSsl, int sslPort
});




}
/// @nodoc
class __$ServerSetupPrefillCopyWithImpl<$Res>
    implements _$ServerSetupPrefillCopyWith<$Res> {
  __$ServerSetupPrefillCopyWithImpl(this._self, this._then);

  final _ServerSetupPrefill _self;
  final $Res Function(_ServerSetupPrefill) _then;

/// Create a copy of ServerSetupPrefill
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? host = null,Object? port = null,Object? username = null,Object? password = freezed,Object? useSsl = null,Object? sslPort = null,}) {
  return _then(_ServerSetupPrefill(
host: null == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,password: freezed == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String?,useSsl: null == useSsl ? _self.useSsl : useSsl // ignore: cast_nullable_to_non_nullable
as bool,sslPort: null == sslPort ? _self.sslPort : sslPort // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ServerSetupViewState {

 bool get isConnecting; Object? get connectError; ServerSetupPrefill? get prefill;
/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerSetupViewStateCopyWith<ServerSetupViewState> get copyWith => _$ServerSetupViewStateCopyWithImpl<ServerSetupViewState>(this as ServerSetupViewState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerSetupViewState&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&const DeepCollectionEquality().equals(other.connectError, connectError)&&(identical(other.prefill, prefill) || other.prefill == prefill));
}


@override
int get hashCode => Object.hash(runtimeType,isConnecting,const DeepCollectionEquality().hash(connectError),prefill);

@override
String toString() {
  return 'ServerSetupViewState(isConnecting: $isConnecting, connectError: $connectError, prefill: $prefill)';
}


}

/// @nodoc
abstract mixin class $ServerSetupViewStateCopyWith<$Res>  {
  factory $ServerSetupViewStateCopyWith(ServerSetupViewState value, $Res Function(ServerSetupViewState) _then) = _$ServerSetupViewStateCopyWithImpl;
@useResult
$Res call({
 bool isConnecting, Object? connectError, ServerSetupPrefill? prefill
});


$ServerSetupPrefillCopyWith<$Res>? get prefill;

}
/// @nodoc
class _$ServerSetupViewStateCopyWithImpl<$Res>
    implements $ServerSetupViewStateCopyWith<$Res> {
  _$ServerSetupViewStateCopyWithImpl(this._self, this._then);

  final ServerSetupViewState _self;
  final $Res Function(ServerSetupViewState) _then;

/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isConnecting = null,Object? connectError = freezed,Object? prefill = freezed,}) {
  return _then(_self.copyWith(
isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,connectError: freezed == connectError ? _self.connectError : connectError ,prefill: freezed == prefill ? _self.prefill : prefill // ignore: cast_nullable_to_non_nullable
as ServerSetupPrefill?,
  ));
}
/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSetupPrefillCopyWith<$Res>? get prefill {
    if (_self.prefill == null) {
    return null;
  }

  return $ServerSetupPrefillCopyWith<$Res>(_self.prefill!, (value) {
    return _then(_self.copyWith(prefill: value));
  });
}
}


/// Adds pattern-matching-related methods to [ServerSetupViewState].
extension ServerSetupViewStatePatterns on ServerSetupViewState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServerSetupViewState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServerSetupViewState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServerSetupViewState value)  $default,){
final _that = this;
switch (_that) {
case _ServerSetupViewState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServerSetupViewState value)?  $default,){
final _that = this;
switch (_that) {
case _ServerSetupViewState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isConnecting,  Object? connectError,  ServerSetupPrefill? prefill)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServerSetupViewState() when $default != null:
return $default(_that.isConnecting,_that.connectError,_that.prefill);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isConnecting,  Object? connectError,  ServerSetupPrefill? prefill)  $default,) {final _that = this;
switch (_that) {
case _ServerSetupViewState():
return $default(_that.isConnecting,_that.connectError,_that.prefill);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isConnecting,  Object? connectError,  ServerSetupPrefill? prefill)?  $default,) {final _that = this;
switch (_that) {
case _ServerSetupViewState() when $default != null:
return $default(_that.isConnecting,_that.connectError,_that.prefill);case _:
  return null;

}
}

}

/// @nodoc


class _ServerSetupViewState extends ServerSetupViewState {
  const _ServerSetupViewState({required this.isConnecting, required this.connectError, required this.prefill}): super._();
  

@override final  bool isConnecting;
@override final  Object? connectError;
@override final  ServerSetupPrefill? prefill;

/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServerSetupViewStateCopyWith<_ServerSetupViewState> get copyWith => __$ServerSetupViewStateCopyWithImpl<_ServerSetupViewState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServerSetupViewState&&(identical(other.isConnecting, isConnecting) || other.isConnecting == isConnecting)&&const DeepCollectionEquality().equals(other.connectError, connectError)&&(identical(other.prefill, prefill) || other.prefill == prefill));
}


@override
int get hashCode => Object.hash(runtimeType,isConnecting,const DeepCollectionEquality().hash(connectError),prefill);

@override
String toString() {
  return 'ServerSetupViewState(isConnecting: $isConnecting, connectError: $connectError, prefill: $prefill)';
}


}

/// @nodoc
abstract mixin class _$ServerSetupViewStateCopyWith<$Res> implements $ServerSetupViewStateCopyWith<$Res> {
  factory _$ServerSetupViewStateCopyWith(_ServerSetupViewState value, $Res Function(_ServerSetupViewState) _then) = __$ServerSetupViewStateCopyWithImpl;
@override @useResult
$Res call({
 bool isConnecting, Object? connectError, ServerSetupPrefill? prefill
});


@override $ServerSetupPrefillCopyWith<$Res>? get prefill;

}
/// @nodoc
class __$ServerSetupViewStateCopyWithImpl<$Res>
    implements _$ServerSetupViewStateCopyWith<$Res> {
  __$ServerSetupViewStateCopyWithImpl(this._self, this._then);

  final _ServerSetupViewState _self;
  final $Res Function(_ServerSetupViewState) _then;

/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isConnecting = null,Object? connectError = freezed,Object? prefill = freezed,}) {
  return _then(_ServerSetupViewState(
isConnecting: null == isConnecting ? _self.isConnecting : isConnecting // ignore: cast_nullable_to_non_nullable
as bool,connectError: freezed == connectError ? _self.connectError : connectError ,prefill: freezed == prefill ? _self.prefill : prefill // ignore: cast_nullable_to_non_nullable
as ServerSetupPrefill?,
  ));
}

/// Create a copy of ServerSetupViewState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ServerSetupPrefillCopyWith<$Res>? get prefill {
    if (_self.prefill == null) {
    return null;
  }

  return $ServerSetupPrefillCopyWith<$Res>(_self.prefill!, (value) {
    return _then(_self.copyWith(prefill: value));
  });
}
}

// dart format on
