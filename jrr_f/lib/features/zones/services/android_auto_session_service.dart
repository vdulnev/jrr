import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';

/// Tracks whether an Android Auto (or other `MediaBrowserService`) client is
/// currently bound to the audio handler.
///
/// `audio_service` does not surface a "car connected" callback to Dart. The
/// signal we have is `AudioHandler.getChildren` (and, in later phases,
/// `getMediaItem` / `search` / `playFromMediaId`) — Auto only invokes those
/// while it is bound. We treat any of those calls as proof the session is
/// live, and fall back to a debounce timer to mark it inactive if no
/// browse-side activity arrives for [_inactivityTimeout].
///
/// The 5-minute debounce is intentionally long: once Auto has fetched the
/// root browse hierarchy it caches results aggressively and may go quiet for
/// minutes at a time while the user is mid-playlist. A shorter timeout
/// would falsely flip the zone away from the picker while the car is still
/// connected.
class AndroidAutoSessionService {
  AndroidAutoSessionService() {
    // Construction-time log so adb logcat shows the service is wired up
    // even before any MediaBrowser ping arrives. If you never see a
    // subsequent "markActive" line, the issue is upstream — Auto isn't
    // binding to our MediaBrowserService at all (see the §6 / Phase 9
    // checklists for likely causes: developer mode in Auto, stale APK
    // cache, app not yet allow-listed).
    if (getIt.isRegistered<Talker>()) {
      getIt<Talker>().info(
        '[AndroidAutoSessionService] constructed — waiting for first '
        'MediaBrowser ping from Android Auto',
      );
    }
  }

  static const _inactivityTimeout = Duration(minutes: 5);

  /// Reactive flag. Riverpod's [androidAutoConnectedProvider] mirrors this
  /// notifier so the zone list refreshes on connect/disconnect.
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  Timer? _timeout;

  // Lazy because the service is constructed inside configureDependencies(),
  // and on its first construction Talker may not be registered yet on some
  // code paths (e.g. tests that build the service directly).
  Talker? get _talker => getIt.isRegistered<Talker>() ? getIt<Talker>() : null;

  /// Called from `AndroidAutoPlayerService.getChildren` (and any other
  /// browse-side audio_service callback) when a MediaBrowser client pings
  /// the handler. Flips [isConnected] to `true` on the first call and
  /// resets the inactivity debounce on every subsequent call.
  void markActive() {
    final wasConnected = isConnected.value;
    _timeout?.cancel();
    _timeout = Timer(_inactivityTimeout, () {
      _talker?.info(
        '[AndroidAutoSessionService] Inactivity timeout fired after '
        '${_inactivityTimeout.inMinutes}m — marking disconnected',
      );
      _markInactive();
    });
    if (!wasConnected) {
      _talker?.info(
        '[AndroidAutoSessionService] markActive: first ping from a '
        'MediaBrowser client — session connected',
      );
      isConnected.value = true;
    } else {
      _talker?.debug(
        '[AndroidAutoSessionService] markActive: refreshing inactivity '
        'debounce (was already connected)',
      );
    }
  }

  /// Explicit disconnect — intended for a future platform-channel hook on
  /// `MediaBrowserService.onUnbind`. Not yet wired; left here so callers
  /// further up the stack (e.g. logout, app shutdown) can clear the flag
  /// without waiting for the debounce.
  void markInactive() {
    _talker?.info(
      '[AndroidAutoSessionService] markInactive: explicit disconnect '
      '(was connected=${isConnected.value})',
    );
    _timeout?.cancel();
    _timeout = null;
    _markInactive();
  }

  void _markInactive() {
    if (isConnected.value) {
      _talker?.info(
        '[AndroidAutoSessionService] Session disconnected — clearing flag',
      );
      isConnected.value = false;
    }
  }

  @visibleForTesting
  Duration get inactivityTimeout => _inactivityTimeout;

  void dispose() {
    _timeout?.cancel();
    isConnected.dispose();
  }
}
