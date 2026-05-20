import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:talker/talker.dart';

import '../../player/services/android_auto_player_service.dart';
import '../../player/services/jrr_audio_handler.dart';

/// Tracks whether an Android Auto (or other `MediaBrowserService`) client is
/// currently bound to the audio handler.
class AndroidAutoSessionService {
  static const _channel = MethodChannel('com.jrr.jrr_f/android_auto');

  final Talker _talker;

  /// Resolves the [JrrAudioHandler] lazily. Returns `null` when the handler
  /// isn't ready yet (e.g. early `onConnectionChanged` signals during the
  /// audio_service.init bootstrap). Late wiring is unavoidable: this service
  /// is constructed before the audio handlers exist so the zone repository
  /// can read `isConnected` at any time.
  final JrrAudioHandler? Function() _handlerResolver;
  final AndroidAutoPlayerService? Function() _autoPlayerResolver;

  AndroidAutoSessionService({
    required Talker talker,
    required JrrAudioHandler? Function() handlerResolver,
    required AndroidAutoPlayerService? Function() autoPlayerResolver,
  }) : _talker = talker,
       _handlerResolver = handlerResolver,
       _autoPlayerResolver = autoPlayerResolver {
    _setupMethodChannel();

    // We don't call _checkInitialConnection here anymore to avoid any
    // potential hang during startup, especially in the background isolate.
    // The native observer will send the state via onConnectionChanged.

    _talker.info(
      '[AndroidAutoSessionService] constructed — waiting for signals',
    );
  }

  void _setupMethodChannel() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onConnectionChanged') {
        final isConnectedArg = call.arguments as bool;
        _talker.info(
          '[AndroidAutoSessionService] Native connection signal: $isConnectedArg',
        );
        if (isConnectedArg) {
          // Native signal is direct and reliable for the UI isolate.
          markActive(isDirectSignal: true);
        } else {
          markInactive();
        }
      }
    });
  }

  /// Reactive flag. Riverpod's [androidAutoConnectedProvider] mirrors this
  /// notifier so the zone list refreshes on connect/disconnect.
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  /// Called when the native `CarConnection` observer reports a connected
  /// head unit.
  ///
  /// [isDirectSignal] indicates the call came from the native MethodChannel,
  /// not an inferred ping. Today every real call sets it to `true`; the
  /// parameter is kept so we can layer in a browse-ping path later without
  /// changing the surface.
  void markActive({bool isDirectSignal = false}) {
    if (isConnected.value) {
      _talker.debug(
        '[AndroidAutoSessionService] markActive: state refreshed (direct=$isDirectSignal)',
      );
      return;
    }
    _talker.info(
      '[AndroidAutoSessionService] markActive: session connected (direct=$isDirectSignal)',
    );
    // Swap the active audio handler synchronously, before Riverpod has a
    // chance to rebuild the zone tree. The MediaBrowserService bind that
    // arrives at the same time triggers `startForegroundService()`, and
    // we have ~5s to call `startForeground()` from a handler whose
    // `playbackState` is foreground-eligible. The AA player seeds such
    // a state on construction; the local player does not.
    _activateAutoHandler();
    isConnected.value = true;
  }

  void _activateAutoHandler() {
    final handler = _handlerResolver();
    final autoPlayer = _autoPlayerResolver();
    if (handler == null || autoPlayer == null) {
      // Audio handlers may not be constructed yet on early signals; fall
      // through and let the Riverpod-driven swap handle it. No FGS contract
      // is open yet.
      return;
    }
    try {
      handler.switchTo(autoPlayer);
    } catch (e, st) {
      _talker.error(
        '[AndroidAutoSessionService] _activateAutoHandler failed',
        e,
        st,
      );
    }
  }

  /// Explicit disconnect from the native `CarConnection` observer.
  void markInactive() {
    if (!isConnected.value) return;
    _talker.info('[AndroidAutoSessionService] Session disconnected');
    isConnected.value = false;
  }

  void dispose() {
    isConnected.dispose();
  }
}
