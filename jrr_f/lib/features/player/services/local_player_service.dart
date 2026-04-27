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

  Future<void> playNow(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] playNow: ${tracks.length} tracks');
    if (tracks.isEmpty) return;

    // Log the first track specifically
    _talker.info(
      '[LocalPlayerService] First track: ${tracks.first.name} (Key: ${tracks.first.fileKey})',
    );

    final sources = tracks.map((t) => _createSource(t)).toList();
    final playlist = ConcatenatingAudioSource(children: sources);

    try {
      _talker.info(
        '[LocalPlayerService] Calling setAudioSource (preload=true)...',
      );
      await _player.setAudioSource(playlist, preload: true);
      _talker.info(
        '[LocalPlayerService] setAudioSource COMPLETED. Current sequence length: ${_player.sequence.length}',
      );

      _talker.info('[LocalPlayerService] Calling play()...');
      // ignore: unawaited_futures
      _player.play();
      _talker.info('[LocalPlayerService] play() called.');
    } catch (e, st) {
      _talker.error(
        '[LocalPlayerService] ERROR during setAudioSource or play',
        e,
        st,
      );
    }
  }

  Future<void> playNext(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] playNext: ${tracks.length} tracks');
    final playlist = _player.audioSource as ConcatenatingAudioSource?;
    if (playlist == null) {
      await playNow(tracks);
      return;
    }
    final currentIndex = _player.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await playlist.insertAll(
      insertIndex,
      tracks.map((t) => _createSource(t)).toList(),
    );
  }

  Future<void> addToQueue(List<Track> tracks) async {
    _talker.info('[LocalPlayerService] addToQueue: ${tracks.length} tracks');
    final playlist = _player.audioSource as ConcatenatingAudioSource?;
    if (playlist == null) {
      await playNow(tracks);
      return;
    }
    await playlist.addAll(tracks.map((t) => _createSource(t)).toList());
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
    url += 'File/GetFile?File=${track.fileKey}&FileType=Key';
    if (token != null) {
      url += '&Token=$token';
    }

    _talker.info('[LocalPlayerService] Source URL: $url');

    return AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {
        'User-Agent': 'JRR-Remote/1.0',
        if (token != null) 'X-MCWS-Token': token,
      },
    );
  }
}
