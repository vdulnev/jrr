import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

import '../../../../core/db/app_database.dart';
import '../../../library/data/models/track.dart';
import '../models/download_job.dart' as model;
import '../models/download_state.dart';
import '../models/downloaded_track.dart' as model;
import 'downloads_repository.dart';

class DownloadsRepositoryImpl implements DownloadsRepository {
  final AppDatabase _db;
  final Talker _talker;
  final Map<int, String> _localPathCache = {};
  final Map<int, String> _artworkPathCache = {};

  DownloadsRepositoryImpl({required AppDatabase db, required Talker talker})
    : _db = db,
      _talker = talker {
    _initCache();
  }

  Future<void> _initCache() async {
    final tracks = await getDownloadedTracks();
    _populateCaches(tracks);
    _talker.info(
      '[DownloadsRepository] Cache initialized with ${_localPathCache.length} tracks',
    );

    // Listen for changes to keep cache in sync
    watchDownloadedTracks().listen(_populateCaches);
  }

  void _populateCaches(List<model.DownloadedTrack> tracks) {
    _localPathCache
      ..clear()
      ..addEntries(tracks.map((t) => MapEntry(t.fileKey, t.localPath)));
    _artworkPathCache.clear();
    for (final t in tracks) {
      final p = t.artworkPath;
      if (p != null && p.isNotEmpty) {
        _artworkPathCache[t.fileKey] = p;
      }
    }
  }

  @override
  String? localPathFor(int fileKey) => _localPathCache[fileKey];

  @override
  String? artworkPathFor(int fileKey) => _artworkPathCache[fileKey];

