import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/track.dart';
import 'local_queue_repository.dart';

class LocalQueueRepositoryImpl implements LocalQueueRepository {
  final AppDatabase _db;
  final Talker _talker;

  LocalQueueRepositoryImpl(this._db) : _talker = getIt<Talker>();

  @override
  Future<Either<AppException, List<Track>>> getTracks() async {
    _talker.debug('[LocalQueueRepo] Fetching tracks from database');
    try {
      final rows = await (_db.select(
        _db.localQueueTracks,
      )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

      final tracks = rows.map((row) {
        final json = jsonDecode(row.trackJson) as Map<String, dynamic>;
        return Track.fromJson(json);
      }).toList();

      _talker.debug('[LocalQueueRepo] Successfully fetched ${tracks.length} tracks');
      _talker.debug('[LocalQueueRepo] Tracks: ${tracks.map((t) => t.name).join(', ')}');
      return right(tracks);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to fetch tracks', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> addTracks(List<Track> tracks) async {
    _talker.debug('[LocalQueueRepo] Adding ${tracks.length} tracks to queue');
    try {
      await _db.transaction(() async {
        final lastRow =
            await (_db.select(_db.localQueueTracks)
                  ..orderBy([(t) => OrderingTerm.desc(t.position)])
                  ..limit(1))
                .getSingleOrNull();

        int nextPos = (lastRow?.position ?? -1) + 1;

        for (final track in tracks) {
          await _db
              .into(_db.localQueueTracks)
              .insert(
                LocalQueueTracksCompanion.insert(
                  fileKey: track.fileKey,
                  trackJson: jsonEncode(track.toJson()),
                  position: nextPos++,
                ),
              );
        }
      });
      _talker.debug('[LocalQueueRepo] Successfully added ${tracks.length} tracks');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to add tracks', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setTracks(List<Track> tracks) async {
    _talker.debug('[LocalQueueRepo] Setting queue to ${tracks.length} tracks');
    try {
      await _db.transaction(() async {
        await _db.delete(_db.localQueueTracks).go();
        int pos = 0;
        for (final track in tracks) {
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
      _talker.debug('[LocalQueueRepo] Successfully set ${tracks.length} tracks');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to set tracks', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> removeTrack(int index) async {
    _talker.debug('[LocalQueueRepo] Removing track at index: $index');
    try {
      await _db.transaction(() async {
        final all = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        if (index < 0 || index >= all.length) {
          _talker.warning('[LocalQueueRepo] Remove index $index out of bounds (len: ${all.length})');
          return;
        }

        final toDelete = all[index];
        await (_db.delete(
          _db.localQueueTracks,
        )..where((t) => t.id.equals(toDelete.id))).go();

        // Resort the rest to keep positions continuous
        final remaining = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        for (int i = 0; i < remaining.length; i++) {
          await (_db.update(_db.localQueueTracks)
                ..where((t) => t.id.equals(remaining[i].id)))
              .write(LocalQueueTracksCompanion(position: Value(i)));
        }
      });
      _talker.debug('[LocalQueueRepo] Successfully removed track at $index');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to remove track at $index', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> moveTrack(
    int oldIndex,
    int newIndex,
  ) async {
    _talker.debug('[LocalQueueRepo] Moving track from $oldIndex to $newIndex');
    try {
      await _db.transaction(() async {
        final all = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        if (oldIndex < 0 || oldIndex >= all.length) {
          _talker.warning('[LocalQueueRepo] Move oldIndex $oldIndex out of bounds');
          return;
        }
        if (newIndex < 0 || newIndex >= all.length) {
          _talker.warning('[LocalQueueRepo] Move newIndex $newIndex out of bounds');
          return;
        }

        final item = all.removeAt(oldIndex);
        all.insert(newIndex, item);

        for (int i = 0; i < all.length; i++) {
          await (_db.update(_db.localQueueTracks)
                ..where((t) => t.id.equals(all[i].id)))
              .write(LocalQueueTracksCompanion(position: Value(i)));
        }
      });
      _talker.debug('[LocalQueueRepo] Successfully moved track');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to move track', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> clear() async {
    _talker.debug('[LocalQueueRepo] Clearing local queue');
    try {
      await _db.delete(_db.localQueueTracks).go();
      _talker.debug('[LocalQueueRepo] Successfully cleared local queue');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to clear local queue', e, st);
      return left(AppException.unknown(error: e));
    }
  }
  
  @override
  Future<Either<AppException, Unit>> insertTracksAt(int index, List<Track> tracksToInsert) async {
    _talker.debug('[LocalQueueRepo] Inserting ${tracksToInsert.length} tracks at index $index');
    try {
      final existingTracksResult = await getTracks();
      return await existingTracksResult.fold(
        (e) => left(e),
        (existingTracks) async {
          if (index < 0 || index > existingTracks.length) {
            _talker.warning('[LocalQueueRepo] Insert index $index out of bounds');
            return left(const AppException.unknown(error: 'Index out of bounds'));
          }
          final newList = List<Track>.from(existingTracks)..insertAll(index, tracksToInsert);
          return await setTracks(newList);
        },
      );
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to insert tracks at $index', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, int>> getCurrentIndex() async {
    _talker.debug('[LocalQueueRepo] Fetching current index from database');
    try {
      final state = await _db.select(_db.localQueueState).getSingleOrNull();
      final index = state?.currentIndex ?? -1;
      _talker.debug('[LocalQueueRepo] Successfully fetched current index: $index');
      return right(index);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to fetch current index', e, st);
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setCurrentIndex(int index) async {
    _talker.debug('[LocalQueueRepo] Setting current index to: $index');
    try {
      await _db.into(_db.localQueueState).insertOnConflictUpdate(
            LocalQueueStateCompanion.insert(
              id: const Value(1), // We only ever want one row for state
              currentIndex: Value(index),
            ),
          );
      _talker.debug('[LocalQueueRepo] Successfully set current index to $index');
      return right(unit);
    } catch (e, st) {
      _talker.error('[LocalQueueRepo] Failed to set current index', e, st);
      return left(AppException.unknown(error: e));
    }
  }
}
