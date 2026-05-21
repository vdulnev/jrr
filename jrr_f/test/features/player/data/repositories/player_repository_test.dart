import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/data/models/player_status.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/player/data/repositories/player_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockMcwsClient extends Mock implements McwsClient {}

void main() {
  late MockMcwsClient client;
  late PlayerRepositoryImpl repo;

  setUp(() {
    client = MockMcwsClient();
    repo = PlayerRepositoryImpl(client: () => client);
  });

  PlayerStatus stoppedStatus() => const PlayerStatus(
    zoneId: 'z',
    zoneName: 'Z',
    state: PlaybackState.stopped,
    positionMs: 0,
    durationMs: 0,
    positionDisplay: '0:00',
    playingNowPosition: 0,
    playingNowTracks: 0,
    playingNowPositionDisplay: '0/0',
    playingNowChangeCounter: 0,
    volume: 0,
    volumeDisplay: '0',
  );

  test('getPlaybackInfo delegates', () async {
    final status = stoppedStatus();
    when(
      () => client.getPlaybackInfo('z'),
    ).thenAnswer((_) async => right(status));
    final result = await repo.getPlaybackInfo('z');
    expect(result.getOrElse((_) => stoppedStatus()), status);
  });

  test('playPause delegates', () async {
    when(() => client.playPause('z')).thenAnswer((_) async => right(unit));
    expect((await repo.playPause('z')).isRight(), isTrue);
  });

  test('stop, next, previous delegate', () async {
    when(() => client.stop('z')).thenAnswer((_) async => right(unit));
    when(() => client.next('z')).thenAnswer((_) async => right(unit));
    when(() => client.previous('z')).thenAnswer((_) async => right(unit));
    await repo.stop('z');
    await repo.next('z');
    await repo.previous('z');
    verify(() => client.stop('z')).called(1);
    verify(() => client.next('z')).called(1);
    verify(() => client.previous('z')).called(1);
  });

  test('setPosition forwards positionMs', () async {
    when(
      () => client.setPosition('z', 5000),
    ).thenAnswer((_) async => right(unit));
    await repo.setPosition('z', 5000);
    verify(() => client.setPosition('z', 5000)).called(1);
  });

  test('setVolume forwards level', () async {
    when(
      () => client.setVolume('z', 0.75),
    ).thenAnswer((_) async => right(unit));
    await repo.setVolume('z', 0.75);
    verify(() => client.setVolume('z', 0.75)).called(1);
  });

  test('setMute forwards flag', () async {
    when(
      () => client.setMute('z', mute: true),
    ).thenAnswer((_) async => right(unit));
    when(
      () => client.setMute('z', mute: false),
    ).thenAnswer((_) async => right(unit));
    await repo.setMute('z', mute: true);
    await repo.setMute('z', mute: false);
    verify(() => client.setMute('z', mute: true)).called(1);
    verify(() => client.setMute('z', mute: false)).called(1);
  });

  test('setShuffle forwards mode', () async {
    when(
      () => client.setShuffle('z', ShuffleMode.on),
    ).thenAnswer((_) async => right(unit));
    await repo.setShuffle('z', ShuffleMode.on);
    verify(() => client.setShuffle('z', ShuffleMode.on)).called(1);
  });

  test('setRepeat forwards mode', () async {
    when(
      () => client.setRepeat('z', RepeatMode.track),
    ).thenAnswer((_) async => right(unit));
    await repo.setRepeat('z', RepeatMode.track);
    verify(() => client.setRepeat('z', RepeatMode.track)).called(1);
  });

  test('playByIndex forwards index', () async {
    when(() => client.playByIndex('z', 4)).thenAnswer((_) async => right(unit));
    await repo.playByIndex('z', 4);
    verify(() => client.playByIndex('z', 4)).called(1);
  });
}
