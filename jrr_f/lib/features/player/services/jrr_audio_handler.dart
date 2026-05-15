import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:rxdart/rxdart.dart';
import 'local_player_service.dart';
import 'android_auto_player_service.dart';
import 'local_player_service_base.dart';

/// Composite [AudioHandler] that coordinates multiple specialized players.
///
/// It delegates MediaBrowser requests (Android Auto) to [AndroidAutoPlayerService]
/// while routing transport commands (play, pause, etc.) to the player
/// associated with the currently active zone.
class JrrAudioHandler extends BaseAudioHandler {
  final LocalPlayerService localPlayer;
  final AndroidAutoPlayerService autoPlayer;

  /// The player that currently owns the system notification and transport
  /// controls.
  final BehaviorSubject<BaseAudioHandler> _activePlayer;

  JrrAudioHandler({required this.localPlayer, required this.autoPlayer})
    : _activePlayer = BehaviorSubject<BaseAudioHandler>.seeded(localPlayer) {
    // Pipe streams from the active player to our own output streams.
    // This ensures the system notification and lock screen always reflect
    // the state of the "active" zone's player.
    _activePlayer.switchMap((p) => p.playbackState).listen(playbackState.add);
    _activePlayer.switchMap((p) => p.mediaItem).listen(mediaItem.add);
    _activePlayer.switchMap((p) => p.queue).listen(queue.add);
  }

  /// Switches the active player (the one that responds to transport commands
  /// and updates the notification).
  void switchTo(BaseAudioHandler player, {bool pausePrevious = true}) {
    if (_activePlayer.value != player) {
      final oldPlayer = _activePlayer.value;
      _activePlayer.add(player);

      // Stop/pause the previous player so we don't have overlapping audio.
      if (pausePrevious &&
          oldPlayer is LocalPlayerServiceBase &&
          oldPlayer.playing) {
        oldPlayer.pause();
      }
    }
  }

  BaseAudioHandler get activePlayer => _activePlayer.value;

  // ─── MediaBrowser overrides (Always go to autoPlayer) ─────────────────

  @override
  ValueStream<Map<String, dynamic>> subscribeToChildren(String parentMediaId) =>
      autoPlayer.subscribeToChildren(parentMediaId);

  @override
  Future<List<MediaItem>> getChildren(
    String parentMediaId, [
    Map<String, dynamic>? options,
  ]) => autoPlayer.getChildren(parentMediaId, options);

  @override
  Future<MediaItem?> getMediaItem(String mediaId) =>
      autoPlayer.getMediaItem(mediaId);

  @override
  Future<List<MediaItem>> search(
    String query, [
    Map<String, dynamic>? extras,
  ]) => autoPlayer.search(query, extras);

  @override
  Future<void> playFromMediaId(String mediaId, [Map<String, dynamic>? extras]) {
    switchTo(autoPlayer);
    return autoPlayer.playFromMediaId(mediaId, extras);
  }

  @override
  Future<void> playFromSearch(String query, [Map<String, dynamic>? extras]) {
    switchTo(autoPlayer);
    return autoPlayer.playFromSearch(query, extras);
  }

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) {
    switchTo(autoPlayer);
    return autoPlayer.playFromUri(uri, extras);
  }

  // ─── Transport overrides (Go to activePlayer) ─────────────────────────

  @override
  Future<void> play() => activePlayer.play();

  @override
  Future<void> pause() => activePlayer.pause();

  @override
  Future<void> stop() => activePlayer.stop();

  @override
  Future<void> seek(Duration position) => activePlayer.seek(position);

  @override
  Future<void> skipToNext() => activePlayer.skipToNext();

  @override
  Future<void> skipToPrevious() => activePlayer.skipToPrevious();

  @override
  Future<void> skipToQueueItem(int index) =>
      activePlayer.skipToQueueItem(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) =>
      activePlayer.setRepeatMode(repeatMode);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) =>
      activePlayer.setShuffleMode(shuffleMode);

  @override
  Future<void> setSpeed(double speed) => activePlayer.setSpeed(speed);

  @override
  Future<void> click([MediaButton button = MediaButton.media]) =>
      activePlayer.click(button);

  @override
  Future<void> prepare() => activePlayer.prepare();

  @override
  Future<void> prepareFromMediaId(
    String mediaId, [
    Map<String, dynamic>? extras,
  ]) {
    switchTo(autoPlayer);
    return autoPlayer.prepareFromMediaId(mediaId, extras);
  }

  @override
  Future<void> prepareFromSearch(String query, [Map<String, dynamic>? extras]) {
    switchTo(autoPlayer);
    return autoPlayer.prepareFromSearch(query, extras);
  }

  @override
  Future<void> prepareFromUri(Uri uri, [Map<String, dynamic>? extras]) {
    switchTo(autoPlayer);
    return autoPlayer.prepareFromUri(uri, extras);
  }

  @override
  Future<void> fastForward() => activePlayer.fastForward();

  @override
  Future<void> rewind() => activePlayer.rewind();

  @override
  Future<void> addQueueItem(MediaItem mediaItem) =>
      activePlayer.addQueueItem(mediaItem);

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) =>
      activePlayer.addQueueItems(mediaItems);

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) =>
      activePlayer.insertQueueItem(index, mediaItem);

  @override
  Future<void> updateQueue(List<MediaItem> queue) =>
      activePlayer.updateQueue(queue);

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) =>
      activePlayer.updateMediaItem(mediaItem);

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) =>
      activePlayer.removeQueueItem(mediaItem);

  @override
  Future<void> removeQueueItemAt(int index) =>
      activePlayer.removeQueueItemAt(index);

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) =>
      activePlayer.customAction(name, extras);

  @override
  Future<void> onTaskRemoved() => activePlayer.onTaskRemoved();

  @override
  Future<void> onNotificationDeleted() => activePlayer.onNotificationDeleted();
}
