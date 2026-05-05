import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/offline/data/models/download_job.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/offline/services/download_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:talker/talker.dart';

class MockDownloadsRepository extends Mock implements DownloadsRepository {}

class MockConnectionRepository extends Mock implements ConnectionRepository {}

class MockDio extends Mock implements Dio {}

class MockPathProvider extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {}

void main() {
  late DownloadService service;
  late MockDownloadsRepository repository;
  late MockConnectionRepository connectionRepository;
  late MockDio dio;
  late Talker talker;
  late Directory tempDir;

  setUp(() async {
    repository = MockDownloadsRepository();
    connectionRepository = MockConnectionRepository();
    dio = MockDio();
    talker = Talker();
    tempDir = await Directory.systemTemp.createTemp();

    final mockPathProvider = MockPathProvider();
    PathProviderPlatform.instance = mockPathProvider;
    when(
      () => mockPathProvider.getApplicationDocumentsPath(),
    ).thenAnswer((_) async => tempDir.path);

    service = DownloadService(
      repository: repository,
      connectionRepository: connectionRepository,
      talker: talker,
      dio: dio,
    );

    // Default mocks
    when(() => repository.watchJobs()).thenAnswer((_) => const Stream.empty());
  });

  tearDown(() async {
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
    duration: 180,
    filePath: 'C:\\Music\\Test Artist\\Test Album\\01 Test Track.flac',
  );

  final testJob = DownloadJob(
    fileKey: 123,
    track: testTrack,
    state: DownloadState.queued,
    enqueuedAt: DateTime.now(),
  );

  test('should download track and mark as completed', () async {
    const server = SavedServer(
      id: 1,
      host: '1.2.3.4',
      port: 52199,
      username: 'user',
      passwordKey: 'pw',
      friendlyName: 'Home',
    );

    when(
      () => connectionRepository.getLastServerWithToken(),
    ).thenAnswer((_) async => server);
    when(() => connectionRepository.currentToken).thenReturn('secret-token');

    // First call: get testJob, second call: null (stop loop)
    var callCount = 0;
    when(() => repository.getNextQueuedJob()).thenAnswer((_) async {
      if (callCount == 0) {
        callCount++;
        return testJob;
      }
      return null;
    });

    when(
      () => repository.updateJob(
        fileKey: any<int>(named: 'fileKey'),
        state: any<DownloadState?>(named: 'state'),
        startedAt: any<DateTime?>(named: 'startedAt'),
        bytesDone: any<int?>(named: 'bytesDone'),
        bytesTotal: any<int?>(named: 'bytesTotal'),
        error: any<String?>(named: 'error'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => dio.download(
        any<String>(),
        any<String>(),
        cancelToken: any(named: 'cancelToken'),
        onReceiveProgress: any(named: 'onReceiveProgress'),
      ),
    ).thenAnswer((invocation) async {
      // Simulate file creation
      final path = invocation.positionalArguments[1] as String;
      await File(path).writeAsString('mock flac data');
      return Response(requestOptions: RequestOptions(path: ''));
    });

    when(
      () => repository.markCompleted(
        fileKey: any<int>(named: 'fileKey'),
        localPath: any<String>(named: 'localPath'),
        artworkPath: any<String?>(named: 'artworkPath'),
        fileSizeBytes: any<int>(named: 'fileSizeBytes'),
      ),
    ).thenAnswer((_) async {});

    service.start();

    // Give it a moment to run the async loop
    await Future<void>.delayed(const Duration(milliseconds: 100));

    verify(() => repository.getNextQueuedJob()).called(2);
    verify(
      () => dio.download(
        any<String>(that: contains('File/GetFile?File=123')),
        any<String>(that: contains('123.part')),
        cancelToken: any(named: 'cancelToken'),
        onReceiveProgress: any(named: 'onReceiveProgress'),
      ),
    ).called(1);

    verify(
      () => repository.markCompleted(
        fileKey: 123,
        localPath: any(named: 'localPath', that: contains('123.flac')),
        artworkPath: any(named: 'artworkPath'),
        fileSizeBytes: any(named: 'fileSizeBytes'),
      ),
    ).called(1);
  });
}
