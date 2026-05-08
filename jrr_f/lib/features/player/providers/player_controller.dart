import '../../library/data/models/tracks.dart';
import '../../zones/data/models/zone.dart';

/// Common command surface implemented by every concrete player notifier
/// (`LocalPlayer`, `McwsPlayer`, ...).
///
/// Lets the unified [Player] notifier dispatch by zone once and forward each
/// command as a one-liner, instead of branching on zone locality at every
/// call site.
abstract interface class PlayerController {
  Future<void> playPause();

  /// Stops playback. [zoneToRun] is meaningful only for transports that can
  /// address a specific zone (MCWS); local transports ignore it.
  Future<void> stop({Zone? zoneToRun});

  Future<void> next();
  Future<void> previous();
  Future<void> seekTo(int positionMs);
  Future<void> setVolume(double level);
  Future<void> toggleMute();
  Future<void> toggleShuffle();
  Future<void> playByIndex(int index);
  Future<void> cycleRepeat();
  Future<void> playNow(Tracks tracks);
  Future<void> playNext(Tracks tracks);
  Future<void> addToQueue(Tracks tracks);

  /// Refreshes status from the underlying transport. No-op for transports
  /// that already push state via streams.
  Future<void> refresh();
}
