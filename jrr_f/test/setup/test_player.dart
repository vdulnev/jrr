import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/player/data/models/playback_state.dart';
import 'package:jrr_f/features/player/data/models/player_status.dart';
import 'package:jrr_f/features/player/providers/player_provider.dart';
import 'package:jrr_f/features/zones/data/models/zone.dart';

/// Test double that bypasses the per-zone dispatch chain and just emits a
/// fixed [PlayerStatus]. Use via:
///
///   playerProvider.overrideWith(() => TestPlayer(status: stoppedStatus()))
class TestPlayer extends Player {
  TestPlayer({PlayerStatus? status}) : _status = status;

  final PlayerStatus? _status;

  /// Tracks methods invoked on this notifier so tests can verify command
  /// dispatch without wiring up the full Player → local/mcws chain.
  final List<String> calls = <String>[];

  @override
  Future<PlayerStatus?> build() async => _status;

  @override
  Future<void> refresh() async => calls.add('refresh');
  @override
  Future<void> playPause() async => calls.add('playPause');
  @override
  Future<void> next() async => calls.add('next');
  @override
  Future<void> previous() async => calls.add('previous');
  @override
  Future<void> seekTo(int positionMs) async => calls.add('seekTo:$positionMs');
  @override
  Future<void> setVolume(double level) async => calls.add('setVolume:$level');
  @override
  Future<void> toggleMute() async => calls.add('toggleMute');
  @override
  Future<void> toggleShuffle() async => calls.add('toggleShuffle');
  @override
  Future<void> playByIndex(int index) async => calls.add('playByIndex:$index');
  @override
  Future<void> cycleRepeat() async => calls.add('cycleRepeat');
  @override
  Future<void> playNow(Tracks tracks) async =>
      calls.add('playNow:${tracks.length}');
  @override
  Future<void> playNext(Tracks tracks) async =>
      calls.add('playNext:${tracks.length}');
  @override
  Future<void> addToQueue(Tracks tracks) async =>
      calls.add('addToQueue:${tracks.length}');
  @override
  Future<void> stop({Zone? zoneToRun}) async =>
      calls.add('stop:${zoneToRun?.id ?? ''}');
}

/// Builds a stopped [PlayerStatus] with sensible defaults; pass overrides
/// to seed the slice of state under test.
PlayerStatus stoppedStatus({
  String zoneId = 'z',
  String zoneName = 'Zone',
  PlaybackState state = PlaybackState.stopped,
  int fileKey = -1,
  String name = '',
  String artist = '',
  String album = '',
  int positionMs = 0,
  int durationMs = 0,
  double volume = 0.0,
  bool isMuted = false,
  int playingNowPosition = 0,
  int playingNowTracks = 0,
  int playingNowChangeCounter = 0,
}) => PlayerStatus(
  zoneId: zoneId,
  zoneName: zoneName,
  state: state,
  fileKey: fileKey,
  name: name,
  artist: artist,
  album: album,
  positionMs: positionMs,
  durationMs: durationMs,
  positionDisplay: '',
  playingNowPosition: playingNowPosition,
  playingNowTracks: playingNowTracks,
  playingNowPositionDisplay: '$playingNowPosition/$playingNowTracks',
  playingNowChangeCounter: playingNowChangeCounter,
  volume: volume,
  volumeDisplay: '',
  isMuted: isMuted,
);
