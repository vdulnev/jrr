import 'package:just_audio/just_audio.dart';
import 'package:talker/talker.dart';
import '../../library/data/models/track.dart';

class SequenceStateLog extends TalkerLog {
  SequenceStateLog(this.state) : super('SequenceState updated');

  final SequenceState state;

  @override
  String get message {
    final track = state.currentSource?.tag as Track?;
    final trackInfo = track != null
        ? '${track.name} (Key: ${track.fileKey})'
        : 'None';

    return 'INDEX: ${state.currentIndex}\n'
        'QUEUE SIZE: ${state.sequence.length}\n'
        'CURRENT TRACK: $trackInfo\n'
        'SHUFFLE INDICES: ${state.shuffleIndices}';
  }

  @override
  String get key => 'sequence-state';

  @override
  LogLevel get logLevel => LogLevel.debug;

  @override
  AnsiPen? get pen => AnsiPen()..blue();

  /// Utility to log any instance of SequenceState
  static void logIfSequence(Talker talker, dynamic obj) {
    if (obj is SequenceState) {
      talker.logCustom(SequenceStateLog(obj));
    }
  }
}
