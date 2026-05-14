import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:jrr_f/features/player/data/repositories/recently_played_repository.dart';
import 'package:just_audio/just_audio.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/mcws_client.dart';
import '../../connection/data/repositories/connection_repository.dart';
import '../../library/data/models/track.dart';
import '../../library/data/models/tracks.dart';
import '../../offline/data/models/downloaded_track.dart';
import '../../offline/data/repositories/downloads_repository.dart';
import '../../zones/services/android_auto_session_service.dart';
import '../data/models/local_audio_quality.dart';
import 'media_item_mapper.dart';
import 'voice_intent_resolver.dart';

import 'local_player_service_base.dart';

/// Dedicated player service for the Android Auto zone.
///
/// It owns its own [AudioPlayer], implements the [MediaBrowser] overrides
/// required for AA head-unit browsing, and forwards its internal state to
/// the standard [audio_service] streams so it can be wrapped by a
/// composite handler.
class AndroidAutoPlayerService extends LocalPlayerServiceBase with SeekHandler {
  final AudioPlayer _player;
  final Talker _talker;

  /// Resolves the currently selected audio quality.
  LocalAudioQuality Function() qualityResolver;

  AndroidAutoPlayerService({
    required AudioPlayer player,
    required Talker talker,
    LocalAudioQuality Function()? qualityResolver,
  }) : _player = player,
       _talker = talker,
       qualityResolver = qualityResolver ?? (() => LocalAudioQuality.lossless) {
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.idle),
    );
    _bindPlayerToAudioServiceStreams();
  }

  Future<void> init() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.music());
      // Note: we don't call setActive(true) here; the composite handler
      // or the active zone manager should handle session activation to
      // avoid multiple players fighting for focus.
      _talker.info('[AndroidAutoPlayerService] initialized');
    } catch (e, st) {
      _talker.error('[AndroidAutoPlayerService] Failed to init', e, st);
    }
  }

  // ───────────── State getters ──────────────────────────────────────────
  @override
  SequenceState? get sequenceState => _player.sequenceState;
  @override
  ProcessingState get processingState => _player.processingState;
  @override
  bool get playing => _player.playing;
  @override
  Duration get position => _player.position;
  @override
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;
  @override
  LoopMode get loopMode => _player.loopMode;
  @override
  List<IndexedAudioSource> get sequence => _player.sequence;

  // ───────────── just_audio streams ─────────────────────────────────────
  @override
  Stream<Duration> get positionStream => _player.positionStream;
  @override
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  @override
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  @override
  Stream<PlaybackEvent> get playbackEventStream => _player.playbackEventStream;
  @override
  Stream<double> get volumeStream => _player.volumeStream;
  @override
  Stream<Duration?> get durationStream => _player.durationStream;

  @override
  Future<void> setTracks(Tracks tracks) async {
    _talker.info('[AndroidAutoPlayerService] setTracks: ${tracks.length} tracks');
    final sources = tracks.tracks.map((t) => _createSource(t)).toList();

    try {
      await _player.setAudioSources(sources, preload: true);
    } catch (e, st) {
      _talker.error('[AndroidAutoPlayerService] setAudioSource error', e, st);
    }
  }

  @override
  Future<void> playNow(Tracks tracks) async {
    await setTracks(tracks);
    await play();
  }

  @override
  Future<void> playPause() async {
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  // ─── audio_service transport overrides ────────────────────────────────

  @override
  Future<void> play() async {
    _talker.debug('[AndroidAutoPlayerService] Playing');
    _emitCurrentMediaItem();
    playbackState.add(
      _baseState(playing: true, processing: AudioProcessingState.ready),
    );
    await _player.play();
  }

  @override
  Future<void> pause() async {
    _talker.debug('[AndroidAutoPlayerService] Pausing');
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.ready),
    );
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    _talker.debug('[AndroidAutoPlayerService] Stopping');
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.idle),
    );
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
  }

  // ─── MediaBrowser callbacks (Android Auto browse tree) ────────────────

  static const _idRoot = 'root';
  static const _idCatDownloads = 'cat:downloads';
  static const _idCatRecent = 'cat:recent';
  static const _idCatArtists = 'cat:artists';
  static const _idCatAlbums = 'cat:albums';
  static const _segPlayAll = 'play:all';
  static const _segShuffleAll = 'shuffle:all';

  final MediaItemMapper _mapper = const MediaItemMapper();

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    _talker.debug('[AndroidAutoPlayerService] getChildren: $parentMediaId');
    getIt<AndroidAutoSessionService>().markActive();

    try {
      final last = _lastSegment(parentMediaId);
      if (last == _idRoot) return _rootChildren();
      if (last == _idCatDownloads) {
        return await _downloadsChildren(parentMediaId);
      }
      if (last == _idCatRecent) return await _recentChildren(parentMediaId);
      if (last == _idCatArtists) return await _artistsChildren(parentMediaId);
      if (last == _idCatAlbums) return await _albumsChildren(parentMediaId);
      if (last.startsWith('artist:')) {
        return await _artistAlbumsChildren(
          parentMediaId,
          _decode(last.substring('artist:'.length)),
        );
      }
      if (last.startsWith('album:')) {
        return await _albumTracksChildren(
          parentMediaId,
          _decode(last.substring('album:'.length)),
        );
      }
    } catch (e, st) {
      _talker.error('[AndroidAutoPlayerService] getChildren failed', e, st);
    }
    return const [];
  }

  @override
  Future<MediaItem?> getMediaItem(String mediaId) async {
    _talker.debug('[AndroidAutoPlayerService] getMediaItem: $mediaId');
    getIt<AndroidAutoSessionService>().markActive();
    final leaf = _lastSegment(mediaId);
    if (!leaf.startsWith('track:')) return null;
    final fileKey = int.tryParse(leaf.substring('track:'.length));
    if (fileKey == null) return null;
    final dt = await _findDownloadedTrack(fileKey);
    return dt == null ? null : _mapper.fromDownloadedTrack(dt);
  }

  @override
  Future<List<MediaItem>> search(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.debug('[AndroidAutoPlayerService] search: $query');
    getIt<AndroidAutoSessionService>().markActive();
    if (query.trim().isEmpty) return const [];
    final tracks = await _searchDownloaded(query);
    return tracks.map(_mapper.fromDownloadedTrack).toList(growable: false);
  }

  @override
  Future<void> playFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.info('[AndroidAutoPlayerService] playFromMediaId: $mediaId');
    getIt<AndroidAutoSessionService>().markActive();

    // Signal that the Android Auto zone should become active
    _onAndroidAutoActionRequested();

    final segments = mediaId.split('/');
    if (segments.isEmpty) return;
    final action = segments.last;
    final parentPath = segments.length > 1
        ? segments.sublist(0, segments.length - 1).join('/')
        : '';

    final queue = parentPath.isEmpty
        ? <DownloadedTrack>[]
        : await _resolveQueueForParent(parentPath);

    int startIndex = 0;
    var shuffle = false;

    if (action == _segPlayAll) {
    } else if (action == _segShuffleAll) {
      shuffle = true;
    } else if (action.startsWith('track:')) {
      final fileKey = int.tryParse(action.substring('track:'.length));
      if (fileKey == null) return;
      if (queue.isEmpty) {
        final dt = await _findDownloadedTrack(fileKey);
        if (dt == null) return;
        await setShuffle(ShuffleMode.off);
        await playNow(Tracks(tracks: [dt.track]));
        return;
      }
      final idx = queue.indexWhere((DownloadedTrack d) => d.fileKey == fileKey);
      if (idx < 0) {
        final dt = await _findDownloadedTrack(fileKey);
        if (dt == null) return;
        await setShuffle(ShuffleMode.off);
        await playNow(Tracks(tracks: [dt.track]));
        return;
      }
      startIndex = idx;
    } else {
      return;
    }

    if (queue.isEmpty) return;

    final tracks = Tracks(
      tracks: queue.map((DownloadedTrack d) => d.track).toList(),
    );
    await setShuffle(shuffle ? ShuffleMode.on : ShuffleMode.off);
    await setTracks(tracks);
    await playByIndex(startIndex);
  }

  @override
  Future<void> playFromSearch(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.info('[AndroidAutoPlayerService] playFromSearch: "$query"');
    getIt<AndroidAutoSessionService>().markActive();
    _onAndroidAutoActionRequested();

    final downloaded = await getIt<DownloadsRepository>().getDownloadedTracks();
    final intent = resolveVoiceIntent(
      query: query,
      extras: extras,
      downloaded: downloaded,
    );

    if (intent.tracks.isEmpty) return;

    await setShuffle(intent.shuffle ? ShuffleMode.on : ShuffleMode.off);
    await playNow(Tracks(tracks: intent.tracks));
  }

  void _onAndroidAutoActionRequested() {
    // This is a hook for the composite handler to switch zones.
    // For now, we'll just log it.
    _talker.info('[AndroidAutoPlayerService] Android Auto action requested');
  }

  // ─── Browse-tree builders ─────────────────────────────────────────────

  List<MediaItem> _rootChildren() => [
    _mapper.browseNode(id: _idCatDownloads, title: 'Downloads'),
    _mapper.browseNode(id: _idCatRecent, title: 'Recent'),
    _mapper.browseNode(id: _idCatArtists, title: 'Artists'),
    _mapper.browseNode(id: _idCatAlbums, title: 'Albums'),
  ];

  Future<List<MediaItem>> _downloadsChildren(String parentPath) async {
    final tracks = await _downloadsTracks();
    if (tracks.isEmpty) return const [];
    return [
      ..._playActions(parentPath, tracks),
      for (final t in tracks)
        _mapper.fromDownloadedTrack(t, parentPath: parentPath),
    ];
  }

  Future<List<MediaItem>> _recentChildren(String parentPath) async {
    final tracks = await _recentTracks();
    if (tracks.isEmpty) return const [];
    return [
      for (final t in tracks)
        _mapper.fromDownloadedTrack(t, parentPath: parentPath),
    ];
  }

  Future<List<MediaItem>> _artistsChildren(String parentPath) async {
    final tracks = await getIt<DownloadsRepository>().getDownloadedTracks();
    final artists = <String>{};
    for (final t in tracks) {
      final a = _artistOf(t);
      if (a.isNotEmpty) artists.add(a);
    }
    final sorted = artists.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return sorted
        .map(
          (name) => _mapper.browseNode(
            id: _join(parentPath, 'artist:${_encode(name)}'),
            title: name,
          ),
        )
        .toList(growable: false);
  }

  Future<List<MediaItem>> _albumsChildren(String parentPath) async {
    final tracks = await getIt<DownloadsRepository>().getDownloadedTracks();
    return _albumNodesFrom(parentPath, tracks);
  }

  Future<List<MediaItem>> _artistAlbumsChildren(
    String parentPath,
    String artistName,
  ) async {
    final tracks = await _artistTracks(artistName);
    return [
      if (tracks.isNotEmpty) ..._playActions(parentPath, tracks),
      ..._albumNodesFrom(parentPath, tracks),
    ];
  }

  Future<List<MediaItem>> _albumTracksChildren(
    String parentPath,
    String albumGroupId,
  ) async {
    final tracks = await _albumTracks(albumGroupId);
    if (tracks.isEmpty) return const [];
    return [
      ..._playActions(parentPath, tracks),
      for (final t in tracks)
        _mapper.fromDownloadedTrack(t, parentPath: parentPath),
    ];
  }

  List<MediaItem> _albumNodesFrom(
    String parentPath,
    List<DownloadedTrack> tracks,
  ) {
    final byGid = <String, DownloadedTrack>{};
    for (final t in tracks) {
      byGid.putIfAbsent(t.albumGroupId, () => t);
    }
    final entries = byGid.entries.toList()
      ..sort(
        (a, b) =>
            a.value.album.toLowerCase().compareTo(b.value.album.toLowerCase()),
      );
    return [
      for (final entry in entries)
        _mapper.browseNode(
          id: _join(parentPath, 'album:${_encode(entry.key)}'),
          title: entry.value.album.isEmpty
              ? 'Unknown Album'
              : entry.value.album,
          subtitle: _artistOf(entry.value),
          artworkPath: entry.value.artworkPath,
        ),
    ];
  }

  List<MediaItem> _playActions(
    String parentPath,
    List<DownloadedTrack> tracks,
  ) {
    if (tracks.length < 2) return const [];
    return [
      _mapper.playAction(
        id: _join(parentPath, _segPlayAll),
        title: 'Play all',
        subtitle: '${tracks.length} tracks',
      ),
      _mapper.playAction(
        id: _join(parentPath, _segShuffleAll),
        title: 'Shuffle all',
        subtitle: '${tracks.length} tracks',
      ),
    ];
  }

  Future<List<DownloadedTrack>> _resolveQueueForParent(
    String parentPath,
  ) async {
    final last = _lastSegment(parentPath);
    if (last == _idCatDownloads) return _downloadsTracks();
    if (last == _idCatRecent) return _recentTracks();
    if (last.startsWith('album:')) {
      return _albumTracks(_decode(last.substring('album:'.length)));
    }
    if (last.startsWith('artist:')) {
      return _artistTracks(_decode(last.substring('artist:'.length)));
    }
    return const [];
  }

  Future<List<DownloadedTrack>> _downloadsTracks() async {
    final tracks = await getIt<DownloadsRepository>().getDownloadedTracks();
    return [...tracks]..sort(
      (a, b) =>
          a.track.name.toLowerCase().compareTo(b.track.name.toLowerCase()),
    );
  }

  Future<List<DownloadedTrack>> _recentTracks() async {
    // This uses RecentlyPlayedRepository - we might want to keep it shared.
    final keys = getIt<RecentlyPlayedRepository>().getRecent();
    if (keys.isEmpty) return const [];
    final downloaded = await getIt<DownloadsRepository>().getDownloadedTracks();
    final byKey = {for (final d in downloaded) d.fileKey: d};
    return [
      for (final k in keys)
        if (byKey[k] != null) byKey[k]!,
    ];
  }

  Future<List<DownloadedTrack>> _albumTracks(String albumGroupId) async {
    final tracks = await getIt<DownloadsRepository>().getDownloadedTracks();
    return tracks.where((t) => t.albumGroupId == albumGroupId).toList()
      ..sort((a, b) {
        final cmp = a.discNumber.compareTo(b.discNumber);
        if (cmp != 0) return cmp;
        return a.trackNumber.compareTo(b.trackNumber);
      });
  }

  Future<List<DownloadedTrack>> _artistTracks(String artistName) async {
    final tracks = await getIt<DownloadsRepository>().getDownloadedTracks();
    final filtered = tracks
        .where((t) => _artistOf(t).toLowerCase() == artistName.toLowerCase())
        .toList();
    filtered.sort((a, b) {
      final byAlbum = a.album.toLowerCase().compareTo(b.album.toLowerCase());
      if (byAlbum != 0) return byAlbum;
      final byDisc = a.discNumber.compareTo(b.discNumber);
      if (byDisc != 0) return byDisc;
      return a.trackNumber.compareTo(b.trackNumber);
    });
    return filtered;
  }

  String _join(String parent, String child) =>
      parent.isEmpty ? child : '$parent/$child';

  String _lastSegment(String path) {
    final i = path.lastIndexOf('/');
    return i < 0 ? path : path.substring(i + 1);
  }

  Future<DownloadedTrack?> _findDownloadedTrack(int fileKey) async {
    final all = await getIt<DownloadsRepository>().getDownloadedTracks();
    for (final t in all) {
      if (t.fileKey == fileKey) return t;
    }
    return null;
  }

  Future<List<DownloadedTrack>> _searchDownloaded(String query) async {
    final q = query.trim().toLowerCase();
    final all = await getIt<DownloadsRepository>().getDownloadedTracks();
    return all
        .where(
          (d) =>
              d.track.name.toLowerCase().contains(q) ||
              d.track.artist.toLowerCase().contains(q) ||
              d.track.album.toLowerCase().contains(q),
        )
        .toList(growable: false);
  }

  String _artistOf(DownloadedTrack t) {
    if (t.albumArtist.isNotEmpty) return t.albumArtist;
    if (t.track.albumArtist.isNotEmpty) return t.track.albumArtist;
    return t.track.artist;
  }

  String _encode(String s) => base64UrlEncode(s.codeUnits).replaceAll('=', '');

  String _decode(String s) {
    final padded = s.padRight(s.length + (4 - s.length % 4) % 4, '=');
    return String.fromCharCodes(base64Url.decode(padded));
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

  // ─── Legacy transport helpers ─────────────────────────────────────────

  @override
  Future<void> seekTo(int positionMs, {int? index}) async {
    await _player.seek(Duration(milliseconds: positionMs), index: index);
  }

  @override
  Future<void> playNext(Tracks tracks) async {
    final currentIndex = _player.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await _player.insertAudioSources(
      insertIndex,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> addToQueue(Tracks tracks) async {
    await _player.addAudioSources(
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> setVolume(double level) async {
    await _player.setVolume(level);
  }

  @override
  Future<void> setMute(bool mute) async {
    await _player.setVolume(mute ? 0 : 1.0);
  }

  @override
  void next() {
    _player.seekToNext();
  }

  @override
  void previous() {
    _player.seekToPrevious();
  }

  @override
  Future<void> playByIndex(int index) async {
    await _player.seek(Duration.zero, index: index);
    await play();
  }

  @override
  Future<void> insertTracksAt({
    required Tracks tracks,
    required int index,
  }) async {
    await _player.insertAudioSources(
      index,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> setShuffle(ShuffleMode mode) async {
    final enable = mode == ShuffleMode.on;
    await _player.setShuffleModeEnabled(enable);
  }

  @override
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
    await _player.setLoopMode(loopMode);
  }

  @override
  Future<void> moveTrack(int source, int target) async {
    await _player.moveAudioSource(source, target);
  }

  @override
  Future<void> removeTrack(int index) async {
    await _player.removeAudioSourceAt(index);
  }

  // ─── Source factory ───────────────────────────────────────────────────

  AudioSource _createSource(Track track) {
    final downloadsRepo = getIt<DownloadsRepository>();
    final localPath = downloadsRepo.localPathFor(track.fileKey);

    if (localPath != null && File(localPath).existsSync()) {
      return AudioSource.uri(Uri.file(localPath), tag: track);
    }

    final client = getIt<McwsClient>();
    final repo = getIt<ConnectionRepository>();
    final baseUrl = client.baseUrl;
    final token = repo.currentToken;

    var url = baseUrl;
    if (!url.endsWith('/')) url += '/';
    final quality = qualityResolver();
    url +=
        'File/GetFile?File=${track.fileKey}&FileType=Key&Playback=1&${quality.mcwsParams}';
    if (token != null) {
      url += '&Token=$token';
    }

    return AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {'User-Agent': 'JRR-Remote/1.0', 'X-MCWS-Token': token ?? ''},
    );
  }

  // ─── just_audio → audio_service stream forwarding ─────────────────────

  void _bindPlayerToAudioServiceStreams() {
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
              _talker.error('[AndroidAutoPlayerService] playbackEventStream', e, st),
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
          final currentTrack = seqState.sequence[ci].tag as Track;
          mediaItem.add(_toMediaItem(currentTrack));
        } else {
          mediaItem.add(null);
        }
      },
      onError: (Object e, StackTrace st) {
        _talker.error('[AndroidAutoPlayerService] sequenceStateStream', e, st);
      },
    );
  }

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
