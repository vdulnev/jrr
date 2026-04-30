import 'dart:async';
import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/mcws_client.dart';
import '../../connection/data/repositories/connection_repository.dart';
import '../../library/data/models/track.dart';

class LocalPlayerService {
  final AudioPlayer _player;
  final Talker _talker;

  LocalPlayerService({required AudioPlayer player, required Talker talker})
    : _player = player,
      _talker = talker;

  Future<void> init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      await session.setActive(true);
      _talker.info('[LocalPlayerService] AudioSession initialized and active');
    } catch (e, st) {
      _talker.error('[LocalPlayerService] Failed to init AudioSession', e, st);
    }
  }

  // State Getters
  SequenceState? get sequenceState => _player.sequenceState;
  ProcessingState get processingState => _player.processingState;
  bool get playing => _player.playing;
  Duration get position => _player.position;
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;
  LoopMode get loopMode => _player.loopMode;
  List<IndexedAudioSource> get sequence => _player.sequence;

  // Streams for observation
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Stream<PlaybackEvent> get playbackEventStream => _player.playbackEventStream;
  Stream<double> get volumeStream => _player.volumeStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> setTracks(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] setTracks: ${tracks.length} tracks');
    final sources = tracks.map((t) => _createSource(t)).toList();

    try {
      _talker.info(
        '[LocalPlayerService] Calling setAudioSource (preload=true)...',
      );
      await _player.setAudioSources(sources, preload: true);
      _talker.info(
        '[LocalPlayerService] setAudioSource COMPLETED. Current sequence length: ${_player.sequence.length}',
      );
    } catch (e, st) {
      _talker.error('[LocalPlayerService] ERROR during setAudioSource', e, st);
    }
  }

  Future<void> playNow(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] playNow: ${tracks.length} tracks');
    await setTracks(tracks);
    await play();
  }

  // Transport commands
  Future<void> playPause() async {
    if (_player.playing) {
      _talker.debug('[LocalPlayerService] Pausing');
      await pause();
    } else {
      _talker.debug(
        '[LocalPlayerService] Playing. Audiosource: ${_player.audioSource}, sequence length: ${_player.sequence.length}',
      );
      await play();
    }
  }

  Future<void> play() async {
    _talker.debug('[LocalPlayerService] Playing');
    await _player.play();
  }

  Future<void> pause() async {
    _talker.debug('[LocalPlayerService] Pausing');
    await _player.pause();
  }

  Future<void> stop() async {
    _talker.debug('[LocalPlayerService] Stopping');
    await _player.stop();
  }

  Future<void> seekTo(int positionMs, {int? index}) async {
    _talker.debug(
      '[LocalPlayerService] Seek to $positionMs ms (index: $index)',
    );
    await _player.seek(Duration(milliseconds: positionMs), index: index);
  }

  Future<void> playNext(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] playNext: ${tracks.length} tracks');
    final currentIndex = _player.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await _player.insertAudioSources(
      insertIndex,
      tracks.map((t) => _createSource(t)).toList(),
    );
  }

  Future<void> addToQueue(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] addToQueue: ${tracks.length} tracks');
    await _player.addAudioSources(tracks.map((t) => _createSource(t)).toList());
  }

  Future<void> setVolume(double level) async {
    _talker.debug('[LocalPlayerService] Setting volume to $level');
    await _player.setVolume(level);
  }

  Future<void> setMute(bool mute) async {
    _talker.debug('[LocalPlayerService] Setting mute: $mute');
    await _player.setVolume(mute ? 0 : 1.0);
  }

  AudioSource _createSource(Track track) {
    final client = getIt<McwsClient>();
    final repo = getIt<ConnectionRepository>();
    final baseUrl = client.baseUrl;
    final token = repo.currentToken;

    // Build URL manually to be 100% sure of the format
    // baseUrl usually ends with /MCWS/v1/
    var url = baseUrl;
    if (!url.endsWith('/')) url += '/';
    url += 'File/GetFile?File=${track.fileKey}&FileType=Key&Playback=1&Conversion=wav&Quality=high';
    if (token != null) {
      url += '&Token=$token';
    }

    _talker.debug(
      '[LocalPlayerService] Created source for track ${track.fileKey}: $url',
    );

    final AudioSource source;

    final uriAudioSource = AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {'User-Agent': 'JRR-Remote/1.0', 'X-MCWS-Token': ?token},
    );

    final playbackRange = _parsePlaybackRange(track.playbackRange);

    if (playbackRange != null) {
      final end = playbackRange.end == Duration.zero ? null : playbackRange.end;
      final clippingAudioSource = ClippingAudioSource(
        child: uriAudioSource,
        start: playbackRange.start,
        end: end,
        duration: Duration(milliseconds: (track.duration * 1000.0).round()),
        tag: track,
      );
      source = clippingAudioSource;
      _talker.debug(
        '[LocalPlayerService] Wrapped source in ClippingAudioSource: start=${playbackRange.start}, end=$end',
      );
    } else {
      source = uriAudioSource;
      _talker.debug(
        '[LocalPlayerService] No valid playback range, using UriAudioSource directly',
      );
    }

    return source;
  }

  ({Duration start, Duration end})? _parsePlaybackRange(String input) {
    final parts = input.split('-');

    if (parts.length != 2) {
      _talker.debug(
        '[LocalPlayerService] Invalid playback range format ("$input")',
      );
      return null; // Invalid format
    }

    // Parse as doubles to handle fractional milliseconds (e.g. .333333)
    final startMs = double.tryParse(parts[0]);
    final endMs = double.tryParse(parts[1]);

    if (startMs == null || endMs == null) {
      _talker.debug(
        '[LocalPlayerService] Invalid playback range format ("$input")',
      );
      return null; // Invalid numbers
    }

    // Convert milliseconds to microseconds to preserve the fractional precision
    _talker.debug(
      '[LocalPlayerService] Parsed playback range: start=${startMs}ms, end=${endMs}ms',
    );
    return (
      start: Duration(microseconds: (startMs * 1000).round()),
      end: Duration(microseconds: (endMs * 1000).round()),
    );
  }

  void next() {
    _talker.debug('[LocalPlayerService] Command: next');
    _player.seekToNext();
  }

  void previous() {
    _talker.debug('[LocalPlayerService] Command: previous');
    _player.seekToPrevious();
  }

  Future<void> playByIndex({required int index}) async {
    _talker.debug('[LocalPlayerService] Command: playByIndex ($index)');
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  void insertTracksAt(List<Track> tracks) {
    final index = (_player.currentIndex ?? 0);
    _talker.debug(
      '[LocalPlayerService] insertTracksAt: ${tracks.length} tracks at index $index',
    );
    _player.audioSources.insertAll(
      index,
      tracks.map((t) => _createSource(t)).toList(),
    );
  }
}
