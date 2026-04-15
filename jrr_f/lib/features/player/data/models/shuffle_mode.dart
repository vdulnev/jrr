enum ShuffleMode {
  off,
  on,
  automatic;

  static ShuffleMode fromMcws(String value) => switch (value.toLowerCase()) {
    'on' => ShuffleMode.on,
    'automatic' => ShuffleMode.automatic,
    _ => ShuffleMode.off,
  };

  String toMcws() => switch (this) {
    ShuffleMode.off => 'Off',
    ShuffleMode.on => 'On',
    ShuffleMode.automatic => 'Automatic',
  };
}
