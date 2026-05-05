import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/track.dart';
import '../../../library/data/models/tracks.dart';
import 'local_queue_repository.dart';

class LocalQueueRepositoryImpl implements LocalQueueRepository {
  final AppDatabase _db;
  final Talker _talker;

  LocalQueueRepositoryImpl(this._db) : _talker = getIt<Talker>();

  @override
  Future<Either<AppException, Tracks>> getTracks(String zoneId) async {
    _talker.debug('[LocalQueueRepo] Fetching tracks for $zoneId from database');
    try {
      final rows =
          await (_db.select(_db.localQueueTracks)
                ..where((t) => t.zoneId.equals(zoneId))
                ..orderBy([(t) => OrderingTerm.asc(t.position)]))
              .get();

      final list = rows.map((row) {
        final json = jsonDecode(row.trackJson) as Map<String, dynamic>;
        return Track.fromJson(json);
      }).toList();

      _talker.debug(
        '[LocalQueueRepo] Successfully fetched ${list.length} tracks for $zoneId',
      );
      return right(Tracks(tracks: list));
    } catch (e, st) {
      _talker.error(
        '[LocalQueueRepo] Failed to fetch tracks for $zoneId',
        e,
        st,
      );
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setTracks(
    String zoneId,
    Tracks tracks,
  ) async {
    _talker.debug(
      '[LocalQueueRepo] Setting queue for $zoneId to ${tracks.length} tracks',
    );
    try {
      await _db.transaction(() async {
        await (_db.delete(
          _db.localQueueTracks,
        )..where((t) => t.zoneId.equals(zoneId))).go();
        int pos = 0;
        for (final track in tracks.tracks) {
          await _db
              .into(_db.localQueueTracks)
              .insert(
                LocalQueueTracksCompanion.insert(
                  zoneId: Value(zoneId),
                  fileKey: track.fileKey,
                  trackJson: jsonEncode(track.toJson()),
                  position: pos++,
                ),
              );
        }
      });
      _talker.debug(
        '[LocalQueueRepo] Successfully set ${tracks.length} tracks for $zoneId',
      );
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to set tracks for $zoneId', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, int>> getCurrentIndex(String zoneId) async {
    _talker.debug(
      '[LocalQueueRepo] Fetching current index for $zoneId from database',
    );
    try {
      final state = await (_db.select(
        _db.localQueueState,
      )..where((t) => t.zoneId.equals(zoneId))).getSingleOrNull();
      final index = state?.currentIndex ?? -1;
      _talker.debug(
        '[LocalQueueRepo] Successfully fetched current index for $zoneId: $index',
      );
      return right(index);
    } catch (e, st) {
      _talker.error(
        '[LocalQueueRepo] Failed to fetch current index for $zoneId',
        e,
        st,
      );
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setCurrentIndex(
    String zoneId,
    int index,
  ) async {
    _talker.debug(
      '[LocalQueueRepo] Setting current index for $zoneId to: $index',
    );
    try {
      await _db
          .into(_db.localQueueState)
          .insertOnConflictUpdate(
            LocalQueueStateCompanion.insert(
              zoneId: zoneId,
              currentIndex: Value(index),
            ),
          );
      _talker.debug(
        '[LocalQueueRepo] Successfully set current index for $zoneId to $index',
      );
      return right(unit);
    } catch (e, st) {
      _talker.error(
        '[LocalQueueRepo] Failed to set current index for $zoneId',
        e,
        st,
      );
      return left(AppException.unknown(error: e));
    }
  }
}
