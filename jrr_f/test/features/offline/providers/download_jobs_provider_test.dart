import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/providers/download_jobs_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

void main() {
  late MockDownloadsRepo repo;
  late StreamController<List<DownloadJob>> controller;
  late ProviderContainer container;

  DownloadJob job(int key, DownloadState s) => DownloadJob(
    fileKey: key,
    track: Track(fileKey: key),
    state: s,
    enqueuedAt: DateTime.utc(2026),
  );

  setUp(() {
    repo = MockDownloadsRepo();
    controller = StreamController<List<DownloadJob>>.broadcast();
    when(() => repo.watchJobs()).thenAnswer((_) => controller.stream);
    container = ProviderContainer(
      overrides: [downloadsRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(() async {
      await controller.close();
      container.dispose();
    });
  });

  test('emits the latest list pushed onto the watch stream', () async {
    final sub = container.listen(downloadJobsProvider, (_, _) {});
    addTearDown(sub.close);

    expect(container.read(downloadJobsProvider).isLoading, isTrue);

    controller.add([job(1, DownloadState.queued)]);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(downloadJobsProvider).value!.single.fileKey, 1);

    controller.add([
      job(1, DownloadState.running),
      job(2, DownloadState.queued),
    ]);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(downloadJobsProvider).value!.length, 2);
  });
}
