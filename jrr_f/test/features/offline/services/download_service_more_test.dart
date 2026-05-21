import 'dart:async';
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

const _track = Track(fileKey: 7, name: 'Song');

void main() {
  late MockDownloadsRepository repository;
  late MockConnectionRepository connectionRepository;
  late MockDio dio;
  late DownloadService service;
  late Directory tempDir;

  setUp(() async {
    repository = MockDownloadsRepository();
    connectionRepository = MockConnectionRepository();
    dio = MockDio();
    tempDir = await Directory.systemTemp.createTemp('dls-more-');

    final mockPath = MockPathProvider();
    PathProviderPlatform.instance = mockPath;
    when(
      () => mockPath.getApplicationDocumentsPath(),
    ).thenAnswer((_) async => tempDir.path);

    when(() => repository.watchJobs()).thenAnswer((_) => const Stream.empty());
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

    service = DownloadService(
      repository: repository,
      connectionRepository: connectionRepository,
      talker: Talker(),
      dio: dio,
    );
  });

  tearDown(() async {
    service.stop();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  DownloadJob job() => DownloadJob(
    fileKey: 7,
    track: _track,
    state: DownloadState.queued,
    enqueuedAt: DateTime.now(),
  );

  void stubServer() {
    const server = SavedServer(
      id: 1,
      host: 'h',
      port: 52199,
      username: 'u',
      passwordKey: 'k',
      friendlyName: null,
      useSsl: false,
      sslPort: 52200,
    );
    when(
      () => connectionRepository.getLastServerWithToken(),
    ).thenAnswer((_) async => server);
    when(() => connectionRepository.currentToken).thenReturn('tok');
  }

  /// Stubs `repository.getNextQueuedJob` to return [job] once then null,
  /// breaking the worker loop after a single iteration.
  void stubOneJob(DownloadJob jobToReturn) {
    var calls = 0;
    when(() => repository.getNextQueuedJob()).thenAnswer((_) async {
      calls++;
      return calls == 1 ? jobToReturn : null;
    });
  }

  group('start()', () {
    test(
      'is idempotent — calling start twice does not duplicate loop runs',
      () async {
        when(() => repository.getNextQueuedJob()).thenAnswer((_) async => null);
        service.start();
        service.start(); // no-op
        await Future<void>.delayed(const Duration(milliseconds: 30));
        // One sweep of the loop ran from the first call. The second start()
        // returns early without touching the repository again.
        verify(() => repository.getNextQueuedJob()).called(1);
      },
    );
  });

  group('_runJob — failure branches', () {
    test('failure when no saved server is available', () async {
      when(
        () => connectionRepository.getLastServerWithToken(),
      ).thenAnswer((_) async => null);
      stubOneJob(job());

      service.start();
      await Future<void>.delayed(const Duration(milliseconds: 60));

      verify(
        () => repository.updateJob(
          fileKey: 7,
          state: DownloadState.failed,
          error: any(named: 'error', that: contains('No active server')),
        ),
      ).called(1);
    });

    test('non-cancel DioException marks job as failed', () async {
      stubServer();
      stubOneJob(job());
      when(
        () => dio.download(
          any<String>(),
          any<String>(),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'x'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: 'x'),
            statusCode: 500,
          ),
        ),
      );

      service.start();
      await Future<void>.delayed(const Duration(milliseconds: 60));

      verify(
        () => repository.updateJob(
          fileKey: 7,
          state: DownloadState.failed,
          error: any<String>(named: 'error'),
        ),
      ).called(1);
    });

    test('cancellation marks job as cancelled', () async {
      stubServer();
      stubOneJob(job());

      final cancelToken = CancelToken();
      when(
        () => dio.download(
          any<String>(),
          any<String>(),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((invocation) async {
        final ct = invocation.namedArguments[#cancelToken] as CancelToken;
        cancelToken.cancel();
        throw DioException(
          requestOptions: RequestOptions(path: 'x'),
          type: DioExceptionType.cancel,
          error: ct.cancelError,
        );
      });

      service.start();
      await Future<void>.delayed(const Duration(milliseconds: 60));

      verify(
        () => repository.updateJob(fileKey: 7, state: DownloadState.cancelled),
      ).called(1);
    });

    test('artwork download failure does not fail the track download', () async {
      stubServer();
      stubOneJob(job());

      var downloadCount = 0;
      when(
        () => dio.download(
          any<String>(),
          any<String>(),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer((invocation) async {
        downloadCount++;
        if (downloadCount == 1) {
          // Track download succeeds — write tmp file.
          final path = invocation.positionalArguments[1] as String;
          await File(path).writeAsString('flac');
          return Response(requestOptions: RequestOptions(path: ''));
        }
        // Artwork download fails.
        throw DioException(
          requestOptions: RequestOptions(path: 'art'),
          type: DioExceptionType.badResponse,
        );
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
      await Future<void>.delayed(const Duration(milliseconds: 60));

      // Marked complete with null artworkPath after the artwork DioException
      // was swallowed.
      verify(
        () => repository.markCompleted(
          fileKey: 7,
          localPath: any(named: 'localPath'),
          artworkPath: null,
          fileSizeBytes: any(named: 'fileSizeBytes'),
        ),
      ).called(1);
    });

    test(
      'reuses existing artwork on disk instead of downloading again',
      () async {
        stubServer();
        stubOneJob(job());

        // Pre-create the artwork file so the service should skip its download.
        final artworkDir = Directory('${tempDir.path}/downloads/artwork')
          ..createSync(recursive: true);
        final art = File('${artworkDir.path}/${_track.albumGroupId}.jpg')
          ..writeAsStringSync('img');

        when(
          () => dio.download(
            any<String>(),
            any<String>(),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).thenAnswer((invocation) async {
          final path = invocation.positionalArguments[1] as String;
          await File(path).writeAsString('flac');
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
        await Future<void>.delayed(const Duration(milliseconds: 60));

        // Only the track was downloaded — the artwork download was skipped.
        verify(
          () => dio.download(
            any<String>(),
            any<String>(),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).called(1);
        verify(
          () => repository.markCompleted(
            fileKey: 7,
            localPath: any(named: 'localPath'),
            artworkPath: art.path,
            fileSizeBytes: any(named: 'fileSizeBytes'),
          ),
        ).called(1);
      },
    );
  });

  group('cancel()', () {
    test(
      'cancels the active CancelToken when fileKey matches current job',
      () async {
        stubServer();
        stubOneJob(job());

        // Hold the download open until we call cancel(), then throw a cancel.
        late CancelToken capturedToken;
        final completer = Completer<Response<dynamic>>();
        when(
          () => dio.download(
            any<String>(),
            any<String>(),
            cancelToken: any(named: 'cancelToken'),
            onReceiveProgress: any(named: 'onReceiveProgress'),
          ),
        ).thenAnswer((invocation) {
          capturedToken =
              invocation.namedArguments[#cancelToken] as CancelToken;
          return completer.future;
        });

        service.start();
        // Wait until the worker has reached dio.download and captured the
        // token. The capture happens synchronously inside the stubbed call.
        await Future<void>.delayed(const Duration(milliseconds: 40));

        service.cancel(7);
        // Simulate dio reacting to cancel.
        completer.completeError(
          DioException(
            requestOptions: RequestOptions(path: 'x'),
            type: DioExceptionType.cancel,
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 30));

        expect(capturedToken.isCancelled, isTrue);
      },
    );

    test(
      'falls back to repository.cancel when the fileKey is not current',
      () async {
        when(() => repository.cancel(any())).thenAnswer((_) async {});
        service.cancel(999);
        verify(() => repository.cancel(999)).called(1);
      },
    );
  });

  group('stop()', () {
    test('flips _isRunning off and cancels in-flight token if any', () {
      when(() => repository.getNextQueuedJob()).thenAnswer((_) async => null);
      service.stop();
      // No exception thrown; calling start() again should still be allowed.
      service.start();
      service.stop();
    });
  });
}
