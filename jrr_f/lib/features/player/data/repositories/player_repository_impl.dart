import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/player_status.dart';
import '../models/repeat_mode.dart';
import '../models/shuffle_mode.dart';
import 'player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  final McwsClient Function() _client;

  PlayerRepositoryImpl({required McwsClient Function() client})
    : _client = client;

  @override
  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(String zoneId) =>
      _client().getPlaybackInfo(zoneId);

  @override
  Future<Either<AppException, Unit>> playPause(String zoneId) =>
      _client().playPause(zoneId);

  @override
  Future<Either<AppException, Unit>> stop(String zoneId) =>
      _client().stop(zoneId);

  @override
  Future<Either<AppException, Unit>> next(String zoneId) =>
      _client().next(zoneId);

  @override
  Future<Either<AppException, Unit>> previous(String zoneId) =>
      _client().previous(zoneId);

  @override
  Future<Either<AppException, Unit>> setPosition(
    String zoneId,
    int positionMs,
  ) => _client().setPosition(zoneId, positionMs);

  @override
  Future<Either<AppException, Unit>> setVolume(String zoneId, double level) =>
      _client().setVolume(zoneId, level);

  @override
  Future<Either<AppException, Unit>> setMute(
    String zoneId, {
    required bool mute,
  }) => _client().setMute(zoneId, mute: mute);

  @override
  Future<Either<AppException, Unit>> setShuffle(
    String zoneId,
    ShuffleMode mode,
  ) => _client().setShuffle(zoneId, mode);

  @override
  Future<Either<AppException, Unit>> setRepeat(
    String zoneId,
    RepeatMode mode,
  ) => _client().setRepeat(zoneId, mode);

  @override
  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index) =>
      _client().playByIndex(zoneId, index);
}
