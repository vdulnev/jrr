// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_exception.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppException {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppException()';
}


}

/// @nodoc
class $AppExceptionCopyWith<$Res>  {
$AppExceptionCopyWith(AppException _, $Res Function(AppException) __);
}


/// Adds pattern-matching-related methods to [AppException].
extension AppExceptionPatterns on AppException {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ConnectionRefusedException value)?  connectionRefused,TResult Function( UnauthorizedException value)?  unauthorized,TResult Function( ServerFailureException value)?  serverFailure,TResult Function( ParseErrorException value)?  parseError,TResult Function( AppTimeoutException value)?  timeout,TResult Function( UnknownException value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ConnectionRefusedException() when connectionRefused != null:
return connectionRefused(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case ServerFailureException() when serverFailure != null:
return serverFailure(_that);case ParseErrorException() when parseError != null:
return parseError(_that);case AppTimeoutException() when timeout != null:
return timeout(_that);case UnknownException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ConnectionRefusedException value)  connectionRefused,required TResult Function( UnauthorizedException value)  unauthorized,required TResult Function( ServerFailureException value)  serverFailure,required TResult Function( ParseErrorException value)  parseError,required TResult Function( AppTimeoutException value)  timeout,required TResult Function( UnknownException value)  unknown,}){
final _that = this;
switch (_that) {
case ConnectionRefusedException():
return connectionRefused(_that);case UnauthorizedException():
return unauthorized(_that);case ServerFailureException():
return serverFailure(_that);case ParseErrorException():
return parseError(_that);case AppTimeoutException():
return timeout(_that);case UnknownException():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ConnectionRefusedException value)?  connectionRefused,TResult? Function( UnauthorizedException value)?  unauthorized,TResult? Function( ServerFailureException value)?  serverFailure,TResult? Function( ParseErrorException value)?  parseError,TResult? Function( AppTimeoutException value)?  timeout,TResult? Function( UnknownException value)?  unknown,}){
final _that = this;
switch (_that) {
case ConnectionRefusedException() when connectionRefused != null:
return connectionRefused(_that);case UnauthorizedException() when unauthorized != null:
return unauthorized(_that);case ServerFailureException() when serverFailure != null:
return serverFailure(_that);case ParseErrorException() when parseError != null:
return parseError(_that);case AppTimeoutException() when timeout != null:
return timeout(_that);case UnknownException() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String address)?  connectionRefused,TResult Function()?  unauthorized,TResult Function( String message)?  serverFailure,TResult Function( String details)?  parseError,TResult Function( String address)?  timeout,TResult Function( Object error)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ConnectionRefusedException() when connectionRefused != null:
return connectionRefused(_that.address);case UnauthorizedException() when unauthorized != null:
return unauthorized();case ServerFailureException() when serverFailure != null:
return serverFailure(_that.message);case ParseErrorException() when parseError != null:
return parseError(_that.details);case AppTimeoutException() when timeout != null:
return timeout(_that.address);case UnknownException() when unknown != null:
return unknown(_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String address)  connectionRefused,required TResult Function()  unauthorized,required TResult Function( String message)  serverFailure,required TResult Function( String details)  parseError,required TResult Function( String address)  timeout,required TResult Function( Object error)  unknown,}) {final _that = this;
switch (_that) {
case ConnectionRefusedException():
return connectionRefused(_that.address);case UnauthorizedException():
return unauthorized();case ServerFailureException():
return serverFailure(_that.message);case ParseErrorException():
return parseError(_that.details);case AppTimeoutException():
return timeout(_that.address);case UnknownException():
return unknown(_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String address)?  connectionRefused,TResult? Function()?  unauthorized,TResult? Function( String message)?  serverFailure,TResult? Function( String details)?  parseError,TResult? Function( String address)?  timeout,TResult? Function( Object error)?  unknown,}) {final _that = this;
switch (_that) {
case ConnectionRefusedException() when connectionRefused != null:
return connectionRefused(_that.address);case UnauthorizedException() when unauthorized != null:
return unauthorized();case ServerFailureException() when serverFailure != null:
return serverFailure(_that.message);case ParseErrorException() when parseError != null:
return parseError(_that.details);case AppTimeoutException() when timeout != null:
return timeout(_that.address);case UnknownException() when unknown != null:
return unknown(_that.error);case _:
  return null;

}
}

}

/// @nodoc


class ConnectionRefusedException implements AppException {
  const ConnectionRefusedException({required this.address});
  

 final  String address;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectionRefusedExceptionCopyWith<ConnectionRefusedException> get copyWith => _$ConnectionRefusedExceptionCopyWithImpl<ConnectionRefusedException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectionRefusedException&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AppException.connectionRefused(address: $address)';
}


}

