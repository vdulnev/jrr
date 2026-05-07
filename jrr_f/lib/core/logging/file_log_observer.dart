import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:talker/talker.dart';

/// Mirrors every Talker log line to a file in the app-support directory.
///
/// The file is truncated on each app start so it always contains only the
/// current session. Writes are synchronous and flushed per line — the volume
/// of logs in a remote-control app is small enough that the cost is
/// negligible, and it eliminates the IOSink-buffering pitfalls (file may be
/// empty or missing on disk when another process tries to read it).
class FileLogObserver extends TalkerObserver {
  static const _logFileName = 'jrr_app.log';

  static String? _logPath;

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

  /// No-op kept for API compatibility — writes are flushed per line.
  static Future<void> flush() async {}

  @override
  void onLog(TalkerData log) => _appendLine(log);

  @override
  void onError(TalkerError err) => _appendLine(err);

  @override
  void onException(TalkerException err) => _appendLine(err);

  void _appendLine(TalkerData data) {
    final path = _logPath;
    if (path == null) return;
    try {
      final ts = data.time.toIso8601String();
      final level = data.logLevel?.name ?? data.title ?? 'log';
      final msg = data.generateTextMessage();
      final stack = data.stackTrace;
      final buffer = StringBuffer()
        ..write(ts)
        ..write(' [')
        ..write(level)
        ..write('] ')
        ..writeln(msg);
      if (stack != null) buffer.writeln(stack);
      File(path).writeAsStringSync(
        buffer.toString(),
        mode: FileMode.append,
        flush: true,
      );
    } catch (_) {
      // Logging must never break the app — swallow disk errors silently.
    }
  }
}
