import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/providers/library_providers.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/player/providers/now_playing_view_model.dart';
import 'package:jrr_f/features/player/providers/player_polling_provider.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';
import 'package:talker/talker.dart';

import '../../../setup/test_player.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  ProviderContainer open({
    TestPlayer? player,
    Zone? activeZone,
    Track? trackForFileKey,
  }) {
    final container = ProviderContainer(
      overrides: [
        playerProvider.overrideWith(() => player ?? TestPlayer()),
        // PlayerPolling is keepAlive and reads talker; stub the body so the
        // view-model's `ref.watch(playerPollingProvider)` resolves cleanly.
        talkerProvider.overrideWithValue(Talker()),
        appDatabaseProvider.overrideWithValue(
          AppDatabase(NativeDatabase.memory()),
        ),
        playerPollingProvider.overrideWith(() => _NoopPolling()),
        sessionProvider.overrideWith(() => _UnauthSession()),
        if (activeZone != null)
          activeZoneProvider.overrideWith(() => _StaticActiveZone(activeZone)),
        if (trackForFileKey != null)
          searchByFileKeyProvider(
            trackForFileKey.fileKey,
          ).overrideWith((ref) async => trackForFileKey),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('falls back to defaults when no status is available', () async {
    final c = open();
    await c.read(playerProvider.future);
    final s = c.read(nowPlayingViewModelProvider);
    expect(s.activeZone, isNull);
    expect(s.fileKey, -1);
    expect(s.track, isNull);
    expect(s.name, isEmpty);
    expect(s.artist, isEmpty);
    expect(s.isPlaying, isFalse);
    expect(s.repeatMode, RepeatMode.off);
    expect(s.shuffleMode, ShuffleMode.off);
    expect(s.hasTrack, isFalse);
  });

  test('hasTrack is true when zone and fileKey are present', () async {
    const zone = Zone(id: 'a', name: 'A', guid: 'g', isDLNA: false);
    const track = Track(
      fileKey: 5,
      name: 'Hello',
      bitDepth: 24,
      sampleRate: 96000,
      fileType: 'flac',
    );
    final status = stoppedStatus(
      state: PlaybackState.playing,
      fileKey: 5,
      name: 'Hello',
      artist: 'World',
      album: 'Album',
    );
    final c = open(
      player: TestPlayer(status: status),
      activeZone: zone,
      trackForFileKey: track,
    );
    await c.read(playerProvider.future);
    // Let the FutureProvider for searchByFileKey resolve.
    await c.read(searchByFileKeyProvider(5).future);
    final s = c.read(nowPlayingViewModelProvider);
    expect(s.activeZone, zone);
    expect(s.fileKey, 5);
    expect(s.track, track);
    expect(s.hasTrack, isTrue);
    expect(s.isPlaying, isTrue);
    expect(s.name, 'Hello');
    expect(s.artist, 'World');
    expect(s.album, 'Album');
    expect(s.fileType, 'flac');
    expect(s.bitDepth, 24);
    expect(s.sampleRate, 96000);
  });

  test('action methods forward to player notifier', () async {
    final c = open(player: TestPlayer());
    await c.read(playerProvider.future);
    final vm = c.read(nowPlayingViewModelProvider.notifier);

    vm.playPause();
    vm.next();
    vm.previous();
    vm.seekTo(123);
    vm.setVolume(0.3);
    vm.toggleMute();
    vm.cycleRepeat();
    vm.toggleShuffle();

    final player = c.read(playerProvider.notifier) as TestPlayer;
    expect(player.calls, [
      'playPause',
      'next',
      'previous',
      'seekTo:123',
      'setVolume:0.3',
      'toggleMute',
      'cycleRepeat',
      'toggleShuffle',
    ]);
  });
}

class _NoopPolling extends PlayerPolling {
  @override
  void build() {
    // Skip the real polling wiring.
  }
}

class _StaticActiveZone extends ActiveZone {
  _StaticActiveZone(this._zone);
  final Zone _zone;
  @override
  Zone? build() => _zone;
}

class _UnauthSession extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}