  @override
  Future<void> enqueue(Track track) async {
    _talker.info('[DownloadsRepository] Enqueuing track: ${track.fileKey}');
    await _db
        .into(_db.downloadJobs)
        .insert(
          DownloadJobsCompanion.insert(
            fileKey: track.fileKey,
            trackJson: jsonEncode(track.toJson()),
            state: DownloadState.queued.name,
            bytesDone: 0,
            bytesTotal: -1,
            enqueuedAt: DateTime.now().millisecondsSinceEpoch,
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<void> enqueueAll(List<Track> tracks) async {
    _talker.info('[DownloadsRepository] Enqueuing ${tracks.length} tracks');
    await _db.batch((batch) {
      for (final track in tracks) {
        batch.insert(
          _db.downloadJobs,
          DownloadJobsCompanion.insert(
            fileKey: track.fileKey,
            trackJson: jsonEncode(track.toJson()),
            state: DownloadState.queued.name,
            bytesDone: 0,
            bytesTotal: -1,
            enqueuedAt: DateTime.now().millisecondsSinceEpoch,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> cancel(int fileKey) async {
    await cancelAll([fileKey]);
  }

  @override
  Future<void> cancelAll(List<int> fileKeys) async {
    _talker.info('[DownloadsRepository] Cancelling ${fileKeys.length} jobs');
    await (_db.update(
      _db.downloadJobs,
    )..where((t) => t.fileKey.isIn(fileKeys))).write(
      DownloadJobsCompanion(state: Value(DownloadState.cancelled.name)),
    );
  }

  @override
  Future<void> delete(int fileKey) async {
    await deleteAll([fileKey]);
  }

  @override
  Future<void> deleteAll(List<int> fileKeys) async {
    _talker.info('[DownloadsRepository] Deleting ${fileKeys.length} tracks');

    final tracks = await (_db.select(
      _db.downloadedTracks,
    )..where((t) => t.fileKey.isIn(fileKeys))).get();

    if (tracks.isEmpty) return;

    for (final track in tracks) {
      // Delete file
      final file = File(track.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }

    // Check artwork deletion: if an album has NO MORE tracks left in downloadedTracks
    // after this delete, remove its artwork.
    final albumGroupIds = tracks.map((t) => t.albumGroupId).toSet();
    for (final albumGroupId in albumGroupIds) {
      final remaining =
          await (_db.select(_db.downloadedTracks)
                ..where((t) => t.albumGroupId.equals(albumGroupId))
                ..where((t) => t.fileKey.isIn(fileKeys).not())
                ..limit(1))
              .get();

      if (remaining.isEmpty) {
        // Find one track from the deleted set to get the artwork path
        final deletedTrack = tracks.firstWhere(
          (t) => t.albumGroupId == albumGroupId,
        );
        if (deletedTrack.artworkPath != null) {
          final artFile = File(deletedTrack.artworkPath!);
          if (await artFile.exists()) {
            await artFile.delete();
          }
        }
      }
    }

    // Delete DB rows
    await (_db.delete(
      _db.downloadedTracks,
    )..where((t) => t.fileKey.isIn(fileKeys))).go();
  }

  @override
  Future<void> removeJob(int fileKey) async {
    _talker.info('[DownloadsRepository] Removing job: $fileKey');
    await (_db.delete(
      _db.downloadJobs,
    )..where((t) => t.fileKey.equals(fileKey))).go();
  }

  @override
  Future<void> clearAll() async {
    _talker.info('[DownloadsRepository] Clearing all downloads');
    // Cancel all running/queued
    await (_db.update(_db.downloadJobs)..where(
          (t) =>
              t.state.equals(DownloadState.queued.name) |
              t.state.equals(DownloadState.running.name),
        ))
        .write(
          DownloadJobsCompanion(state: Value(DownloadState.cancelled.name)),
        );

    // Delete all files
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/downloads');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }

    // Clear tables
    await _db.delete(_db.downloadJobs).go();
    await _db.delete(_db.downloadedTracks).go();
  }

  @override
  Future<List<model.DownloadJob>> getJobs() async {
    final rows = await _db.select(_db.downloadJobs).get();
    return rows.map(_mapJob).toList();
  }

  @override
  Future<List<model.DownloadedTrack>> getDownloadedTracks() async {
    final rows = await _db.select(_db.downloadedTracks).get();
    return rows.map(_mapDownloadedTrack).toList();
  }

  @override
  Future<String?> getLocalPath(int fileKey) async {
    final row = await (_db.select(
      _db.downloadedTracks,
    )..where((t) => t.fileKey.equals(fileKey))).getSingleOrNull();
    return row?.localPath;
  }

  @override
  Future<DownloadState> getDownloadState(int fileKey) async {
    final downloaded = await (_db.select(
      _db.downloadedTracks,
    )..where((t) => t.fileKey.equals(fileKey))).getSingleOrNull();
    if (downloaded != null) return DownloadState.downloaded;

    final job = await (_db.select(
      _db.downloadJobs,
    )..where((t) => t.fileKey.equals(fileKey))).getSingleOrNull();
    if (job != null) {
      return DownloadState.values.firstWhere(
        (e) => e.name == job.state,
        orElse: () => DownloadState.notDownloaded,
      );
    }

    return DownloadState.notDownloaded;
  }

  @override
  Stream<List<model.DownloadJob>> watchJobs() {
    return _db
        .select(_db.downloadJobs)
        .watch()
        .map((rows) => rows.map(_mapJob).toList());
  }

  @override
  Stream<List<model.DownloadedTrack>> watchDownloadedTracks() {
    return _db
        .select(_db.downloadedTracks)
        .watch()
        .map((rows) => rows.map(_mapDownloadedTrack).toList());
  }

  @override
  Future<void> markCompleted({
    required int fileKey,
    required String localPath,
    String? artworkPath,
    required int fileSizeBytes,
  }) async {
    final jobRow = await (_db.select(
      _db.downloadJobs,
    )..where((t) => t.fileKey.equals(fileKey))).getSingleOrNull();

    if (jobRow == null) return;

    final track = Track.fromJson(
      jsonDecode(jobRow.trackJson) as Map<String, dynamic>,
    );

    await _db.transaction(() async {
      await _db
          .into(_db.downloadedTracks)
          .insert(
            DownloadedTracksCompanion.insert(
              fileKey: fileKey,
              trackJson: jobRow.trackJson,
              localPath: localPath,
              artworkPath: Value(artworkPath),
              albumGroupId: track.albumGroupId,
              albumArtist: track.albumArtistAuto,
              album: track.album,
              dateReadable: track.date,
              discNumber: track.discNumber,
              totalDiscs: track.totalDiscs,
              trackNumber: track.trackNumber,
              fileSizeBytes: fileSizeBytes,
              downloadedAt: DateTime.now().millisecondsSinceEpoch,
            ),
          );
      await (_db.delete(
        _db.downloadJobs,
      )..where((t) => t.fileKey.equals(fileKey))).go();
    });
  }

  @override
  Future<void> updateJob({
    required int fileKey,
    DownloadState? state,
    int? bytesDone,
    int? bytesTotal,
    String? error,
    DateTime? startedAt,
  }) async {
    await (_db.update(
      _db.downloadJobs,
    )..where((t) => t.fileKey.equals(fileKey))).write(
      DownloadJobsCompanion(
        state: state != null ? Value(state.name) : const Value.absent(),
        bytesDone: bytesDone != null ? Value(bytesDone) : const Value.absent(),
        bytesTotal: bytesTotal != null
            ? Value(bytesTotal)
            : const Value.absent(),
        error: error != null ? Value(error) : const Value.absent(),
        startedAt: startedAt != null
            ? Value(startedAt.millisecondsSinceEpoch)
            : const Value.absent(),
      ),
    );
  }

  @override
  Future<model.DownloadJob?> getNextQueuedJob() async {
    final row =
        await (_db.select(_db.downloadJobs)
              ..where((t) => t.state.equals(DownloadState.queued.name))
              ..orderBy([(t) => OrderingTerm(expression: t.enqueuedAt)])
              ..limit(1))
            .getSingleOrNull();

    return row != null ? _mapJob(row) : null;
  }

  model.DownloadJob _mapJob(DownloadJobRow row) {
    return model.DownloadJob(
      fileKey: row.fileKey,
      track: Track.fromJson(jsonDecode(row.trackJson) as Map<String, dynamic>),
      state: DownloadState.values.firstWhere((e) => e.name == row.state),
      bytesDone: row.bytesDone,
      bytesTotal: row.bytesTotal,
      enqueuedAt: DateTime.fromMillisecondsSinceEpoch(row.enqueuedAt),
      startedAt: row.startedAt != null
          ? DateTime.fromMillisecondsSinceEpoch(row.startedAt!)
          : null,
      error: row.error,
    );
  }

  model.DownloadedTrack _mapDownloadedTrack(DownloadedTrackRow row) {
    return model.DownloadedTrack(
      fileKey: row.fileKey,
      track: Track.fromJson(jsonDecode(row.trackJson) as Map<String, dynamic>),
      localPath: row.localPath,
      artworkPath: row.artworkPath,
      albumGroupId: row.albumGroupId,
      albumArtist: row.albumArtist,
      album: row.album,
      dateReadable: row.dateReadable,
      discNumber: row.discNumber,
      totalDiscs: row.totalDiscs,
      trackNumber: row.trackNumber,
      fileSizeBytes: row.fileSizeBytes,
      downloadedAt: DateTime.fromMillisecondsSinceEpoch(row.downloadedAt),
    );
  }
}
