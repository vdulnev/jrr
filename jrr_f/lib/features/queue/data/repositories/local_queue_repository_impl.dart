import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/db/app_database.dart';
import '../../../../core/error/app_exception.dart';
import '../../../library/data/models/track.dart';
import 'local_queue_repository.dart';

class LocalQueueRepositoryImpl implements LocalQueueRepository {
  final AppDatabase _db;

  LocalQueueRepositoryImpl(this._db);

  @override
  Future<Either<AppException, List<Track>>> getTracks() async {
    try {
      final rows = await (_db.select(
        _db.localQueueTracks,
      )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

      final tracks = rows.map((row) {
        final json = jsonDecode(row.trackJson) as Map<String, dynamic>;
        return Track.fromJson(json);
      }).toList();

      return right(tracks);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> addTracks(List<Track> tracks) async {
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
      return right(unit);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> setTracks(List<Track> tracks) async {
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
      return right(unit);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> removeTrack(int index) async {
    try {
      await _db.transaction(() async {
        final all = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        if (index < 0 || index >= all.length) return;

        final toDelete = all[index];
        await (_db.delete(
          _db.localQueueTracks,
        )..where((t) => t.id.equals(toDelete.id))).go();

        // Resort the rest to keep positions continuous (optional but cleaner)
        final remaining = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        for (int i = 0; i < remaining.length; i++) {
          await (_db.update(_db.localQueueTracks)
                ..where((t) => t.id.equals(remaining[i].id)))
              .write(LocalQueueTracksCompanion(position: Value(i)));
        }
      });
      return right(unit);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> moveTrack(
    int oldIndex,
    int newIndex,
  ) async {
    try {
      await _db.transaction(() async {
        final all = await (_db.select(
          _db.localQueueTracks,
        )..orderBy([(t) => OrderingTerm.asc(t.position)])).get();

        if (oldIndex < 0 || oldIndex >= all.length) return;
        if (newIndex < 0 || newIndex >= all.length) return;

        final item = all.removeAt(oldIndex);
        all.insert(newIndex, item);

        for (int i = 0; i < all.length; i++) {
          await (_db.update(_db.localQueueTracks)
                ..where((t) => t.id.equals(all[i].id)))
              .write(LocalQueueTracksCompanion(position: Value(i)));
        }
      });
      return right(unit);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }

  @override
  Future<Either<AppException, Unit>> clear() async {
    try {
      await _db.delete(_db.localQueueTracks).go();
      return right(unit);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }
}
