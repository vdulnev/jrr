import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker/talker.dart';

import '../../../core/di/injection.dart';
import '../../offline/providers/downloaded_tracks_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/album.dart';
import '../data/models/album_group.dart';
import '../data/models/albums.dart';
import '../data/models/browse_item.dart';
import '../data/models/track.dart';
import '../data/models/tracks.dart';
import '../data/repositories/library_repository.dart';

part 'library_providers.g.dart';

@riverpod
Future<Tracks> librarySearch(Ref ref, String query) async {
  if (query.trim().isEmpty) return Tracks.empty;
  if (ref.watch(isOfflineActiveProvider)) return Tracks.empty;
  final result = await getIt<LibraryRepository>().search(query.trim());
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<String>> artists(Ref ref) async {
  if (ref.watch(isOfflineActiveProvider)) return const [];
  final result = await getIt<LibraryRepository>().getArtists();
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<Albums> albumsByArtist(Ref ref, String artist) async {
  if (ref.watch(isOfflineActiveProvider)) return Albums.empty;
  final result = await getIt<LibraryRepository>().getAlbumsByArtist(artist);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<AlbumGroup>> albumGroupsByArtist(Ref ref, String artist) async {
  final albums = await ref.watch(albumsByArtistProvider(artist).future);
  return _buildAlbumGroups(artist, albums);
}

List<AlbumGroup> _buildAlbumGroups(String artist, Albums albums) {
  final talker = getIt<Talker>();
  const tag = '[albumGroupsByArtist]';

  talker.debug('$tag [$artist] Received ${albums.length} album row(s)');
  for (final a in albums.albums) {
    talker.debug(
      '$tag [$artist]   row: name="${a.name}" '
      'disc=${a.discNumber}/${a.totalDiscs} '
      'date="${a.date}" '
      'folderPath="${a.folderPath}" '
      'parentFolderPath="${a.parentFolderPath}"',
    );
  }

  final sortedAlbums = [...albums.albums]
    ..sort((a, b) => a.name.compareTo(b.name));

  final discBuckets = <String, List<Album>>{};
  final singles = <Album>[];

  for (final album in sortedAlbums) {
    final isMultiDiscRow =
        album.totalDiscs > 1 &&
        album.discNumber > 0 &&
        album.parentFolderPath.isNotEmpty;
    if (isMultiDiscRow) {
      final key =
          '${album.name.toLowerCase()}|${album.parentFolderPath.toLowerCase()}';
      discBuckets.putIfAbsent(key, () => []).add(album);
      talker.debug(
        '$tag [$artist] disc-bucket "$key" '
        '+= disc ${album.discNumber}/${album.totalDiscs}',
      );
    } else {
      singles.add(album);
      talker.debug(
        '$tag [$artist] single-bucket += "${album.name}" '
        '(disc=${album.discNumber}/${album.totalDiscs}, '
        'parentFolderPath="${album.parentFolderPath}")',
      );
    }
  }

  talker.debug(
    '$tag [$artist] Buckets: ${discBuckets.length} disc-group(s), '
    '${singles.length} single(s)',
  );

  final groups = <AlbumGroup>[];

  for (final entry in discBuckets.entries) {
    final discs = entry.value
      ..sort((a, b) => a.discNumber.compareTo(b.discNumber));

    if (discs.length > 1) {
      final first = discs.first;
      final latestDate =
          discs.map((d) => d.date).where((d) => d.isNotEmpty).toList()..sort();
      final parent = first.copyWith(
        folderPath: first.parentFolderPath,
        discNumber: 0,
        date: latestDate.isNotEmpty ? latestDate.last : first.date,
      );
      groups.add(AlbumGroup(album: parent, discs: discs));
      talker.debug(
        '$tag [$artist] Multi-disc group "${entry.key}" → '
        '${discs.length} disc(s), parent.date="${parent.date}"',
      );
    } else {
      groups.add(AlbumGroup(album: discs.first));
      talker.debug(
        '$tag [$artist] Disc-bucket "${entry.key}" had only 1 disc — '
        'treating as single album',
      );
    }
  }

  for (final album in singles) {
    groups.add(AlbumGroup(album: album));
  }

  groups.sort((a, b) {
    final dateCompare = a.date.compareTo(b.date);
    if (dateCompare != 0) return dateCompare;
    return a.album.name.compareTo(b.album.name);
  });

  talker.info(
    '$tag [$artist] Built ${groups.length} group(s) from '
    '${albums.length} row(s)',
  );
  for (final g in groups) {
    talker.debug(
      '$tag [$artist]   group: "${g.album.name}" '
      'date="${g.date}" '
      'multiDisc=${g.isMultiDisc} '
      'discs=${g.discs.length}',
    );
  }

  return groups;
}

@riverpod
Future<Tracks> albumTracks(Ref ref, Album album) async {
  if (ref.watch(isOfflineActiveProvider)) return Tracks.empty;
  final result = await getIt<LibraryRepository>().getAlbumTracks(album);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<Tracks> folderTracks(Ref ref, String folderPath) async {
  if (ref.watch(isOfflineActiveProvider)) return Tracks.empty;
  final result = await getIt<LibraryRepository>().getTracksByFolder(folderPath);
  return result.getOrElse((e) => throw e);
}

@Riverpod(keepAlive: true)
Future<Albums> randomAlbums(Ref ref) async {
  if (ref.watch(isOfflineActiveProvider)) return Albums.empty;
  final result = await getIt<LibraryRepository>().getRandomAlbums();
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<BrowseItem>> browseChildren(Ref ref, String id) async {
  if (ref.watch(isOfflineActiveProvider)) return const [];
  final result = await getIt<LibraryRepository>().browseChildren(id);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<Tracks> browseFiles(Ref ref, String id) async {
  if (ref.watch(isOfflineActiveProvider)) return Tracks.empty;
  final result = await getIt<LibraryRepository>().browseFiles(id);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<Track?> searchByFileKey(Ref ref, int fileKey) async {
  if (ref.watch(isOfflineActiveProvider)) {
    final downloaded = await ref.watch(downloadedTracksProvider.future);
    final match = downloaded
        .where((t) => t.track.fileKey == fileKey)
        .firstOrNull;
    return match?.track;
  }
  final result = await getIt<LibraryRepository>().searchByFileKey(fileKey);
  return result.getOrElse((e) => throw e);
}

enum BrowseScope { browse, favorites }

@Riverpod(keepAlive: true)
class BrowseNavigationStack extends _$BrowseNavigationStack {
  @override
  List<BrowseItem> build(BrowseScope scope) {
    return switch (scope) {
      BrowseScope.browse => [const BrowseItem(id: '-1', name: 'Browse')],
      BrowseScope.favorites => [],
    };
  }

  void push(BrowseItem level) {
    state = [...state, level];
  }

  void pop() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void reset() {
    state = [];
  }

  void navigateToBreadcrumb(int index) {
    if (index == -1) {
      state = [];
    } else if (index >= 0 && index < state.length - 1) {
      state = state.sublist(0, index + 1);
    }
  }
}
