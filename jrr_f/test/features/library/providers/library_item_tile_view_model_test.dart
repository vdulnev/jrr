import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/library/providers/library_item_tile_view_model.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/providers/download_status_provider.dart';
import 'package:jrr_f/features/zones/providers/active_zone_provider.dart';

void main() {
  ProviderContainer open({
    bool isOffline = false,
    DownloadState downloadState = DownloadState.notDownloaded,
  }) {
    final container = ProviderContainer(
      overrides: [
        isOfflineActiveProvider.overrideWith((ref) => isOffline),
        downloadStatusProvider(42).overrideWith((ref) => downloadState),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('reflects isOffline and download state', () {
    final c = open(isOffline: true, downloadState: DownloadState.running);
    final state = c.read(libraryItemTileViewModelProvider(42));
    expect(state.isOffline, isTrue);
    expect(state.downloadState, DownloadState.running);
  });

  test('defaults are inert when nothing is downloaded and online', () {
    final c = open();
    final state = c.read(libraryItemTileViewModelProvider(42));
    expect(state.isOffline, isFalse);
    expect(state.downloadState, DownloadState.notDownloaded);
  });
}
