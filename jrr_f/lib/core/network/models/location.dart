extension type const Location._(String _value) implements String {
  /// Insert after the currently playing track.
  static const next = Location._('NEXT');

  /// Append to the end of the queue.
  static const end = Location._('END');

  /// Insert at the beginning of the queue.
  static const start = Location._('-1');

  /// Insert at a specific zero-based queue index.
  factory Location.index(int index) {
    if (index < 0) {
      return const Location._('-1');
    }
    return Location._(index.toString());
  }

  /// Parse a raw string back into a [Location],
  /// Returns -1 if value is not parsed
  factory Location.parse(String value) {
    if (value == 'NEXT') return next;
    if (value == 'END') return end;
    final n = int.tryParse(value);
    if (n != null && n >= 0) {
      return Location._(value);
    } else {
      return const Location._('-1');
    }
  }
}
