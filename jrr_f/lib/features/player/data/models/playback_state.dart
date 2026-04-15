enum PlaybackState {
  stopped,
  paused,
  playing;

  static PlaybackState fromMcws(String value) => switch (value) {
    '2' => playing,
    '1' => paused,
    _ => stopped,
  };
}
