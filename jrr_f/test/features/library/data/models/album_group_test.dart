import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/data/models/album_group.dart';

Album _album({
  String name = 'Best',
  String parent = '/Music/Artist/',
  String date = '',
  int discNumber = 0,
  int totalDiscs = 0,
}) => Album(
  name: name,
  albumArtist: 'Artist',
  folderPath: '$parent$name/',
  parentFolderPath: parent,
  albumGroupId: '${name.toLowerCase()}|$parent',
  date: date,
  discNumber: discNumber,
  totalDiscs: totalDiscs,
);

void main() {
  group('AlbumGroup', () {
    test('isMultiDisc reflects discs.length > 1', () {
      final base = _album();
      expect(AlbumGroup(album: base, discs: const []).isMultiDisc, isFalse);
      expect(AlbumGroup(album: base, discs: [base]).isMultiDisc, isFalse);
      expect(
        AlbumGroup(
          album: base,
          discs: [base, _album(discNumber: 2)],
        ).isMultiDisc,
        isTrue,
      );
    });

    test('id lowercases album name and parent path', () {
      final group = AlbumGroup(
        album: _album(name: 'Mixed Case', parent: '/Music/Artist/'),
      );
      expect(group.id, 'mixed case|/music/artist/');
    });

    test('date returns album date when there are no discs', () {
      final group = AlbumGroup(album: _album(date: '2020'));
      expect(group.date, '2020');
    });

    test('date returns latest non-empty disc date when discs exist', () {
      final group = AlbumGroup(
        album: _album(date: '2018'),
        discs: [
          _album(date: '2019', discNumber: 1),
          _album(date: '', discNumber: 2),
          _album(date: '2021', discNumber: 3),
        ],
      );
      expect(group.date, '2021');
    });

    test('date falls back to album date if all discs are empty', () {
      final group = AlbumGroup(
        album: _album(date: '2018'),
        discs: [_album(date: '', discNumber: 1)],
      );
      expect(group.date, '2018');
    });

    test('sorted builds discs in ascending disc number order', () {
      final group = AlbumGroup.sorted(
        album: _album(),
        discs: [
          _album(discNumber: 3),
          _album(discNumber: 1),
          _album(discNumber: 2),
        ],
      );
      expect(group.discs.map((d) => d.discNumber), [1, 2, 3]);
    });

    test('sorted does not mutate caller list', () {
      final input = [_album(discNumber: 2), _album(discNumber: 1)];
      AlbumGroup.sorted(album: _album(), discs: input);
      expect(input.map((d) => d.discNumber), [2, 1]);
    });

    test('equality compares album and discs deeply', () {
      final a = AlbumGroup(
        album: _album(),
        discs: [_album(discNumber: 1), _album(discNumber: 2)],
      );
      final b = AlbumGroup(
        album: _album(),
        discs: [_album(discNumber: 1), _album(discNumber: 2)],
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality when discs differ', () {
      final a = AlbumGroup(album: _album(), discs: [_album(discNumber: 1)]);
      final b = AlbumGroup(album: _album(), discs: [_album(discNumber: 2)]);
      expect(a, isNot(equals(b)));
    });
  });
}
