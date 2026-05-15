import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/player/data/repositories/recently_played_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;
  late RecentlyPlayedRepository repo;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    repo = RecentlyPlayedRepository(prefs);
  });

  test('getRecent returns empty when nothing stored', () {
    expect(repo.getRecent(), isEmpty);
  });

  test('markPlayed pushes most-recent to the front', () async {
    await repo.markPlayed(1);
    await repo.markPlayed(2);
    await repo.markPlayed(3);
    expect(repo.getRecent(), [3, 2, 1]);
  });

  test('markPlayed dedupes — re-playing moves to front', () async {
    await repo.markPlayed(1);
    await repo.markPlayed(2);
    await repo.markPlayed(3);
    await repo.markPlayed(2);
    expect(repo.getRecent(), [2, 3, 1]);
  });

  test('markPlayed of the most-recent track is a no-op', () async {
    await repo.markPlayed(7);
    final before = prefs.getString('recently_played_file_keys');
    await repo.markPlayed(7);
    final after = prefs.getString('recently_played_file_keys');
    // No write — the head-dedupe guard avoids touching SharedPreferences.
    expect(after, before);
  });

  test('history caps at 100 entries', () async {
    for (var i = 1; i <= 120; i++) {
      await repo.markPlayed(i);
    }
    final recent = repo.getRecent();
    expect(recent.length, 100);
    expect(recent.first, 120);
    expect(recent.last, 21);
  });

  test('survives corrupt stored payload', () async {
    await prefs.setString('recently_played_file_keys', 'not-json');
    expect(repo.getRecent(), isEmpty);
  });

  test('clear empties the history', () async {
    await repo.markPlayed(5);
    await repo.clear();
    expect(repo.getRecent(), isEmpty);
  });
}
