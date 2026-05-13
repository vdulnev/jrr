import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

/// Mirrors every Talker log line to a file in the app-support directory.
///
/// The file is truncated on each app start so it always contains only the
/// current session. Writes are buffered in-memory and flushed off the main
/// isolate on a periodic timer — the player path emits many logs per second
/// once audio_service is active, and synchronous `flush: true` writes per
/// line block the platform channel enough to stutter audio.
class FileLogObserver extends TalkerObserver {
  static const _logFileName = 'jrr_app.log';
  static const _flushInterval = Duration(milliseconds: 500);

  static String? _logPath;
  static final StringBuffer _pending = StringBuffer();
  static Timer? _flushTimer;
  static bool _flushing = false;

  /// Path of the active log file, or null before [init] runs.
  static String? get logFilePath => _logPath;

  /// Creates the log file in [getApplicationSupportDirectory] and truncates
  /// any previous contents. Call once during app startup before constructing
  /// the [Talker].
  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    final path = '${dir.path}/$_logFileName';
    // Truncate-and-write the header in a single sync call. This both creates
    // the file (if absent) and resets any prior content.
    File(path).writeAsStringSync(
      '--- JRR log session ${DateTime.now().toIso8601String()} ---\n',
      flush: true,
    );
    _logPath = path;
  }

  /// Force-flush any pending log lines to disk. Awaits the write so
  /// callers (e.g. log export) see a complete file.
  static Future<void> flush() async {
    if (_pending.isEmpty || _flushing) return;
    await _flush();
  }

  @override
  void onLog(TalkerData log) => _appendLine(log);

  @override
  void onError(TalkerError err) => _appendLine(err);

  @override
  void onException(TalkerException err) => _appendLine(err);

  void _appendLine(TalkerData data) {
    if (_logPath == null) return;
    final ts = data.time.toIso8601String();
    final level = data.logLevel?.name ?? data.title ?? 'log';
    final msg = data.generateTextMessage();
    final stack = data.stackTrace;
    _pending
      ..write(ts)
      ..write(' [')
      ..write(level)
      ..write('] ')
      ..writeln(msg);
    if (stack != null) _pending.writeln(stack);
    _scheduleFlush();
  }

  static void _scheduleFlush() {
    _flushTimer ??= Timer(_flushInterval, () {
      _flushTimer = null;
      _flush();
    });
  }

  static Future<void> _flush() async {
    final path = _logPath;
    if (path == null || _pending.isEmpty || _flushing) return;
    _flushing = true;
    final chunk = _pending.toString();
    _pending.clear();
    try {
      await File(path).writeAsString(chunk, mode: FileMode.append);
    } catch (_) {
      // Logging must never break the app — swallow disk errors silently.
    } finally {
      _flushing = false;
    }
  }
}
