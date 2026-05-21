import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';

void main() {
  group('DownloadJob', () {
    const track = Track(fileKey: 99, name: 'Song');
    final enqueued = DateTime.utc(2026, 5, 21, 12, 0, 0);
    final started = DateTime.utc(2026, 5, 21, 12, 0, 30);

    test('defaults bytesDone=0 and bytesTotal=-1', () {
      final job = DownloadJob(
        fileKey: 99,
        track: track,
        state: DownloadState.queued,
        enqueuedAt: enqueued,
      );
      expect(job.bytesDone, 0);
      expect(job.bytesTotal, -1);
      expect(job.startedAt, isNull);
      expect(job.error, isNull);
    });

    test('fromJson reads camelCase keys and enum name', () {
      final job = DownloadJob.fromJson({
        'fileKey': 99,
        'track': {'Key': 99, 'Name': 'Song'},
        'state': 'running',
        'bytesDone': 1024,
        'bytesTotal': 4096,
        'enqueuedAt': enqueued.toIso8601String(),
        'startedAt': started.toIso8601String(),
        'error': null,
      });
      expect(job.fileKey, 99);
      expect(job.track.fileKey, 99);
      expect(job.track.name, 'Song');
      expect(job.state, DownloadState.running);
      expect(job.bytesDone, 1024);
      expect(job.bytesTotal, 4096);
      expect(job.enqueuedAt, enqueued);
      expect(job.startedAt, started);
      expect(job.error, isNull);
    });

    test('fromJson tolerates missing optional fields', () {
      final job = DownloadJob.fromJson({
        'fileKey': 1,
        'track': {'Key': 1},
        'state': 'failed',
        'enqueuedAt': enqueued.toIso8601String(),
      });
      expect(job.bytesDone, 0);
      expect(job.bytesTotal, -1);
      expect(job.startedAt, isNull);
      expect(job.error, isNull);
      expect(job.state, DownloadState.failed);
    });

    test('copyWith advances state', () {
      final job = DownloadJob(
        fileKey: 1,
        track: track,
        state: DownloadState.queued,
        enqueuedAt: enqueued,
      );
      final running = job.copyWith(
        state: DownloadState.running,
        startedAt: started,
      );
      expect(running.state, DownloadState.running);
      expect(running.startedAt, started);
      expect(job.state, DownloadState.queued);
    });
  });
}
