// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloaded_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DownloadedTrack {

 int get fileKey; Track get track; String get localPath; String? get artworkPath; String get albumGroupId; String get albumArtist; String get album; String get dateReadable; int get discNumber; int get totalDiscs; int get trackNumber; int get fileSizeBytes; DateTime get downloadedAt;
/// Create a copy of DownloadedTrack
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadedTrackCopyWith<DownloadedTrack> get copyWith => _$DownloadedTrackCopyWithImpl<DownloadedTrack>(this as DownloadedTrack, _$identity);

  /// Serializes this DownloadedTrack to a JSON map.
  Map<String, dynamic> toJson();




@override
String toString() {
  return 'DownloadedTrack(fileKey: $fileKey, track: $track, localPath: $localPath, artworkPath: $artworkPath, albumGroupId: $albumGroupId, albumArtist: $albumArtist, album: $album, dateReadable: $dateReadable, discNumber: $discNumber, totalDiscs: $totalDiscs, trackNumber: $trackNumber, fileSizeBytes: $fileSizeBytes, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class $DownloadedTrackCopyWith<$Res>  {
  factory $DownloadedTrackCopyWith(DownloadedTrack value, $Res Function(DownloadedTrack) _then) = _$DownloadedTrackCopyWithImpl;
@useResult
$Res call({
 int fileKey, Track track, String localPath, String? artworkPath, String albumGroupId, String albumArtist, String album, String dateReadable, int discNumber, int totalDiscs, int trackNumber, int fileSizeBytes, DateTime downloadedAt
});


$TrackCopyWith<$Res> get track;

}
/// @nodoc
class _$DownloadedTrackCopyWithImpl<$Res>
    implements $DownloadedTrackCopyWith<$Res> {
  _$DownloadedTrackCopyWithImpl(this._self, this._then);

  final DownloadedTrack _self;
  final $Res Function(DownloadedTrack) _then;

/// Create a copy of DownloadedTrack
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fileKey = null,Object? track = null,Object? localPath = null,Object? artworkPath = freezed,Object? albumGroupId = null,Object? albumArtist = null,Object? album = null,Object? dateReadable = null,Object? discNumber = null,Object? totalDiscs = null,Object? trackNumber = null,Object? fileSizeBytes = null,Object? downloadedAt = null,}) {
  return _then(_self.copyWith(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,albumGroupId: null == albumGroupId ? _self.albumGroupId : albumGroupId // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,dateReadable: null == dateReadable ? _self.dateReadable : dateReadable // ignore: cast_nullable_to_non_nullable
as String,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of DownloadedTrack
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrackCopyWith<$Res> get track {
  
  return $TrackCopyWith<$Res>(_self.track, (value) {
    return _then(_self.copyWith(track: value));
  });
}
}


/// Adds pattern-matching-related methods to [DownloadedTrack].
extension DownloadedTrackPatterns on DownloadedTrack {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DownloadedTrack value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DownloadedTrack() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DownloadedTrack value)  $default,){
final _that = this;
switch (_that) {
case _DownloadedTrack():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DownloadedTrack value)?  $default,){
final _that = this;
switch (_that) {
case _DownloadedTrack() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fileKey,  Track track,  String localPath,  String? artworkPath,  String albumGroupId,  String albumArtist,  String album,  String dateReadable,  int discNumber,  int totalDiscs,  int trackNumber,  int fileSizeBytes,  DateTime downloadedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DownloadedTrack() when $default != null:
return $default(_that.fileKey,_that.track,_that.localPath,_that.artworkPath,_that.albumGroupId,_that.albumArtist,_that.album,_that.dateReadable,_that.discNumber,_that.totalDiscs,_that.trackNumber,_that.fileSizeBytes,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fileKey,  Track track,  String localPath,  String? artworkPath,  String albumGroupId,  String albumArtist,  String album,  String dateReadable,  int discNumber,  int totalDiscs,  int trackNumber,  int fileSizeBytes,  DateTime downloadedAt)  $default,) {final _that = this;
switch (_that) {
case _DownloadedTrack():
return $default(_that.fileKey,_that.track,_that.localPath,_that.artworkPath,_that.albumGroupId,_that.albumArtist,_that.album,_that.dateReadable,_that.discNumber,_that.totalDiscs,_that.trackNumber,_that.fileSizeBytes,_that.downloadedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fileKey,  Track track,  String localPath,  String? artworkPath,  String albumGroupId,  String albumArtist,  String album,  String dateReadable,  int discNumber,  int totalDiscs,  int trackNumber,  int fileSizeBytes,  DateTime downloadedAt)?  $default,) {final _that = this;
switch (_that) {
case _DownloadedTrack() when $default != null:
return $default(_that.fileKey,_that.track,_that.localPath,_that.artworkPath,_that.albumGroupId,_that.albumArtist,_that.album,_that.dateReadable,_that.discNumber,_that.totalDiscs,_that.trackNumber,_that.fileSizeBytes,_that.downloadedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DownloadedTrack extends DownloadedTrack {
  const _DownloadedTrack({required this.fileKey, required this.track, required this.localPath, this.artworkPath, required this.albumGroupId, required this.albumArtist, required this.album, required this.dateReadable, required this.discNumber, required this.totalDiscs, required this.trackNumber, required this.fileSizeBytes, required this.downloadedAt}): super._();
  factory _DownloadedTrack.fromJson(Map<String, dynamic> json) => _$DownloadedTrackFromJson(json);

@override final  int fileKey;
@override final  Track track;
@override final  String localPath;
@override final  String? artworkPath;
@override final  String albumGroupId;
@override final  String albumArtist;
@override final  String album;
@override final  String dateReadable;
@override final  int discNumber;
@override final  int totalDiscs;
@override final  int trackNumber;
@override final  int fileSizeBytes;
@override final  DateTime downloadedAt;

/// Create a copy of DownloadedTrack
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DownloadedTrackCopyWith<_DownloadedTrack> get copyWith => __$DownloadedTrackCopyWithImpl<_DownloadedTrack>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DownloadedTrackToJson(this, );
}



@override
String toString() {
  return 'DownloadedTrack(fileKey: $fileKey, track: $track, localPath: $localPath, artworkPath: $artworkPath, albumGroupId: $albumGroupId, albumArtist: $albumArtist, album: $album, dateReadable: $dateReadable, discNumber: $discNumber, totalDiscs: $totalDiscs, trackNumber: $trackNumber, fileSizeBytes: $fileSizeBytes, downloadedAt: $downloadedAt)';
}


}

/// @nodoc
abstract mixin class _$DownloadedTrackCopyWith<$Res> implements $DownloadedTrackCopyWith<$Res> {
  factory _$DownloadedTrackCopyWith(_DownloadedTrack value, $Res Function(_DownloadedTrack) _then) = __$DownloadedTrackCopyWithImpl;
@override @useResult
$Res call({
 int fileKey, Track track, String localPath, String? artworkPath, String albumGroupId, String albumArtist, String album, String dateReadable, int discNumber, int totalDiscs, int trackNumber, int fileSizeBytes, DateTime downloadedAt
});


@override $TrackCopyWith<$Res> get track;

}
/// @nodoc
class __$DownloadedTrackCopyWithImpl<$Res>
    implements _$DownloadedTrackCopyWith<$Res> {
  __$DownloadedTrackCopyWithImpl(this._self, this._then);

  final _DownloadedTrack _self;
  final $Res Function(_DownloadedTrack) _then;

/// Create a copy of DownloadedTrack
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fileKey = null,Object? track = null,Object? localPath = null,Object? artworkPath = freezed,Object? albumGroupId = null,Object? albumArtist = null,Object? album = null,Object? dateReadable = null,Object? discNumber = null,Object? totalDiscs = null,Object? trackNumber = null,Object? fileSizeBytes = null,Object? downloadedAt = null,}) {
  return _then(_DownloadedTrack(
fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as int,track: null == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as Track,localPath: null == localPath ? _self.localPath : localPath // ignore: cast_nullable_to_non_nullable
as String,artworkPath: freezed == artworkPath ? _self.artworkPath : artworkPath // ignore: cast_nullable_to_non_nullable
as String?,albumGroupId: null == albumGroupId ? _self.albumGroupId : albumGroupId // ignore: cast_nullable_to_non_nullable
as String,albumArtist: null == albumArtist ? _self.albumArtist : albumArtist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,dateReadable: null == dateReadable ? _self.dateReadable : dateReadable // ignore: cast_nullable_to_non_nullable
as String,discNumber: null == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int,totalDiscs: null == totalDiscs ? _self.totalDiscs : totalDiscs // ignore: cast_nullable_to_non_nullable
as int,trackNumber: null == trackNumber ? _self.trackNumber : trackNumber // ignore: cast_nullable_to_non_nullable
as int,fileSizeBytes: null == fileSizeBytes ? _self.fileSizeBytes : fileSizeBytes // ignore: cast_nullable_to_non_nullable
as int,downloadedAt: null == downloadedAt ? _self.downloadedAt : downloadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of DownloadedTrack
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
