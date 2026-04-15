enum RepeatMode {
  off,
  playlist,
  track;

  static RepeatMode fromMcws(String value) => switch (value.toLowerCase()) {
    'playlist' => RepeatMode.playlist,
    'track' => RepeatMode.track,
    _ => RepeatMode.off,
  };

  String toMcws() => switch (this) {
    RepeatMode.off => 'Off',
    RepeatMode.playlist => 'Playlist',
    RepeatMode.track => 'Track',
  };
}
