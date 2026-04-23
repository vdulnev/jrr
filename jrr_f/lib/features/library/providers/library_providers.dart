import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/album.dart';
import '../data/models/browse_item.dart';
import '../data/models/track.dart';
import '../data/repositories/library_repository.dart';

part 'library_providers.g.dart';

@riverpod
Future<List<Track>> librarySearch(Ref ref, String query) async {
  if (query.trim().isEmpty) return [];
  final result = await getIt<LibraryRepository>().search(query.trim());
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<String>> artists(Ref ref) async {
  final result = await getIt<LibraryRepository>().getArtists();
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<Album>> albumsByArtist(Ref ref, String artist) async {
  final result = await getIt<LibraryRepository>().getAlbumsByArtist(artist);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<Track>> albumTracks(Ref ref, Album album) async {
  final result = await getIt<LibraryRepository>().getAlbumTracks(album);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<Track>> folderTracks(Ref ref, String folderPath) async {
  final result = await getIt<LibraryRepository>().getTracksByFolder(folderPath);
  return result.getOrElse((e) => throw e);
}

@Riverpod(keepAlive: true)
Future<List<Album>> randomAlbums(Ref ref) async {
  final result = await getIt<LibraryRepository>().getRandomAlbums();
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<BrowseItem>> browseChildren(Ref ref, String id) async {
  final result = await getIt<LibraryRepository>().browseChildren(id);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<List<Track>> browseFiles(Ref ref, String id) async {
  final result = await getIt<LibraryRepository>().browseFiles(id);
  return result.getOrElse((e) => throw e);
}

@riverpod
Future<Track?> searchByFileKey(Ref ref, int fileKey) async {
  final result = await getIt<LibraryRepository>().searchByFileKey(fileKey);
  return result.getOrElse((e) => throw e);
}

@Riverpod(keepAlive: true)
class LibraryTabIndex extends _$LibraryTabIndex {
  @override
  int build() => 0;

  void set(int index) => state = index;
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
