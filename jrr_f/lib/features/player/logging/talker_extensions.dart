import 'package:just_audio/just_audio.dart';
import 'package:talker/talker.dart';
import 'sequence_state_log.dart';

extension PlayerTalkerExtension on Talker {
  /// Custom logger specifically for SequenceState.
  /// Automatically uses the SequenceStateLog formatter.
  void sequenceState(SequenceState? state) {
    if (state != null) {
      logCustom(SequenceStateLog(state));
    } else {
      debug('SequenceState: null');
    }
  }
}
