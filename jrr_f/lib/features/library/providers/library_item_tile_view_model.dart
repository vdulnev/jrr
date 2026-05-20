import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/di/providers.dart';
import '../../offline/providers/download_status_provider.dart';
import '../../player/providers/player_provider.dart';
import '../../zones/providers/active_zone_provider.dart';
import '../data/models/track.dart';
import '../data/models/tracks.dart';
import 'library_item_tile_view_state.dart';

part 'library_item_tile_view_model.g.dart';

@riverpod
class LibraryItemTileViewModel extends _$LibraryItemTileViewModel {
  @override
  LibraryItemTileViewState build(int fileKey) {
    final isOffline = ref.watch(isOfflineActiveProvider);
    final downloadState = ref.watch(downloadStatusProvider(fileKey));
    return LibraryItemTileViewState(
      isOffline: isOffline,
      downloadState: downloadState,
    );
  }

  Future<void> playNow(Track track) =>
      ref.read(playerProvider.notifier).playNow(Tracks(tracks: [track]));

  Future<void> playNext(Track track) =>
      ref.read(playerProvider.notifier).playNext(Tracks(tracks: [track]));

  Future<void> addToQueue(Track track) =>
      ref.read(playerProvider.notifier).addToQueue(Tracks(tracks: [track]));

  void enqueueDownload(Track track) =>
      ref.read(downloadsRepositoryProvider).enqueue(track);

  void cancelDownload(int fileKey) =>
      ref.read(downloadsRepositoryProvider).cancel(fileKey);

  Future<void> deleteDownload(int fileKey) =>
      ref.read(downloadsRepositoryProvider).delete(fileKey);
}
