import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Stores the last [_maxEntries] file keys played, most-recent first.
///
/// Backed by `SharedPreferences` — small payload (≤100 ints), and we don't
/// need cross-app durability, so a JSON-encoded list under a single key is
/// sufficient. The Android Auto browse tree's "Recent" category reads from
/// this repository; phone-side UI may grow other uses later.
class RecentlyPlayedRepository {
  RecentlyPlayedRepository(this._prefs);

  static const _kKey = 'recently_played_file_keys';
  static const _maxEntries = 100;

  final SharedPreferences _prefs;

  /// Returns file keys ordered most-recent first.
  List<int> getRecent() {
    final raw = _prefs.getString(_kKey);
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      return decoded
          .map((e) => e is int ? e : int.tryParse(e.toString()))
          .whereType<int>()
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  /// Pushes [fileKey] onto the front of the list, dedupes, and caps the
  /// stored history at [_maxEntries].
  Future<void> markPlayed(int fileKey) async {
    final current = getRecent();
    if (current.isNotEmpty && current.first == fileKey) {
      // Hot-loop guard: just-played track shouldn't churn storage on every
      // position update or accidental re-emission of the same MediaItem.
      return;
    }
    final next = <int>[fileKey, ...current.where((k) => k != fileKey)];
    if (next.length > _maxEntries) next.removeRange(_maxEntries, next.length);
    await _prefs.setString(_kKey, jsonEncode(next));
  }

  Future<void> clear() => _prefs.remove(_kKey);
}
