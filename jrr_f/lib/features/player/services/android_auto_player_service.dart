import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/features/player/data/models/repeat_mode.dart';
import 'package:jrr_f/features/player/data/models/shuffle_mode.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/mcws_client.dart';
import '../../connection/data/repositories/connection_repository.dart';
import '../../favorites/data/repositories/favorites_repository.dart';
import '../../library/data/models/album.dart';
import '../../library/data/models/browse_item.dart';
import '../../library/data/models/track.dart';
import '../../library/data/models/tracks.dart';
import '../../library/data/repositories/library_repository.dart';
import '../../offline/data/models/downloaded_track.dart';
import '../../offline/data/repositories/downloads_repository.dart';
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

  /// Placeholder item published before any real track is queued so that
  /// `audio_service` has a non-null `MediaItem` to render a notification
  /// from. This is what lets the plugin call `startForeground()` within
  /// the 5s window that Android 12+ enforces after `startForegroundService`,
  /// which Android Auto triggers as soon as it binds the
  /// `MediaBrowserService`.
  static const MediaItem _placeholderMediaItem = MediaItem(
    id: 'placeholder',
    title: 'JRiver Remote',
    album: 'Android Auto',
  );

  AndroidAutoPlayerService({
    required AudioPlayer player,
    required Talker talker,
    LocalAudioQuality Function()? qualityResolver,
  }) : _player = player,
       _talker = talker,
       qualityResolver = qualityResolver ?? (() => LocalAudioQuality.lossless) {
    // Seed with `ready` (not `idle`) so the audio_service plugin treats the
    // handler as foreground-eligible and promotes the service via
    // `startForeground()` immediately on bind. With `idle` the plugin defers
    // promotion and Android fires a "did not call Service.startForeground"
    // ANR within ~5s.
    mediaItem.add(_placeholderMediaItem);
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.ready),
    );
    _bindPlayerToAudioServiceStreams();
  }

  Future<void> init() async {
    try {
      final session = await AudioSession.instance;
      _talker.debug('[AndroidAutoPlayerService] Configuring AudioSession');
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
    _talker.info(
      '[AndroidAutoPlayerService] setTracks: ${tracks.length} tracks',
    );
    if (tracks.tracks.isNotEmpty) {
      _talker.debug(
        '[AndroidAutoPlayerService] first track: ${tracks.tracks.first.name} (${tracks.tracks.first.fileKey})',
      );
    }
    final sources = tracks.tracks.map((t) => _createSource(t)).toList();

    try {
      await _player.setAudioSources(sources, preload: true);
    } catch (e, st) {
      _talker.error('[AndroidAutoPlayerService] setAudioSource error', e, st);
    }
  }

  @override
  Future<void> playNow(Tracks tracks) async {
    _talker.info('[AndroidAutoPlayerService] playNow: ${tracks.length} tracks');
    await setTracks(tracks);
    await play();
  }

  @override
  Future<void> playPause() async {
    _talker.debug(
      '[AndroidAutoPlayerService] playPause (currently playing: ${_player.playing})',
    );
    if (_player.playing) {
      await pause();
    } else {
      await play();
    }
  }

  // ─── audio_service transport overrides ────────────────────────────────

  @override
  Future<void> play() async {
    _talker.info('[AndroidAutoPlayerService] play()');
    _emitCurrentMediaItem();
    playbackState.add(
      _baseState(playing: true, processing: AudioProcessingState.ready),
    );
    await _player.play();
  }

  @override
  Future<void> pause() async {
    _talker.info('[AndroidAutoPlayerService] pause()');
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.ready),
    );
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    _talker.info('[AndroidAutoPlayerService] stop()');
    _downloadsSubscription?.cancel();
    _downloadsSubscription = null;
    playbackState.add(
      _baseState(playing: false, processing: AudioProcessingState.idle),
    );
    await _player.stop();
    await super.stop();
  }

  @override
  Future<void> seek(Duration position) async {
    _talker.debug('[AndroidAutoPlayerService] seek: $position');
    await _player.seek(position);
  }

  @override
  Future<void> skipToNext() async {
    _talker.info('[AndroidAutoPlayerService] skipToNext()');
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    _talker.info('[AndroidAutoPlayerService] skipToPrevious()');
    await _player.seekToPrevious();
  }

  // ─── MediaBrowser callbacks (Android Auto browse tree) ────────────────

  static const _idRoot = 'root';
  static const _idCatDownloads = 'cat:downloads';
  static const _idCatArtists = 'lib:artists';
  static const _idCatRandom = 'lib:random';
  static const _idCatBrowse = 'lib:browse';
  static const _idCatFavorites = 'lib:favorites';
  static const _segPlayAll = 'play:all';
  static const _segShuffleAll = 'shuffle:all';
  static const _idActionRefresh = 'lib:refresh';

  /// MCWS browse-tree root id. JRiver MC exposes the top of its
  /// configured Browse hierarchy under `-1`; everything else is a child
  /// of that.
  static const _mcwsBrowseRoot = '-1';

  final MediaItemMapper _mapper = const MediaItemMapper();

  StreamSubscription<List<DownloadedTrack>>? _downloadsSubscription;

  /// Subjects used to signal Android Auto to refresh specific folders.
  final _browseSubjects = <String, BehaviorSubject<Map<String, dynamic>>>{};

  @override
  ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) {
    _talker.debug('[AndroidAutoPlayerService] subscribeToChildren: $parentMediaId');
    return _browseSubjects.putIfAbsent(
      parentMediaId,
      () => BehaviorSubject.seeded(const <String, dynamic>{}),
    ).stream;
  }

  /// Triggers a refresh for the given folder on the head unit.
  void notifyChildrenChanged(String parentMediaId) {
    _talker.info('[AndroidAutoPlayerService] notifyChildrenChanged: $parentMediaId');
    _browseSubjects[parentMediaId]?.add({
      'refresh': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) async {
    _talker.debug(
      '[AndroidAutoPlayerService] getChildren: $parentMediaId, options: $options',
    );

    try {
      List<MediaItem> result = const [];
      final last = _lastSegment(parentMediaId);

      if (last == _idActionRefresh) {
        _talker.info('[AndroidAutoPlayerService] Manual refresh triggered for all categories');
        // Signal refresh for all top-level categories
        notifyChildrenChanged(_idCatArtists);
        notifyChildrenChanged(_idCatRandom);
        notifyChildrenChanged(_idCatBrowse);
        notifyChildrenChanged(_idCatFavorites);
        // Note: Downloads has its own auto-refresh listener

        return [
          _mapper.browseNode(
            id: _join(parentMediaId, 'status'),
            title: 'Refresh Complete',
            subtitle: 'Tap back to see updates',
          ),
        ];
      }

      if (last == _idRoot) {
        result = _rootChildren();
      } else if (last == _idCatDownloads) {
        result = await _downloadsChildren(parentMediaId);
      } else if (last == _idCatArtists) {
        result = await _libArtistsChildren(parentMediaId);
      } else if (last == _idCatRandom) {
        result = await _libRandomChildren(parentMediaId);
      } else if (last == _idCatBrowse) {
        result = await _onlineBrowseChildrenAt(parentMediaId, _mcwsBrowseRoot);
      } else if (last == _idCatFavorites) {
        result = await _libFavoritesChildren(parentMediaId);
      } else if (last.startsWith('artist:')) {
        result = await _artistAlbumsChildren(
          parentMediaId,
          _decode(last.substring('artist:'.length)),
        );
      } else if (last.startsWith('album:')) {
        result = await _albumTracksChildren(
          parentMediaId,
          _decode(last.substring('album:'.length)),
        );
      } else if (last.startsWith('oartist:')) {
        result = await _onlineArtistChildren(
          parentMediaId,
          _decUtf8(last.substring('oartist:'.length)),
        );
      } else if (last.startsWith('oalbum:')) {
        result = await _onlineAlbumChildren(
          parentMediaId,
          _decodeAlbum(last.substring('oalbum:'.length)),
        );
      } else if (last.startsWith('obrowse:')) {
        result = await _onlineBrowseChildrenAt(
          parentMediaId,
          _decUtf8(last.substring('obrowse:'.length)),
        );
      }
      _talker.debug(
        '[AndroidAutoPlayerService] getChildren returning ${result.length} items',
      );
      return result;
    } catch (e, st) {
      _talker.error('[AndroidAutoPlayerService] getChildren failed', e, st);
    }
    return const [];
  }

  @override
  Future<MediaItem?> getMediaItem(String mediaId) async {
    _talker.debug('[AndroidAutoPlayerService] getMediaItem: $mediaId');
    final leaf = _lastSegment(mediaId);

    if (leaf == _idActionRefresh) {
      _talker.debug('[AndroidAutoPlayerService] getMediaItem: refresh action');
      return _mapper.browseNode(
        id: mediaId,
        title: 'Refresh Library',
        subtitle: 'Update all categories',
      );
    }

    if (!leaf.startsWith('track:')) {
      _talker.debug('[AndroidAutoPlayerService] getMediaItem: not a track');
      return null;
    }
    final fileKey = int.tryParse(leaf.substring('track:'.length));
    if (fileKey == null) {
      _talker.debug('[AndroidAutoPlayerService] getMediaItem: invalid fileKey');
      return null;
    }
    final dt = await _findDownloadedTrack(fileKey);
    if (dt != null) {
      _talker.debug('[AndroidAutoPlayerService] getMediaItem: found downloaded');
      return _mapper.fromDownloadedTrack(dt);
    }
    final track = await _findOnlineTrack(fileKey);
    if (track != null) {
      _talker.debug('[AndroidAutoPlayerService] getMediaItem: found online');
      return _onlineTrackMediaItem(track);
    }
    _talker.debug('[AndroidAutoPlayerService] getMediaItem: not found');
    return null;
  }

  @override
  Future<List<MediaItem>> search(
    String query, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.info('[AndroidAutoPlayerService] search: "$query"');
    if (query.trim().isEmpty) return const [];
    final tracks = await _searchDownloaded(query);
    _talker.debug(
      '[AndroidAutoPlayerService] search returning ${tracks.length} items',
    );
    return tracks.map(_mapper.fromDownloadedTrack).toList(growable: false);
  }

  @override
  Future<void> playFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) async {
    _talker.info('[AndroidAutoPlayerService] playFromMediaId: $mediaId');

    final segments = mediaId.split('/');
    if (segments.isEmpty) return;
    final action = segments.last;
    final parentPath = segments.length > 1
        ? segments.sublist(0, segments.length - 1).join('/')
        : '';

    _talker.debug(
      '[AndroidAutoPlayerService] playFromMediaId action: $action, parent: $parentPath',
    );

    final queue = parentPath.isEmpty
        ? const <Track>[]
        : await _resolveQueueForParent(parentPath);

    int startIndex = 0;
    var shuffle = false;

    if (action == _segPlayAll) {
      _talker.debug('[AndroidAutoPlayerService] playFromMediaId: Play All');
    } else if (action == _segShuffleAll) {
      _talker.debug('[AndroidAutoPlayerService] playFromMediaId: Shuffle All');
      shuffle = true;
    } else if (action.startsWith('track:')) {
      final fileKey = int.tryParse(action.substring('track:'.length));
      if (fileKey == null) {
        _talker.error('[AndroidAutoPlayerService] invalid track action: $action');
        return;
      }
      final idx = queue.indexWhere((t) => t.fileKey == fileKey);
      if (queue.isEmpty || idx < 0) {
        _talker.debug(
          '[AndroidAutoPlayerService] track not in queue, finding single track',
        );
        final track = await _findTrack(fileKey);
        if (track == null) {
          _talker.error('[AndroidAutoPlayerService] track $fileKey not found');
          return;
        }
        await setShuffle(ShuffleMode.off);
        await playNow(Tracks(tracks: [track]));
        return;
      }
      startIndex = idx;
      _talker.debug(
        '[AndroidAutoPlayerService] playing track at index $startIndex',
      );
    } else {
      _talker.warning('[AndroidAutoPlayerService] unknown action: $action');
      return;
    }

    if (queue.isEmpty) {
      _talker.warning('[AndroidAutoPlayerService] resolved queue is empty');
      return;
    }

    _talker.info(
      '[AndroidAutoPlayerService] queueing ${queue.length} tracks (startIndex: $startIndex, shuffle: $shuffle)',
    );
    final tracks = Tracks(tracks: queue);
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

    final downloaded = await getIt<DownloadsRepository>().getDownloadedTracks();
    final intent = resolveVoiceIntent(
      query: query,
      extras: extras,
      downloaded: downloaded,
    );

    if (intent.tracks.isEmpty) {
      _talker.warning('[AndroidAutoPlayerService] voice intent resolved no tracks');
      return;
    }

    _talker.info(
      '[AndroidAutoPlayerService] voice intent resolved ${intent.tracks.length} tracks (shuffle: ${intent.shuffle})',
    );
    await setShuffle(intent.shuffle ? ShuffleMode.on : ShuffleMode.off);
    await playNow(Tracks(tracks: intent.tracks));
  }

  // ─── Browse-tree builders ─────────────────────────────────────────────

  List<MediaItem> _rootChildren() => [
    _mapper.browseNode(id: _idCatDownloads, title: 'Downloads'),
    _mapper.browseNode(id: _idCatArtists, title: 'Artists'),
    _mapper.browseNode(id: _idCatRandom, title: 'Random Albums'),
    _mapper.browseNode(id: _idCatBrowse, title: 'Browse'),
    _mapper.browseNode(id: _idCatFavorites, title: 'Favorites'),
    _mapper.browseNode(
      id: _idActionRefresh,
      title: 'Refresh Library',
      subtitle: 'Update all categories',
    ),
  ];

  /// `Downloads` is the artist index for the offline library:
  /// `Downloads → Artist → Album → Tracks`. The top-level `Recent` /
  /// `Artists` / `Albums` shortcuts were collapsed into this single
  /// hierarchy to keep the head-unit UI minimal while v1 still only
  /// serves downloaded content.
  Future<List<MediaItem>> _downloadsChildren(String parentPath) async {
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

  Future<List<Track>> _resolveQueueForParent(String parentPath) async {
    final last = _lastSegment(parentPath);
    if (last.startsWith('album:')) {
      final dl = await _albumTracks(_decode(last.substring('album:'.length)));
      return dl.map((d) => d.track).toList(growable: false);
    }
    if (last.startsWith('artist:')) {
      final dl = await _artistTracks(_decode(last.substring('artist:'.length)));
      return dl.map((d) => d.track).toList(growable: false);
    }
    if (last.startsWith('oalbum:')) {
      final album = _decodeAlbum(last.substring('oalbum:'.length));
      return _onlineAlbumTracks(album);
    }
    if (last.startsWith('obrowse:')) {
      final id = _decUtf8(last.substring('obrowse:'.length));
      return _onlineBrowseFiles(id);
    }
    // `oartist:` deliberately doesn't expose a "Play all" queue today —
    // it would require fanning out over getAlbumsByArtist + getAlbumTracks,
    // which is expensive on large libraries. Drill into an album instead.
    return const [];
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

  // ─── Online (MCWS) browse tree ────────────────────────────────────────
  //
  // These mirror the Library screen: Artists / Random Albums / Browse /
  // Favorites. Each leaf eventually streams via _createSource, which
  // builds an MCWS GetFile URL when no local copy exists.

  /// utf8-safe id encoder for online segments. The offline `_encode`
  /// uses `codeUnits` and silently mangles non-ASCII characters; we
  /// keep both to avoid migrating already-cached offline ids.
  String _encUtf8(String s) =>
      base64UrlEncode(utf8.encode(s)).replaceAll('=', '');

  String _decUtf8(String s) {
    final padded = s.padRight(s.length + (4 - s.length % 4) % 4, '=');
    return utf8.decode(base64Url.decode(padded));
  }

  /// Albums need name+folderPath+albumArtist+artworkFileKey to roundtrip
  /// through `LibraryRepository.getAlbumTracks` and to render artwork.
  /// We pack them into a small JSON blob so an album id segment is
  /// self-contained — no server lookup needed to rebuild the Album
  /// object on the way back into getChildren / playFromMediaId.
  String _encodeAlbum(Album a) => _encUtf8(
    jsonEncode({
      'n': a.name,
      'f': a.folderPath,
      'a': a.albumArtist,
      'k': a.artworkFileKey,
    }),
  );

  Album _decodeAlbum(String s) {
    final m = jsonDecode(_decUtf8(s)) as Map<String, dynamic>;
    return Album(
      name: (m['n'] as String?) ?? '',
      albumArtist: (m['a'] as String?) ?? '',
      folderPath: (m['f'] as String?) ?? '',
      parentFolderPath: '',
      albumGroupId: '',
      artworkFileKey: (m['k'] as int?) ?? -1,
    );
  }

  Future<List<MediaItem>> _libArtistsChildren(String parentPath) async {
    final result = await getIt<LibraryRepository>().getArtists();
    final artists = result.fold((_) => const <String>[], (l) => l);
    return [
      for (final name in artists)
        _mapper.browseNode(
          id: _join(parentPath, 'oartist:${_encUtf8(name)}'),
          title: name,
        ),
    ];
  }

  Future<List<MediaItem>> _libRandomChildren(String parentPath) async {
    final result = await getIt<LibraryRepository>().getRandomAlbums();
    final albums = result.fold((_) => const <Album>[], (a) => a.albums);
    return [
      for (final album in albums) _onlineAlbumNode(parentPath, album),
    ];
  }

  Future<List<MediaItem>> _libFavoritesChildren(String parentPath) async {
    final result = await getIt<FavoritesRepository>().getAll();
    final favs = result.fold((_) => const <Favorite>[], (l) => l);
    return [
      for (final f in favs)
        _mapper.browseNode(
          id: _join(parentPath, 'obrowse:${_encUtf8(f.identifier)}'),
          title: f.displayName,
        ),
    ];
  }

  Future<List<MediaItem>> _onlineArtistChildren(
    String parentPath,
    String artistName,
  ) async {
    final result = await getIt<LibraryRepository>().getAlbumsByArtist(
      artistName,
    );
    final albums = result.fold((_) => const <Album>[], (a) => a.albums);
    return [
      for (final album in albums) _onlineAlbumNode(parentPath, album),
    ];
  }

  Future<List<MediaItem>> _onlineAlbumChildren(
    String parentPath,
    Album album,
  ) async {
    final tracks = await _onlineAlbumTracks(album);
    if (tracks.isEmpty) return const [];
    return [
      ..._onlinePlayActions(parentPath, tracks.length),
      for (final t in tracks)
        _onlineTrackBrowseItem(t, parentPath: parentPath),
    ];
  }

  /// Children of a MCWS browse-tree node. If [mcwsId] has folder
  /// children, surface those as further browse nodes; otherwise treat
  /// it as a leaf and surface its tracks with Play/Shuffle actions.
  /// Mirrors how `BrowseContent` in the app collapses the two states.
  Future<List<MediaItem>> _onlineBrowseChildrenAt(
    String parentPath,
    String mcwsId,
  ) async {
    final childrenResult = await getIt<LibraryRepository>().browseChildren(
      mcwsId,
    );
    final children = childrenResult.fold(
      (_) => const <BrowseItem>[],
      (l) => l,
    );
    if (children.isNotEmpty) {
      return [
        for (final c in children)
          _mapper.browseNode(
            id: _join(parentPath, 'obrowse:${_encUtf8(c.id)}'),
            title: c.name,
          ),
      ];
    }
    final tracks = await _onlineBrowseFiles(mcwsId);
    if (tracks.isEmpty) return const [];
    return [
      ..._onlinePlayActions(parentPath, tracks.length),
      for (final t in tracks)
        _onlineTrackBrowseItem(t, parentPath: parentPath),
    ];
  }

  Future<List<Track>> _onlineAlbumTracks(Album album) async {
    final result = await getIt<LibraryRepository>().getAlbumTracks(album);
    return result.fold((_) => const [], (t) => t.tracks);
  }

  Future<List<Track>> _onlineBrowseFiles(String mcwsId) async {
    final result = await getIt<LibraryRepository>().browseFiles(mcwsId);
    return result.fold((_) => const [], (t) => t.tracks);
  }

  Future<Track?> _findOnlineTrack(int fileKey) async {
    final result = await getIt<LibraryRepository>().searchByFileKey(fileKey);
    return result.fold((_) => null, (t) => t);
  }

  /// Combined offline-then-online resolution for `playFromMediaId` and
  /// `getMediaItem` fallbacks. Downloaded copies win because they
  /// stream off-disk instantly.
  Future<Track?> _findTrack(int fileKey) async {
    final dt = await _findDownloadedTrack(fileKey);
    if (dt != null) return dt.track;
    return _findOnlineTrack(fileKey);
  }

  MediaItem _onlineAlbumNode(String parentPath, Album album) {
    return _mapper.browseNode(
      id: _join(parentPath, 'oalbum:${_encodeAlbum(album)}'),
      title: album.name.isEmpty ? 'Unknown Album' : album.name,
      subtitle: album.albumArtist,
    )..extras?['artUri'] = _httpArtUri(album.artworkFileKey)?.toString();
  }

  /// MediaItem for a track shown inside a browse list. We can't use the
  /// mapper's `fromOnlineTrack` equivalent because artwork lives over
  /// HTTP, which the offline mapper doesn't know about.
  MediaItem _onlineTrackBrowseItem(Track track, {required String parentPath}) {
    return MediaItem(
      id: '$parentPath/track:${track.fileKey}',
      title: track.name.isEmpty ? 'Unknown' : track.name,
      artist: track.artist.isEmpty ? null : track.artist,
      album: track.album.isEmpty ? null : track.album,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
      artUri: _httpArtUri(track.fileKey),
      playable: true,
    );
  }

  /// Build a synthetic MediaItem for a single online track returned
  /// from `getMediaItem`. The id is bare (`track:N`) because the caller
  /// doesn't carry a parent path here.
  MediaItem _onlineTrackMediaItem(Track track) {
    return MediaItem(
      id: 'track:${track.fileKey}',
      title: track.name.isEmpty ? 'Unknown' : track.name,
      artist: track.artist.isEmpty ? null : track.artist,
      album: track.album.isEmpty ? null : track.album,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
      artUri: _httpArtUri(track.fileKey),
      playable: true,
    );
  }

  List<MediaItem> _onlinePlayActions(String parentPath, int count) {
    if (count < 2) return const [];
    return [
      _mapper.playAction(
        id: _join(parentPath, _segPlayAll),
        title: 'Play all',
        subtitle: '$count tracks',
      ),
      _mapper.playAction(
        id: _join(parentPath, _segShuffleAll),
        title: 'Shuffle all',
        subtitle: '$count tracks',
      ),
    ];
  }

  /// Builds an HTTP `File/GetImage` URL for AA artwork. AA fetches the
  /// URL via the phone host, so cleartext LAN URLs work as long as the
  /// app itself reaches the server. The token is embedded in the query
  /// because MediaItem.artUri carries no headers.
  Uri? _httpArtUri(int? fileKey) {
    if (fileKey == null || fileKey < 0) return null;
    if (!getIt.isRegistered<McwsClient>()) return null;
    final token = getIt.isRegistered<ConnectionRepository>()
        ? getIt<ConnectionRepository>().currentToken
        : null;
    var base = getIt<McwsClient>().baseUrl;
    if (base.isEmpty) return null;
    if (!base.endsWith('/')) base += '/';
    final tokenParam = (token == null || token.isEmpty) ? '' : '&Token=$token';
    return Uri.parse(
      '${base}File/GetImage?File=$fileKey'
      '&Format=jpg&Width=512&Height=512$tokenParam',
    );
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _talker.info('[AndroidAutoPlayerService] setShuffleMode: $shuffleMode');
    await _player.setShuffleModeEnabled(
      shuffleMode != AudioServiceShuffleMode.none,
    );
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    _talker.info('[AndroidAutoPlayerService] setRepeatMode: $repeatMode');
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
    _talker.debug(
      '[AndroidAutoPlayerService] seekTo: ${positionMs}ms (index: $index)',
    );
    await _player.seek(Duration(milliseconds: positionMs), index: index);
  }

  @override
  Future<void> playNext(Tracks tracks) async {
    _talker.info(
      '[AndroidAutoPlayerService] playNext: ${tracks.length} tracks',
    );
    final currentIndex = _player.currentIndex ?? -1;
    final insertIndex = currentIndex + 1;
    await _player.insertAudioSources(
      insertIndex,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> addToQueue(Tracks tracks) async {
    _talker.info(
      '[AndroidAutoPlayerService] addToQueue: ${tracks.length} tracks',
    );
    await _player.addAudioSources(
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> setVolume(double level) async {
    _talker.debug('[AndroidAutoPlayerService] setVolume: $level');
    await _player.setVolume(level);
  }

  @override
  Future<void> setMute(bool mute) async {
    _talker.debug('[AndroidAutoPlayerService] setMute: $mute');
    await _player.setVolume(mute ? 0 : 1.0);
  }

  @override
  void next() {
    _talker.info('[AndroidAutoPlayerService] next()');
    _player.seekToNext();
  }

  @override
  void previous() {
    _talker.info('[AndroidAutoPlayerService] previous()');
    _player.seekToPrevious();
  }

  @override
  Future<void> playByIndex(int index) async {
    _talker.info('[AndroidAutoPlayerService] playByIndex: $index');
    await _player.seek(Duration.zero, index: index);
    await play();
  }

  @override
  Future<void> insertTracksAt({
    required Tracks tracks,
    required int index,
  }) async {
    _talker.info(
      '[AndroidAutoPlayerService] insertTracksAt: $index (${tracks.length} tracks)',
    );
    await _player.insertAudioSources(
      index,
      tracks.tracks.map((t) => _createSource(t)).toList(),
    );
  }

  @override
  Future<void> setShuffle(ShuffleMode mode) async {
    _talker.info('[AndroidAutoPlayerService] setShuffle: $mode');
    final enable = mode == ShuffleMode.on;
    await _player.setShuffleModeEnabled(enable);
  }

  @override
  Future<void> setRepeat(RepeatMode mode) async {
    _talker.info('[AndroidAutoPlayerService] setRepeat: $mode');
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
    _talker.debug('[AndroidAutoPlayerService] moveTrack: $source -> $target');
    await _player.moveAudioSource(source, target);
  }

  @override
  Future<void> removeTrack(int index) async {
    _talker.info('[AndroidAutoPlayerService] removeTrack: $index');
    await _player.removeAudioSourceAt(index);
  }

  // ─── Source factory ───────────────────────────────────────────────────

  AudioSource _createSource(Track track) {
    final downloadsRepo = getIt<DownloadsRepository>();
    final localPath = downloadsRepo.localPathFor(track.fileKey);

    if (localPath != null && File(localPath).existsSync()) {
      _talker.debug(
        '[AndroidAutoPlayerService] _createSource (local): ${track.fileKey}',
      );
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

    _talker.debug(
      '[AndroidAutoPlayerService] _createSource (MCWS): ${track.fileKey} (quality: ${quality.name})',
    );

    return AudioSource.uri(
      Uri.parse(url),
      tag: track,
      headers: {'User-Agent': 'JRR-Remote/1.0', 'X-MCWS-Token': token ?? ''},
    );
  }

  // ─── just_audio → audio_service stream forwarding ─────────────────────

  void _bindPlayerToAudioServiceStreams() {
    // Listen for changes to downloaded tracks to refresh the AA Downloads view.
    _downloadsSubscription?.cancel();
    _downloadsSubscription = getIt<DownloadsRepository>()
        .watchDownloadedTracks()
        // Skip initial event to avoid refresh loop during startup.
        .skip(1)
        // Debounce to avoid spamming the head unit during batch downloads.
        .debounceTime(const Duration(seconds: 2))
        .listen((_) {
          _talker.info('[AndroidAutoPlayerService] Auto-refreshing Downloads');
          notifyChildrenChanged(_idCatDownloads);
        });

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
          (state) {
            _talker.debug(
              '[AndroidAutoPlayerService] stream: playing=${state.playing}, processing=${state.processing}, index=${state.queueIndex}',
            );
            playbackState.add(
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
            );
          },
          onError: (Object e, StackTrace st) => _talker.error(
            '[AndroidAutoPlayerService] playbackEventStream',
            e,
            st,
          ),
        );

    _player.sequenceStateStream.listen(
      (seqState) {
        _talker.debug(
          '[AndroidAutoPlayerService] sequenceStateStream: ${seqState.sequence.length} items, index: ${seqState.currentIndex}',
        );
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
          _talker.debug(
            '[AndroidAutoPlayerService] current mediaItem: ${currentTrack.name}',
          );
          mediaItem.add(_toMediaItem(currentTrack));
        } else {
          _talker.debug('[AndroidAutoPlayerService] current mediaItem: null');
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
    final artworkPath = getIt<DownloadsRepository>().artworkPathFor(
      track.fileKey,
    );
    return MediaItem(
      id: track.fileKey.toString(),
      title: track.name,
      artist: track.artist.isEmpty ? null : track.artist,
      album: track.album.isEmpty ? null : track.album,
      duration: Duration(milliseconds: (track.duration * 1000).round()),
      artUri: MediaItemMapper.artUriForPath(artworkPath),
    );
  }
}
