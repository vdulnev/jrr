import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository_impl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:talker/talker.dart';

class MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  late AppDatabase db;
  late DownloadsRepositoryImpl repository;
  late Talker talker;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    talker = Talker();
    repository = DownloadsRepositoryImpl(db: db, talker: talker);
    tempDir = await Directory.systemTemp.createTemp();

    final mockPathProvider = MockPathProvider();
    PathProviderPlatform.instance = mockPathProvider;
    when(
      () => mockPathProvider.getApplicationDocumentsPath(),
    ).thenAnswer((_) async => tempDir.path);
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  const testTrack = Track(
    fileKey: 123,
    name: 'Test Track',
    artist: 'Test Artist',
    album: 'Test Album',
    albumArtist: 'Test Artist',
    genre: 'Test Genre',
    dateReadable: '2024',
    bitrate: 320,
    trackNumber: 1,
    discNumber: 1,
    totalDiscs: 1,
    duration: 180, // 3 minutes in seconds
    filePath: 'C:\\Music\\Test Artist\\Test Album\\01 Test Track.flac',
  );

  test('enqueue should insert a job', () async {
    await repository.enqueue(testTrack);
    final jobs = await repository.getJobs();
    expect(jobs, hasLength(1));
    expect(jobs.first.fileKey, 123);
    expect(jobs.first.state, DownloadState.queued);
  });

  test('markCompleted should move job to downloaded_tracks', () async {
    await repository.enqueue(testTrack);
    await repository.markCompleted(
      fileKey: 123,
      localPath: '/path/to/file.flac',
      fileSizeBytes: 1024,
    );

    final jobs = await repository.getJobs();
    expect(jobs, isEmpty);

    final downloaded = await repository.getDownloadedTracks();
    expect(downloaded, hasLength(1));
    expect(downloaded.first.fileKey, 123);
    expect(downloaded.first.localPath, '/path/to/file.flac');
  });

  test('delete should remove DB row and file', () async {
    final file = File('${tempDir.path}/test.flac');
    await file.writeAsString('test');

    await repository.enqueue(testTrack);
    await repository.markCompleted(
      fileKey: 123,
      localPath: file.path,
      fileSizeBytes: 1024,
    );

    expect(await file.exists(), true);

    await repository.delete(123);

    final downloaded = await repository.getDownloadedTracks();
    expect(downloaded, isEmpty);
    expect(await file.exists(), false);
  });
}
