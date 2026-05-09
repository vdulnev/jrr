import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

import '../../connection/data/repositories/connection_repository.dart';
import '../data/models/download_job.dart';
import '../data/models/download_state.dart';
import '../data/repositories/downloads_repository.dart';

class DownloadService {
  final DownloadsRepository _repository;
  final ConnectionRepository _connectionRepository;
  final Talker _talker;
  final Dio _dio;

  bool _isRunning = false;
  DownloadJob? _currentJob;
  CancelToken? _cancelToken;

  DownloadService({
    required DownloadsRepository repository,
    required ConnectionRepository connectionRepository,
    required Talker talker,
    Dio? dio,
  }) : _repository = repository,
       _connectionRepository = connectionRepository,
       _talker = talker,
       _dio =
           dio ?? Dio(BaseOptions(connectTimeout: const Duration(seconds: 15)));

  void start() {
    if (_isRunning) return;
    _isRunning = true;
    _talker.info('[DownloadService] Started');
    _processQueue();

    // Also listen for new jobs
    _repository.watchJobs().listen((jobs) {
      if (_currentJob == null &&
          jobs.any((j) => j.state == DownloadState.queued)) {
        _processQueue();
      }
    });
  }

  Future<void> _processQueue() async {
    while (_isRunning) {
      final job = await _repository.getNextQueuedJob();
      if (job == null) break;

      _currentJob = job;
      await _runJob(job);
      _currentJob = null;
    }
  }

  Future<void> _runJob(DownloadJob job) async {
    _talker.info('[DownloadService] Starting job: ${job.fileKey}');
    _cancelToken = CancelToken();

    try {
      await _repository.updateJob(
        fileKey: job.fileKey,
        state: DownloadState.running,
        startedAt: DateTime.now(),
      );

      final docs = await getApplicationDocumentsDirectory();
      final tracksDir = Directory('${docs.path}/downloads/tracks');
      final artworkDir = Directory('${docs.path}/downloads/artwork');
      final tmpDir = Directory('${docs.path}/downloads/.tmp');

      if (!await tracksDir.exists()) await tracksDir.create(recursive: true);
      if (!await artworkDir.exists()) await artworkDir.create(recursive: true);
      if (!await tmpDir.exists()) await tmpDir.create(recursive: true);

      final tmpPath = '${tmpDir.path}/${job.fileKey}.part';
      final finalPath = '${tracksDir.path}/${job.fileKey}.flac';

      final server = await _connectionRepository.getLastServerWithToken();
      if (server == null) {
        throw StateError('No active server connection');
      }

      final baseUrl = 'http://${server.host}:${server.port}/MCWS/v1/';
      final token = _connectionRepository.currentToken;

      final downloadUrl =
          '${baseUrl}File/GetFile?File=${job.fileKey}&FileType=Key&Playback=0&Conversion=flac${token != null ? '&Token=$token' : ''}';

      _talker.info('[DownloadService] Downloading: $downloadUrl');

      await _dio.download(
        downloadUrl,
        tmpPath,
        cancelToken: _cancelToken,
        onReceiveProgress: (count, total) {
          _repository.updateJob(
            fileKey: job.fileKey,
            bytesDone: count,
            bytesTotal: total,
          );
        },
      );

      // Success! Move to final location
      final tmpFile = File(tmpPath);
      await tmpFile.rename(finalPath);

      // Download artwork if needed
      String? artworkPath;
      final albumArtPath = '${artworkDir.path}/${job.track.albumGroupId}.jpg';
      if (!await File(albumArtPath).exists()) {
        final artUrl =
            '${baseUrl}File/GetImage?File=${job.fileKey}&Format=jpg&Width=512&Height=512${token != null ? '&Token=$token' : ''}';
        try {
          await _dio.download(artUrl, albumArtPath, cancelToken: _cancelToken);
          artworkPath = albumArtPath;
        } catch (e) {
          _talker.error('[DownloadService] Failed to download artwork', e);
        }
      } else {
        artworkPath = albumArtPath;
      }

      final fileSizeBytes = await File(finalPath).length();

      await _repository.markCompleted(
        fileKey: job.fileKey,
        localPath: finalPath,
        artworkPath: artworkPath,
        fileSizeBytes: fileSizeBytes,
      );

      _talker.info('[DownloadService] Job completed: ${job.fileKey}');
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _talker.info('[DownloadService] Job cancelled: ${job.fileKey}');
        await _repository.updateJob(
          fileKey: job.fileKey,
          state: DownloadState.cancelled,
        );
      } else {
        _talker.error('[DownloadService] Job failed: ${job.fileKey}', e);
        await _repository.updateJob(
          fileKey: job.fileKey,
          state: DownloadState.failed,
          error: e.toString(),
        );
      }
    } catch (e) {
      _talker.error('[DownloadService] Unexpected error: ${job.fileKey}', e);
      await _repository.updateJob(
        fileKey: job.fileKey,
        state: DownloadState.failed,
        error: e.toString(),
      );
    } finally {
      _cancelToken = null;
      // Clean up tmp file if it still exists
      final docs = await getApplicationDocumentsDirectory();
      final tmpPath = '${docs.path}/downloads/.tmp/${job.fileKey}.part';
      final tmpFile = File(tmpPath);
      if (await tmpFile.exists()) {
        await tmpFile.delete();
      }
    }
  }

  void cancel(int fileKey) {
    if (_currentJob?.fileKey == fileKey) {
      _cancelToken?.cancel();
    } else {
      _repository.cancel(fileKey);
    }
  }

  void stop() {
    _isRunning = false;
    _cancelToken?.cancel();
    _talker.info('[DownloadService] Stopped');
  }
}
