import 'package:fpdart/fpdart.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../models/player_status.dart';
import '../models/repeat_mode.dart';
import '../models/shuffle_mode.dart';
import 'player_repository.dart';

class PlayerRepositoryImpl implements PlayerRepository {
  @override
  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(String zoneId) =>
      getIt<McwsClient>().getPlaybackInfo(zoneId);

  @override
  Future<Either<AppException, Unit>> playPause(String zoneId) =>
      getIt<McwsClient>().playPause(zoneId);

  @override
  Future<Either<AppException, Unit>> stop(String zoneId) =>
      getIt<McwsClient>().stop(zoneId);

  @override
  Future<Either<AppException, Unit>> next(String zoneId) =>
      getIt<McwsClient>().next(zoneId);

  @override
  Future<Either<AppException, Unit>> previous(String zoneId) =>
      getIt<McwsClient>().previous(zoneId);

  @override
  Future<Either<AppException, Unit>> setPosition(
    String zoneId,
    int positionMs,
  ) => getIt<McwsClient>().setPosition(zoneId, positionMs);

  @override
  Future<Either<AppException, Unit>> setVolume(String zoneId, double level) =>
      getIt<McwsClient>().setVolume(zoneId, level);

  @override
  Future<Either<AppException, Unit>> setMute(
    String zoneId, {
    required bool mute,
  }) => getIt<McwsClient>().setMute(zoneId, mute: mute);

  @override
  Future<Either<AppException, Unit>> setShuffle(
    String zoneId,
    ShuffleMode mode,
  ) => getIt<McwsClient>().setShuffle(zoneId, mode);

  @override
  Future<Either<AppException, Unit>> setRepeat(
    String zoneId,
    RepeatMode mode,
  ) => getIt<McwsClient>().setRepeat(zoneId, mode);

  @override
  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index) =>
      getIt<McwsClient>().playByIndex(zoneId, index);
}
