import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/services/android_auto_player_service.dart';
import 'package:jrr_f/features/player/services/jrr_audio_handler.dart';
import 'package:jrr_f/features/player/services/local_player_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

class MockLocalPlayer extends Mock implements LocalPlayerService {}

class MockAutoPlayer extends Mock implements AndroidAutoPlayerService {}

class FakeMediaItem extends Fake implements MediaItem {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMediaItem());
    registerFallbackValue(MediaButton.media);
    registerFallbackValue(Duration.zero);
    registerFallbackValue(AudioServiceRepeatMode.none);
    registerFallbackValue(AudioServiceShuffleMode.none);
    registerFallbackValue(Uri());
  });

  late MockLocalPlayer localPlayer;
  late MockAutoPlayer autoPlayer;
  late JrrAudioHandler handler;

  late BehaviorSubject<PlaybackState> localPlayback;
  late BehaviorSubject<MediaItem?> localMedia;
  late BehaviorSubject<List<MediaItem>> localQueue;
  late BehaviorSubject<PlaybackState> autoPlayback;
  late BehaviorSubject<MediaItem?> autoMedia;
  late BehaviorSubject<List<MediaItem>> autoQueue;

  setUp(() {
    localPlayer = MockLocalPlayer();
    autoPlayer = MockAutoPlayer();
    localPlayback = BehaviorSubject<PlaybackState>.seeded(PlaybackState());
    localMedia = BehaviorSubject<MediaItem?>.seeded(null);
    localQueue = BehaviorSubject<List<MediaItem>>.seeded(const []);
    autoPlayback = BehaviorSubject<PlaybackState>.seeded(PlaybackState());
    autoMedia = BehaviorSubject<MediaItem?>.seeded(null);
    autoQueue = BehaviorSubject<List<MediaItem>>.seeded(const []);

    // BaseAudioHandler exposes these as streams — mocktail rejects
    // `thenReturn` on Stream-typed getters, so use `thenAnswer`.
    when(() => localPlayer.playbackState).thenAnswer((_) => localPlayback);
    when(() => localPlayer.mediaItem).thenAnswer((_) => localMedia);
    when(() => localPlayer.queue).thenAnswer((_) => localQueue);
    when(() => autoPlayer.playbackState).thenAnswer((_) => autoPlayback);
    when(() => autoPlayer.mediaItem).thenAnswer((_) => autoMedia);
    when(() => autoPlayer.queue).thenAnswer((_) => autoQueue);

    handler = JrrAudioHandler(localPlayer: localPlayer, autoPlayer: autoPlayer);
  });

  tearDown(() async {
    await localPlayback.close();
    await localMedia.close();
    await localQueue.close();
    await autoPlayback.close();
    await autoMedia.close();
    await autoQueue.close();
  });

  group('activePlayer', () {
    test('starts with local player active', () {
      expect(handler.activePlayer, same(localPlayer));
    });

    test('switchTo flips the active player', () {
      when(() => localPlayer.playing).thenReturn(false);
      handler.switchTo(autoPlayer);
      expect(handler.activePlayer, same(autoPlayer));
    });

    test('switchTo is a no-op when target is already active', () {
      when(() => localPlayer.playing).thenReturn(false);
      handler.switchTo(localPlayer);
      expect(handler.activePlayer, same(localPlayer));
      verifyNever(() => localPlayer.pause());
    });

    test('switchTo pauses the previous local player when it was playing', () {
      when(() => localPlayer.playing).thenReturn(true);
      when(() => localPlayer.pause()).thenAnswer((_) async {});
      handler.switchTo(autoPlayer);
      verify(() => localPlayer.pause()).called(1);
    });

    test('switchTo skips pause when previous player was not playing', () {
      when(() => localPlayer.playing).thenReturn(false);
      handler.switchTo(autoPlayer);
      verifyNever(() => localPlayer.pause());
    });
  });

  group('transport delegation', () {
    test('play/pause/stop forward to the active player', () async {
      when(() => localPlayer.play()).thenAnswer((_) async {});
      when(() => localPlayer.pause()).thenAnswer((_) async {});
      when(() => localPlayer.stop()).thenAnswer((_) async {});

      await handler.play();
      await handler.pause();
      await handler.stop();

      verify(() => localPlayer.play()).called(1);
      verify(() => localPlayer.pause()).called(1);
      verify(() => localPlayer.stop()).called(1);
    });

    test('skipToNext/skipToPrevious/seek/skipToQueueItem forward', () async {
      when(() => localPlayer.skipToNext()).thenAnswer((_) async {});
      when(() => localPlayer.skipToPrevious()).thenAnswer((_) async {});
      when(() => localPlayer.seek(any())).thenAnswer((_) async {});
      when(() => localPlayer.skipToQueueItem(any())).thenAnswer((_) async {});

      await handler.skipToNext();
      await handler.skipToPrevious();
      await handler.seek(const Duration(seconds: 30));
      await handler.skipToQueueItem(5);

      verify(() => localPlayer.skipToNext()).called(1);
      verify(() => localPlayer.skipToPrevious()).called(1);
      verify(() => localPlayer.seek(const Duration(seconds: 30))).called(1);
      verify(() => localPlayer.skipToQueueItem(5)).called(1);
    });

    test('shuffle/repeat/speed delegate', () async {
      when(() => localPlayer.setRepeatMode(any())).thenAnswer((_) async {});
      when(() => localPlayer.setShuffleMode(any())).thenAnswer((_) async {});
      when(() => localPlayer.setSpeed(any())).thenAnswer((_) async {});

      await handler.setRepeatMode(AudioServiceRepeatMode.one);
      await handler.setShuffleMode(AudioServiceShuffleMode.all);
      await handler.setSpeed(1.5);

      verify(
        () => localPlayer.setRepeatMode(AudioServiceRepeatMode.one),
      ).called(1);
      verify(
        () => localPlayer.setShuffleMode(AudioServiceShuffleMode.all),
      ).called(1);
      verify(() => localPlayer.setSpeed(1.5)).called(1);
    });

    test('click/prepare/fastForward/rewind/customAction delegate', () async {
      when(() => localPlayer.click(any())).thenAnswer((_) async {});
      when(() => localPlayer.prepare()).thenAnswer((_) async {});
      when(() => localPlayer.fastForward()).thenAnswer((_) async {});
      when(() => localPlayer.rewind()).thenAnswer((_) async {});
      when(
        () => localPlayer.customAction(any(), any()),
      ).thenAnswer((_) async {});
      when(() => localPlayer.onTaskRemoved()).thenAnswer((_) async {});
      when(() => localPlayer.onNotificationDeleted()).thenAnswer((_) async {});

      await handler.click();
      await handler.prepare();
      await handler.fastForward();
      await handler.rewind();
      await handler.customAction('x', {'a': 1});
      await handler.onTaskRemoved();
      await handler.onNotificationDeleted();

      verify(() => localPlayer.click(MediaButton.media)).called(1);
      verify(() => localPlayer.prepare()).called(1);
      verify(() => localPlayer.fastForward()).called(1);
      verify(() => localPlayer.rewind()).called(1);
      verify(() => localPlayer.customAction('x', {'a': 1})).called(1);
      verify(() => localPlayer.onTaskRemoved()).called(1);
      verify(() => localPlayer.onNotificationDeleted()).called(1);
    });

    test('queue management delegates', () async {
      const item = MediaItem(id: 'a', title: 'A');
      when(() => localPlayer.addQueueItem(any())).thenAnswer((_) async {});
      when(() => localPlayer.addQueueItems(any())).thenAnswer((_) async {});
      when(
        () => localPlayer.insertQueueItem(any(), any()),
      ).thenAnswer((_) async {});
      when(() => localPlayer.updateQueue(any())).thenAnswer((_) async {});
      when(() => localPlayer.updateMediaItem(any())).thenAnswer((_) async {});
      when(() => localPlayer.removeQueueItem(any())).thenAnswer((_) async {});
      when(() => localPlayer.removeQueueItemAt(any())).thenAnswer((_) async {});

      await handler.addQueueItem(item);
      await handler.addQueueItems([item]);
      await handler.insertQueueItem(0, item);
      await handler.updateQueue([item]);
      await handler.updateMediaItem(item);
      await handler.removeQueueItem(item);
      await handler.removeQueueItemAt(0);

      verify(() => localPlayer.addQueueItem(item)).called(1);
      verify(() => localPlayer.addQueueItems([item])).called(1);
      verify(() => localPlayer.insertQueueItem(0, item)).called(1);
      verify(() => localPlayer.updateQueue([item])).called(1);
      verify(() => localPlayer.updateMediaItem(item)).called(1);
      verify(() => localPlayer.removeQueueItem(item)).called(1);
      verify(() => localPlayer.removeQueueItemAt(0)).called(1);
    });
  });

  group('MediaBrowser overrides', () {
    test(
      'getChildren / getMediaItem / search always route to autoPlayer',
      () async {
        when(
          () => autoPlayer.getChildren(any(), any()),
        ).thenAnswer((_) async => const []);
        when(
          () => autoPlayer.getMediaItem(any()),
        ).thenAnswer((_) async => null);
        when(
          () => autoPlayer.search(any(), any()),
        ).thenAnswer((_) async => const []);

        await handler.getChildren('root');
        await handler.getMediaItem('id');
        await handler.search('q');

        verify(() => autoPlayer.getChildren('root', null)).called(1);
        verify(() => autoPlayer.getMediaItem('id')).called(1);
        verify(() => autoPlayer.search('q', null)).called(1);
      },
    );

    test('subscribeToChildren returns the auto player stream', () {
      final stream = BehaviorSubject<Map<String, dynamic>>.seeded(const {});
      when(
        () => autoPlayer.subscribeToChildren(any()),
      ).thenAnswer((_) => stream);
      expect(handler.subscribeToChildren('root'), same(stream));
    });

    test(
      'playFromMediaId / playFromSearch / playFromUri switch to auto',
      () async {
        when(() => localPlayer.playing).thenReturn(false);
        when(
          () => autoPlayer.playFromMediaId(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => autoPlayer.playFromSearch(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => autoPlayer.playFromUri(any(), any()),
        ).thenAnswer((_) async {});

        await handler.playFromMediaId('x');
        expect(handler.activePlayer, same(autoPlayer));

        handler.switchTo(localPlayer, pausePrevious: false);
        await handler.playFromSearch('q');
        expect(handler.activePlayer, same(autoPlayer));

        handler.switchTo(localPlayer, pausePrevious: false);
        await handler.playFromUri(Uri.parse('content://x'));
        expect(handler.activePlayer, same(autoPlayer));
      },
    );

    test(
      'prepareFromMediaId / prepareFromSearch / prepareFromUri switch',
      () async {
        when(() => localPlayer.playing).thenReturn(false);
        when(
          () => autoPlayer.prepareFromMediaId(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => autoPlayer.prepareFromSearch(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => autoPlayer.prepareFromUri(any(), any()),
        ).thenAnswer((_) async {});

        await handler.prepareFromMediaId('x');
        expect(handler.activePlayer, same(autoPlayer));

        handler.switchTo(localPlayer, pausePrevious: false);
        await handler.prepareFromSearch('q');
        expect(handler.activePlayer, same(autoPlayer));

        handler.switchTo(localPlayer, pausePrevious: false);
        await handler.prepareFromUri(Uri.parse('content://x'));
        expect(handler.activePlayer, same(autoPlayer));
      },
    );
  });
}
