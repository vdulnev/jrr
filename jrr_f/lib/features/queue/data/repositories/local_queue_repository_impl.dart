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
  Future<Either<AppException, Tracks>> getTracks() async {
    _talker.debug('[LocalQueueRepo] Fetching tracks from database');
    try {
      final rows = await (_db.select(
        _db.localQueueTracks,
      )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

      final list = rows.map((row) {
        final json = jsonDecode(row.trackJson) as Map<String, dynamic>;
        return Track.fromJson(json);
      }).toList();

      _talker.debug(
        '[LocalQueueRepo] Successfully fetched ${list.length} tracks',
      );
      return right(Tracks(tracks: list));
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to fetch tracks', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setTracks(Tracks tracks) async {
    _talker.debug('[LocalQueueRepo] Setting queue to ${tracks.length} tracks');
    try {
      await _db.transaction(() async {
        await _db.delete(_db.localQueueTracks).go();
        int pos = 0;
        for (final track in tracks.tracks) {
          await _db
              .into(_db.localQueueTracks)
              .insert(
                LocalQueueTracksCompanion.insert(
                  fileKey: track.fileKey,
                  trackJson: jsonEncode(track.toJson()),
                  position: pos++,
                ),
              );
        }
      });
      _talker.debug(
        '[LocalQueueRepo] Successfully set ${tracks.length} tracks',
      );
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to set tracks', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, int>> getCurrentIndex() async {
    _talker.debug('[LocalQueueRepo] Fetching current index from database');
    try {
      final state = await _db.select(_db.localQueueState).getSingleOrNull();
      final index = state?.currentIndex ?? -1;
      _talker.debug(
        '[LocalQueueRepo] Successfully fetched current index: $index',
      );
      return right(index);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to fetch current index', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setCurrentIndex(int index) async {
    _talker.debug('[LocalPlayerController] Setting current index to: $index');
    try {
      await _db
          .into(_db.localQueueState)
          .insertOnConflictUpdate(
            LocalQueueStateCompanion.insert(
              id: const Value(1), // We only ever want one row for state
              currentIndex: Value(index),
            ),
          );
      _talker.debug(
        '[LocalQueueRepo] Successfully set current index to $index',
      );
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to set current index', e, st);
      return left(AppException.unknown(error: e));
    }
  }
}
