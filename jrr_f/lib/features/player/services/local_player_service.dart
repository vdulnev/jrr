import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/mcws_client.dart';
import '../../connection/data/repositories/connection_repository.dart';
import '../../library/data/models/track.dart';
import '../../library/data/models/tracks.dart';
import '../../offline/data/repositories/downloads_repository.dart';
import '../../zones/services/android_auto_session_service.dart';
import '../data/models/local_audio_quality.dart';

/// Local playback service that doubles as the `audio_service`
/// [BaseAudioHandler]. It owns the single `just_audio` [AudioPlayer], exposes
/// the familiar transport API used by providers, and forwards just_audio
/// events to the `audio_service` streams (`playbackState`, `mediaItem`,
/// `queue`) so the system media notification, lock-screen controls, and
/// Android Auto see live state.
class LocalPlayerService extends BaseAudioHandler with SeekHandler {
  final AudioPlayer _player;
  final Talker _talker;

  /// Resolves the currently selected audio quality. Read on every
  /// `_createSource` call so changes apply to subsequent track loads.
  LocalAudioQuality Function() qualityResolver;

  LocalPlayerService({
    required AudioPlayer player,
    required Talker talker,
    LocalAudioQuality Function()? qualityResolver,
  }) : _player = player,
       _talker = talker,
       qualityResolver = qualityResolver ?? (() => LocalAudioQuality.lossless) {
    // Seed audio_service with a non-empty PlaybackState BEFORE we start
    // listening to just_audio's async event stream. Without this, the
    // foreground service can be requested (via play()) while
    // `playbackState` is still its default-empty value, audio_service has
    // nothing to render in the notification, and `startForeground()` is
    // never called → Android ANRs the service after 5 seconds.
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.idle),
    );
    _bindPlayerToAudioServiceStreams();
  }

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

  // ───────────── Existing state getters (used by providers) ─────────────
  SequenceState? get sequenceState => _player.sequenceState;
  ProcessingState get processingState => _player.processingState;
  bool get playing => _player.playing;
  Duration get position => _player.position;
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;
  LoopMode get loopMode => _player.loopMode;
  List<IndexedAudioSource> get sequence => _player.sequence;

  // ───────────── Existing just_audio streams (used by providers) ────────
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Stream<PlaybackEvent> get playbackEventStream => _player.playbackEventStream;
  Stream<double> get volumeStream => _player.volumeStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  Future<void> setTracks(Tracks tracks) async {
    _talker.info('[LocalPlayerService] setTracks: ${tracks.length} tracks');
    final sources = tracks.tracks.map((t) => _createSource(t)).toList();

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

  Future<void> playNow(Tracks tracks) async {
    _talker.info('[LocalPlayerService] playNow: ${tracks.length} tracks');
    await setTracks(tracks);
    await play();
  }

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

  // ─── audio_service transport overrides ────────────────────────────────
  // BaseAudioHandler defaults throw UnimplementedError; we route to the
  // underlying just_audio player. These are called from the system
  // notification, lock screen, and (Phase 3+) Android Auto head unit.

  @override
  Future<void> play() async {
    _talker.debug('[LocalPlayerService] Playing');
    // Push playing=true *before* awaiting just_audio. audio_service may
    // call startForegroundService the moment this returns, and it needs a
    // valid PlaybackState AND a non-null MediaItem (for the notification
    // title) to render within 5 seconds, otherwise startForeground() never
    // fires and Android ANRs the foreground service.
    _emitCurrentMediaItem();
    playbackState.add(
      _baseState(playing: true, processing: AudioProcessingState.ready),
    );
    await _player.play();
  }

  @override
  Future<void> pause() async {
    _talker.debug('[LocalPlayerService] Pausing');
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.ready),
    );
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    _talker.debug('[LocalPlayerService] Stopping');
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.idle),
    );
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    _talker.debug('[LocalPlayerService] Seek to ${position.inMilliseconds} ms');
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    _talker.debug('[LocalPlayerService] skipToNext');
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    _talker.debug('[LocalPlayerService] skipToPrevious');
    await _player.seekToPrevious();
  }

  // ─── MediaBrowser callbacks (Android Auto session detection) ──────────
  // Any browse-side ping from Auto reaches the handler through one of
  // these overrides. We mark the AA session active on every call; the
  // session service debounces back to inactive after a timeout. Phase 5
  // will replace the empty bodies with the real browse hierarchy and
  // playFromMediaId routing.

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    _talker.debug('[LocalPlayerService] getChildren: $parentMediaId');
    getIt<AndroidAutoSessionService>().markActive();
    return const [];
  }

  @override
  Future<MediaItem?> getMediaItem(String mediaId) async {
    _talker.debug('[LocalPlayerService] getMediaItem: $mediaId');
    getIt<AndroidAutoSessionService>().markActive();
    return null;
  }

  @override
  Future<List<MediaItem>> search(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.debug('[LocalPlayerService] search: $query');
    getIt<AndroidAutoSessionService>().markActive();
    return const [];
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    await _player.setShuffleModeEnabled(
      shuffleMode != AudioServiceShuffleMode.none,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    final loopMode = switch (repeatMode) {
      AudioServiceRepeatMode.none => LoopMode.off,
      AudioServiceRepeatMode.one => LoopMode.one,
      AudioServiceRepeatMode.all => LoopMode.all,
      AudioServiceRepeatMode.group => LoopMode.all,
    };
    await _player.setLoopMode(loopMode);
  }

  // ─── Legacy seek/transport helpers used by existing providers ─────────
  // Distinct names from the audio_service overrides above.

  Future<void> seekTo(int positionMs, {int? index}) async {
    _talker.debug(
      '[LocalPlayerService] Seek to $positionMs ms (index: $index)',
    );
    await _player.seek(Duration(milliseconds: positionMs), index: index);
  }

  Future<void> playNext(Tracks tracks) async {
    _talker.info('[LocalPlayerService] playNext: ${tracks.length} tracks');
    final currentIndex = _player.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await _player.insertAudioSources(
      insertIndex,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  Future<void> addToQueue(Tracks tracks) async {
    _talker.info('[LocalPlayerService] addToQueue: ${tracks.length} tracks');
    await _player.addAudioSources(
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  Future<void> setVolume(double level) async {
    _talker.debug('[LocalPlayerService] Setting volume to $level');
    await _player.setVolume(level);
  }

  Future<void> setMute(bool mute) async {
    _talker.debug('[LocalPlayerService] Setting mute: $mute');
    await _player.setVolume(mute ? 0 : 1.0);
  }

  void next() {
    _talker.debug('[LocalPlayerService] Command: next');
    _player.seekToNext();
  }

  void previous() {
    _talker.debug('[LocalPlayerService] Command: previous');
    _player.seekToPrevious();
  }

  Future<void> playByIndex(int index) async {
    _talker.debug('[LocalPlayerService] Command: playByIndex ($index)');
    await _player.seek(Duration.zero, index: index);
    // Route through play() so the synchronous playbackState emission runs.
    // Calling _player.play() directly bypasses the audio_service contract
    // and trips the foreground-service startForeground timeout.
    await play();
  }

  Future<void> insertTracksAt({
    required Tracks tracks,
    required int index,
  }) async {
    _talker.debug(
      '[LocalPlayerService] insertTracksAt: ${tracks.length} tracks at index $index',
    );
    await _player.insertAudioSources(
      index,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  Future<void> setShuffle(ShuffleMode mode) async {
    final enable = mode == ShuffleMode.on;
    _talker.debug('[LocalPlayerService] Setting shuffle: $enable');
    await _player.setShuffleModeEnabled(enable);
  }

  Future<void> setRepeat(RepeatMode mode) async {
    LoopMode loopMode;
    switch (mode) {
      case RepeatMode.off:
        loopMode = LoopMode.off;
        break;
      case RepeatMode.playlist:
        loopMode = LoopMode.all;
        break;
      case RepeatMode.track:
        loopMode = LoopMode.one;
        break;
    }
    _talker.debug('[LocalPlayerService] Setting repeat mode: $mode');
    await _player.setLoopMode(loopMode);
  }

  Future<void> moveTrack(int source, int target) async {
    _talker.debug(
      '[LocalPlayerService] Moving track from index $source to $target',
    );
    await _player.moveAudioSource(source, target);
  }

  Future<void> removeTrack(int index) async {
    _talker.debug('[LocalPlayerService] Removing track at index $index');
    await _player.removeAudioSourceAt(index);
  }

  // ─── Source factory ───────────────────────────────────────────────────

  AudioSource _createSource(Track track) {
    final downloadsRepo = getIt<DownloadsRepository>();
    final localPath = downloadsRepo.localPathFor(track.fileKey);

    if (localPath != null && File(localPath).existsSync()) {
      _talker.debug(
        '[LocalPlayerService] Using local file for track ${track.fileKey}: $localPath',
      );
      return AudioSource.uri(Uri.file(localPath), tag: track);
    }

    final client = getIt<McwsClient>();
    final repo = getIt<ConnectionRepository>();
    final baseUrl = client.baseUrl;
    final token = repo.currentToken;

    // Build URL manually to be 100% sure of the format
    // baseUrl usually ends with /MCWS/v1/
    var url = baseUrl;
    if (!url.endsWith('/')) url += '/';
    final quality = qualityResolver();
    url +=
        'File/GetFile?File=${track.fileKey}&FileType=Key&Playback=1&${quality.mcwsParams}';
    if (token != null) {
      url += '&Token=$token';
    }
    _talker.debug('[LocalPlayerService] Quality: ${quality.label}');

    _talker.debug(
      '[LocalPlayerService] Created source for track ${track.fileKey}: $url',
    );

    final uriAudioSource = AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {'User-Agent': 'JRR-Remote/1.0', 'X-MCWS-Token': ?token},
    );

    return uriAudioSource;
  }

  // ─── just_audio → audio_service stream forwarding ─────────────────────

  void _bindPlayerToAudioServiceStreams() {
    // Only emit playbackState when something *meaningful* changes. Pumping
    // a new state on every position tick causes audio_service to rebuild
    // the MediaSession + notification several times per second, which on
    // some devices starves the audio thread and makes playback stutter.
    // Position is carried inside each emission (updatePosition +
    // updateTime + speed) so the OS extrapolates between emissions.
    _player.playbackEventStream
        .map(
          (event) => (
            playing: _player.playing,
            processing: _player.processingState,
            queueIndex: event.currentIndex,
          ),
        )
        .distinct()
        .listen(
          (_) => playbackState.add(
            _baseState(
              playing: _player.playing,
              processing: const {
                ProcessingState.idle: AudioProcessingState.idle,
                ProcessingState.loading: AudioProcessingState.loading,
                ProcessingState.buffering: AudioProcessingState.buffering,
                ProcessingState.ready: AudioProcessingState.ready,
                ProcessingState.completed: AudioProcessingState.completed,
              }[_player.processingState]!,
              queueIndex: _player.currentIndex,
            ),
          ),
          onError: (Object e, StackTrace st) =>
              _talker.error('[LocalPlayerService] playbackEventStream', e, st),
        );

    _player.sequenceStateStream.listen(
      (seqState) {
        queue.add([
          for (final src in seqState.sequence)
            if (src.tag is Track) _toMediaItem(src.tag as Track),
        ]);
        final ci = seqState.currentIndex;
        if (ci != null &&
            ci >= 0 &&
            ci < seqState.sequence.length &&
            seqState.sequence[ci].tag is Track) {
          mediaItem.add(_toMediaItem(seqState.sequence[ci].tag as Track));
        } else {
          mediaItem.add(null);
        }
      },
      onError: (Object e, StackTrace st) {
        _talker.error('[LocalPlayerService] sequenceStateStream', e, st);
      },
    );
  }

  /// Builds a `PlaybackState` with the standard control / system-action /
  /// compact-action layout. Used both for the synchronous emissions in
  /// `play`/`pause`/`stop`/constructor and the stream-driven binder.
  PlaybackState _baseState({
    required bool playing,
    required AudioProcessingState processing,
    int? queueIndex,
  }) {
    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      androidCompactActionIndices: const [0, 1, 3],
      processingState: processing,
      playing: playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: queueIndex,
    );
  }

  /// Synchronously emits the MediaItem for the currently-selected track,
  /// if any. Called from `play()` so the foreground notification has title
  /// text the moment audio_service tries to render it.
  void _emitCurrentMediaItem() {
    final seq = _player.sequence;
    final idx = _player.currentIndex ?? -1;
    if (idx < 0 || idx >= seq.length) return;
    final tag = seq[idx].tag;
    if (tag is Track) {
      mediaItem.add(_toMediaItem(tag));
    }
  }

  MediaItem _toMediaItem(Track track) {
    return MediaItem(
      id: track.fileKey.toString(),
      title: track.name,
      artist: track.artist.isEmpty ? null : track.artist,
      album: track.album.isEmpty ? null : track.album,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
    );
  }
}
