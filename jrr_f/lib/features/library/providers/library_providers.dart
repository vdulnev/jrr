import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/injection.dart';
import '../data/models/album.dart';
import '../data/models/library_item.dart';
import '../data/repositories/library_repository.dart';

part 'library_providers.g.dart';

@riverpod
Future<List<LibraryItem>> librarySearch(Ref ref, String query) async {
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
Future<List<LibraryItem>> albumTracks(Ref ref, Album album) async {
  final result = await getIt<LibraryRepository>().getAlbumTracks(album);
  return result.getOrElse((e) => throw e);
}
