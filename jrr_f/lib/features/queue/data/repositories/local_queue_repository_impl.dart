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
}
