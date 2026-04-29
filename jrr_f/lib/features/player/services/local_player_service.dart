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

  Future<void> playNow(Track track) async {
    _talker.info('[LocalPlayerService] playNow: $track');

    final source = _createSource(track);

    try {
      _talker.debug('[LocalPlayerService] Setting audio source...');
      await _player.setAudioSource(source, preload: true);
      _talker.debug('[LocalPlayerService] Starting playback...');
      await _player.play();
    } catch (e, st) {
      _talker.error(
        '[LocalPlayerService] ERROR during setAudioSource or play',
        e,
        st,
      );
    }
  }

  // Transport commands
  Future<void> playPause() async {
    if (_player.playing) {
      _talker.debug('[LocalPlayerService] Pausing');
      await _player.pause();
    } else {
      _talker.debug('[LocalPlayerService] Playing. Audiosource: ${_player.audioSource}, sequence length: ${_player.sequence.length}');
      await _player.play();
    }
  }

  Future<void> stop() async {
    _talker.debug('[LocalPlayerService] Stopping');
    await _player.stop();
  }
  
  Future<void> seekTo(int positionMs, {int? index}) async {
    _talker.debug('[LocalPlayerService] Seek to $positionMs ms (index: $index)');
    await _player.seek(Duration(milliseconds: positionMs), index: index);
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

    var url = baseUrl;
    if (!url.endsWith('/')) url += '/';
    url += 'File/GetFile?File=${track.fileKey}&FileType=Key&Playback=1';
    if (token != null) {
      url += '&Token=$token';
    }

    _talker.debug('[LocalPlayerService] Created source for track ${track.fileKey}: $url');

    return AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {
        'User-Agent': 'JRR-Remote/1.0',
        'X-MCWS-Token': ?token,
      },
    );
  }
}