/// @nodoc
abstract mixin class $ConnectionRefusedExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $ConnectionRefusedExceptionCopyWith(ConnectionRefusedException value, $Res Function(ConnectionRefusedException) _then) = _$ConnectionRefusedExceptionCopyWithImpl;
@useResult
$Res call({
 String address
});




}
/// @nodoc
class _$ConnectionRefusedExceptionCopyWithImpl<$Res>
    implements $ConnectionRefusedExceptionCopyWith<$Res> {
  _$ConnectionRefusedExceptionCopyWithImpl(this._self, this._then);

  final ConnectionRefusedException _self;
  final $Res Function(ConnectionRefusedException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(ConnectionRefusedException(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnauthorizedException implements AppException {
  const UnauthorizedException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppException.unauthorized()';
}


}




/// @nodoc


class ServerFailureException implements AppException {
  const ServerFailureException({required this.message});
  

 final  String message;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureExceptionCopyWith<ServerFailureException> get copyWith => _$ServerFailureExceptionCopyWithImpl<ServerFailureException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailureException&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppException.serverFailure(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerFailureExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $ServerFailureExceptionCopyWith(ServerFailureException value, $Res Function(ServerFailureException) _then) = _$ServerFailureExceptionCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ServerFailureExceptionCopyWithImpl<$Res>
    implements $ServerFailureExceptionCopyWith<$Res> {
  _$ServerFailureExceptionCopyWithImpl(this._self, this._then);

  final ServerFailureException _self;
  final $Res Function(ServerFailureException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ServerFailureException(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ParseErrorException implements AppException {
  const ParseErrorException({required this.details});
  

 final  String details;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParseErrorExceptionCopyWith<ParseErrorException> get copyWith => _$ParseErrorExceptionCopyWithImpl<ParseErrorException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParseErrorException&&(identical(other.details, details) || other.details == details));
}


@override
int get hashCode => Object.hash(runtimeType,details);

@override
String toString() {
  return 'AppException.parseError(details: $details)';
}


}

/// @nodoc
abstract mixin class $ParseErrorExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $ParseErrorExceptionCopyWith(ParseErrorException value, $Res Function(ParseErrorException) _then) = _$ParseErrorExceptionCopyWithImpl;
@useResult
$Res call({
 String details
});




}
/// @nodoc
class _$ParseErrorExceptionCopyWithImpl<$Res>
    implements $ParseErrorExceptionCopyWith<$Res> {
  _$ParseErrorExceptionCopyWithImpl(this._self, this._then);

  final ParseErrorException _self;
  final $Res Function(ParseErrorException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? details = null,}) {
  return _then(ParseErrorException(
details: null == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class AppTimeoutException implements AppException {
  const AppTimeoutException({required this.address});
  

 final  String address;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTimeoutExceptionCopyWith<AppTimeoutException> get copyWith => _$AppTimeoutExceptionCopyWithImpl<AppTimeoutException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTimeoutException&&(identical(other.address, address) || other.address == address));
}


@override
int get hashCode => Object.hash(runtimeType,address);

@override
String toString() {
  return 'AppException.timeout(address: $address)';
}


}

/// @nodoc
abstract mixin class $AppTimeoutExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $AppTimeoutExceptionCopyWith(AppTimeoutException value, $Res Function(AppTimeoutException) _then) = _$AppTimeoutExceptionCopyWithImpl;
@useResult
$Res call({
 String address
});




}
/// @nodoc
class _$AppTimeoutExceptionCopyWithImpl<$Res>
    implements $AppTimeoutExceptionCopyWith<$Res> {
  _$AppTimeoutExceptionCopyWithImpl(this._self, this._then);

  final AppTimeoutException _self;
  final $Res Function(AppTimeoutException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? address = null,}) {
  return _then(AppTimeoutException(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnknownException implements AppException {
  const UnknownException({required this.error});
  

 final  Object error;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownExceptionCopyWith<UnknownException> get copyWith => _$UnknownExceptionCopyWithImpl<UnknownException>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownException&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'AppException.unknown(error: $error)';
}


}

/// @nodoc
abstract mixin class $UnknownExceptionCopyWith<$Res> implements $AppExceptionCopyWith<$Res> {
  factory $UnknownExceptionCopyWith(UnknownException value, $Res Function(UnknownException) _then) = _$UnknownExceptionCopyWithImpl;
@useResult
$Res call({
 Object error
});




}
/// @nodoc
class _$UnknownExceptionCopyWithImpl<$Res>
    implements $UnknownExceptionCopyWith<$Res> {
  _$UnknownExceptionCopyWithImpl(this._self, this._then);

  final UnknownException _self;
  final $Res Function(UnknownException) _then;

/// Create a copy of AppException
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(UnknownException(
error: null == error ? _self.error : error ,
  ));
}


}

// dart format on
