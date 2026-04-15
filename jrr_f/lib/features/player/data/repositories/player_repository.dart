import 'package:fpdart/fpdart.dart';

import '../../../../core/error/app_exception.dart';
import '../models/player_status.dart';
import '../models/repeat_mode.dart';
import '../models/shuffle_mode.dart';

abstract interface class PlayerRepository {
  Future<Either<AppException, PlayerStatus>> getPlaybackInfo(String zoneId);
  Future<Either<AppException, Unit>> playPause(String zoneId);
  Future<Either<AppException, Unit>> stop(String zoneId);
  Future<Either<AppException, Unit>> next(String zoneId);
  Future<Either<AppException, Unit>> previous(String zoneId);
  Future<Either<AppException, Unit>> setPosition(String zoneId, int positionMs);
  Future<Either<AppException, Unit>> setVolume(String zoneId, double level);
  Future<Either<AppException, Unit>> setMute(
    String zoneId, {
    required bool mute,
  });
  Future<Either<AppException, Unit>> setShuffle(
    String zoneId,
    ShuffleMode mode,
  );
  Future<Either<AppException, Unit>> setRepeat(String zoneId, RepeatMode mode);
  Future<Either<AppException, Unit>> playByIndex(String zoneId, int index);
}
