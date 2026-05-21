import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/offline/data/repositories/downloads_repository.dart';
import 'package:jrr_f/features/player/data/models/local_audio_quality.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/player/data/repositories/recently_played_repository.dart';
import 'package:jrr_f/features/player/services/local_player_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockDownloadsRepo extends Mock implements DownloadsRepository {}

class MockConnectionRepo extends Mock implements ConnectionRepository {}

class MockRecentlyPlayed extends Mock implements RecentlyPlayedRepository {}

class MockMcwsClient extends Mock implements McwsClient {}

class FakeAudioSource extends Fake implements AudioSource {}

class FakeDuration extends Fake implements Duration {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAudioSource());
    registerFallbackValue(<AudioSource>[]);
    registerFallbackValue(Duration.zero);
    registerFallbackValue(AudioServiceRepeatMode.none);
    registerFallbackValue(AudioServiceShuffleMode.none);
    registerFallbackValue(LoopMode.off);
  });

  late MockAudioPlayer player;
  late MockDownloadsRepo downloadsRepo;
  late MockConnectionRepo connectionRepo;
  late MockRecentlyPlayed recentlyPlayed;
  late MockMcwsClient client;
  late LocalPlayerService service;

  setUp(() {
    player = MockAudioPlayer();
    downloadsRepo = MockDownloadsRepo();
    connectionRepo = MockConnectionRepo();
    recentlyPlayed = MockRecentlyPlayed();
    client = MockMcwsClient();

    // Stub streams the constructor subscribes to.
    when(
      () => player.playbackEventStream,
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => player.sequenceStateStream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => player.playing).thenReturn(false);
    when(() => player.processingState).thenReturn(ProcessingState.idle);
    when(() => player.position).thenReturn(Duration.zero);
    when(() => player.bufferedPosition).thenReturn(Duration.zero);
    when(() => player.speed).thenReturn(1.0);
    when(() => player.currentIndex).thenReturn(null);
    when(() => player.sequence).thenReturn(const []);

    // Default no local file mapping; remote URL path will be exercised.
    when(() => downloadsRepo.localPathFor(any())).thenReturn(null);
    when(() => client.baseUrl).thenReturn('http://h:52199/MCWS/v1/');
    when(() => connectionRepo.currentToken).thenReturn('tok-123');

    service = LocalPlayerService(
      player: player,
      talker: Talker(),
      downloadsRepo: downloadsRepo,
      connectionRepo: connectionRepo,
      recentlyPlayedRepo: recentlyPlayed,
      mcwsClientResolver: () => client,
    );
  });

  group('state forwarding getters', () {
    test('processingState, playing, position, sequence forward to player', () {
      expect(service.processingState, ProcessingState.idle);
      expect(service.playing, isFalse);
      expect(service.position, Duration.zero);
      expect(service.sequence, isEmpty);
    });
  });

  group('transport methods delegate to AudioPlayer', () {
    test('seek and seekTo forward to player.seek', () async {
      when(
        () => player.seek(any(), index: any(named: 'index')),
      ).thenAnswer((_) async {});
      await service.seek(const Duration(seconds: 30));
      await service.seekTo(1500, index: 2);
      verify(() => player.seek(const Duration(seconds: 30))).called(1);
      verify(
        () => player.seek(const Duration(milliseconds: 1500), index: 2),
      ).called(1);
    });

    test('skipToNext / skipToPrevious / next / previous', () async {
      when(() => player.seekToNext()).thenAnswer((_) async {});
      when(() => player.seekToPrevious()).thenAnswer((_) async {});
      await service.skipToNext();
      await service.skipToPrevious();
      service.next();
      service.previous();
      verify(() => player.seekToNext()).called(2);
      verify(() => player.seekToPrevious()).called(2);
    });

    test('pause delegates and emits playbackState', () async {
      when(() => player.pause()).thenAnswer((_) async {});
      await service.pause();
      verify(() => player.pause()).called(1);
    });

    test('stop delegates', () async {
      when(() => player.stop()).thenAnswer((_) async {});
      await service.stop();
      verify(() => player.stop()).called(1);
    });

    test('setVolume / setMute set the player volume', () async {
      when(() => player.setVolume(any())).thenAnswer((_) async {});
      await service.setVolume(0.5);
      await service.setMute(true);
      await service.setMute(false);
      verify(() => player.setVolume(0.5)).called(1);
      verify(() => player.setVolume(0)).called(1);
      verify(() => player.setVolume(1.0)).called(1);
    });

    test('moveTrack / removeTrack / insertTracksAt / addToQueue', () async {
      when(() => player.moveAudioSource(any(), any())).thenAnswer((_) async {});
      when(() => player.removeAudioSourceAt(any())).thenAnswer((_) async {});
      when(
        () => player.insertAudioSources(any(), any()),
      ).thenAnswer((_) async {});
      when(() => player.addAudioSources(any())).thenAnswer((_) async {});

      await service.moveTrack(0, 2);
      await service.removeTrack(3);
      await service.insertTracksAt(
        tracks: Tracks.fromList(const [Track(fileKey: 1)]),
        index: 0,
      );
      await service.addToQueue(Tracks.fromList(const [Track(fileKey: 2)]));

      verify(() => player.moveAudioSource(0, 2)).called(1);
      verify(() => player.removeAudioSourceAt(3)).called(1);
      verify(() => player.insertAudioSources(0, any())).called(1);
      verify(() => player.addAudioSources(any())).called(1);
    });

    test('playNext inserts after the current index', () async {
      when(() => player.currentIndex).thenReturn(2);
      when(
        () => player.insertAudioSources(any(), any()),
      ).thenAnswer((_) async {});
      await service.playNext(Tracks.fromList(const [Track(fileKey: 9)]));
      verify(() => player.insertAudioSources(3, any())).called(1);
    });

    test('setShuffle maps ShuffleMode→bool', () async {
      when(() => player.setShuffleModeEnabled(any())).thenAnswer((_) async {});
      await service.setShuffle(ShuffleMode.on);
      await service.setShuffle(ShuffleMode.off);
      verify(() => player.setShuffleModeEnabled(true)).called(1);
      verify(() => player.setShuffleModeEnabled(false)).called(1);
    });

    test('setRepeat maps RepeatMode→LoopMode for every case', () async {
      when(() => player.setLoopMode(any())).thenAnswer((_) async {});
      await service.setRepeat(RepeatMode.off);
      await service.setRepeat(RepeatMode.playlist);
      await service.setRepeat(RepeatMode.track);
      verify(() => player.setLoopMode(LoopMode.off)).called(1);
      verify(() => player.setLoopMode(LoopMode.all)).called(1);
      verify(() => player.setLoopMode(LoopMode.one)).called(1);
    });

    test(
      'setShuffleMode (audio_service) maps to setShuffleModeEnabled',
      () async {
        when(
          () => player.setShuffleModeEnabled(any()),
        ).thenAnswer((_) async {});
        await service.setShuffleMode(AudioServiceShuffleMode.all);
        await service.setShuffleMode(AudioServiceShuffleMode.none);
        verify(() => player.setShuffleModeEnabled(true)).called(1);
        verify(() => player.setShuffleModeEnabled(false)).called(1);
      },
    );

    test('setRepeatMode (audio_service) maps every variant', () async {
      when(() => player.setLoopMode(any())).thenAnswer((_) async {});
      await service.setRepeatMode(AudioServiceRepeatMode.none);
      await service.setRepeatMode(AudioServiceRepeatMode.one);
      await service.setRepeatMode(AudioServiceRepeatMode.all);
      await service.setRepeatMode(AudioServiceRepeatMode.group);
      verify(() => player.setLoopMode(LoopMode.off)).called(1);
      verify(() => player.setLoopMode(LoopMode.one)).called(1);
      verify(() => player.setLoopMode(LoopMode.all)).called(2);
    });

    test('playByIndex seeks to zero of that index then plays', () async {
      when(
        () => player.seek(any(), index: any(named: 'index')),
      ).thenAnswer((_) async {});
      when(() => player.play()).thenAnswer((_) async {});
      await service.playByIndex(4);
      verify(() => player.seek(Duration.zero, index: 4)).called(1);
      verify(() => player.play()).called(1);
    });

    test('playPause toggles based on player.playing', () async {
      when(() => player.pause()).thenAnswer((_) async {});
      when(() => player.play()).thenAnswer((_) async {});

      when(() => player.playing).thenReturn(false);
      await service.playPause();
      verify(() => player.play()).called(1);

      when(() => player.playing).thenReturn(true);
      await service.playPause();
      verify(() => player.pause()).called(1);
    });
  });

  group('_createSource via setTracks', () {
    test('builds a remote URI with Conversion, Quality, and Token when '
        'no local file is cached', () async {
      when(
        () => player.setAudioSources(any(), preload: any(named: 'preload')),
      ).thenAnswer((_) async => null);
      when(() => downloadsRepo.localPathFor(42)).thenReturn(null);
      service.qualityResolver = () => LocalAudioQuality.lossyHigh;

      await service.setTracks(Tracks.fromList(const [Track(fileKey: 42)]));

      final captured =
          verify(
                () => player.setAudioSources(captureAny(), preload: true),
              ).captured.single
              as List<AudioSource>;
      expect(captured, hasLength(1));
      final src = captured.single as UriAudioSource;
      final url = src.uri.toString();
      expect(url, contains('File/GetFile?File=42'));
      expect(url, contains('Conversion=opus'));
      expect(url, contains('Quality=high'));
      expect(url, contains('Token=tok-123'));
    });

    test('omits Token when no session token is available', () async {
      when(
        () => player.setAudioSources(any(), preload: any(named: 'preload')),
      ).thenAnswer((_) async => null);
      when(() => downloadsRepo.localPathFor(any())).thenReturn(null);
      when(() => connectionRepo.currentToken).thenReturn(null);

      await service.setTracks(Tracks.fromList(const [Track(fileKey: 1)]));

      final captured =
          verify(
                () => player.setAudioSources(captureAny(), preload: true),
              ).captured.single
              as List<AudioSource>;
      final url = (captured.single as UriAudioSource).uri.toString();
      expect(url, isNot(contains('Token=')));
    });

    test('appends a trailing slash to baseUrl when missing', () async {
      when(() => client.baseUrl).thenReturn('http://h:52199/MCWS/v1');
      when(
        () => player.setAudioSources(any(), preload: any(named: 'preload')),
      ).thenAnswer((_) async => null);
      when(() => downloadsRepo.localPathFor(any())).thenReturn(null);

      await service.setTracks(Tracks.fromList(const [Track(fileKey: 1)]));
      final captured =
          verify(
                () => player.setAudioSources(captureAny(), preload: true),
              ).captured.single
              as List<AudioSource>;
      expect(
        (captured.single as UriAudioSource).uri.toString(),
        startsWith('http://h:52199/MCWS/v1/File/GetFile'),
      );
    });
  });
}
