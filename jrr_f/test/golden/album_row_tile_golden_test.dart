import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/theme/app_theme.dart';
import 'package:jrr_f/features/connection/providers/session_provider.dart';
import 'package:jrr_f/features/connection/providers/session_state.dart';
import 'package:jrr_f/features/library/data/models/album.dart';
import 'package:jrr_f/features/library/providers/album_row_tile_view_model.dart';
import 'package:jrr_f/features/library/providers/album_row_tile_view_state.dart';
import 'package:jrr_f/features/library/widgets/album_row_tile.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';
import 'package:jrr_f/features/offline/providers/download_status_provider.dart';

class _Session extends Session {
  @override
  SessionState build() => const SessionState.unauthenticated();
}

class _StubVm extends AlbumRowTileViewModel {
  _StubVm(this._state);
  final AlbumRowTileViewState _state;
  @override
  AlbumRowTileViewState build(Album album) => _state;
}

const _album = Album(
  name: 'The Dark Side of the Moon',
  albumArtist: 'Pink Floyd',
  folderPath: '/Music/Pink Floyd/Dark Side',
  parentFolderPath: '/Music/Pink Floyd',
  albumGroupId: 'pf-dsotm',
  date: '1973',
  artworkFileKey: -1,
);

Widget _harness({
  required AlbumRowTileViewState vmState,
  DownloadState downloadStatus = DownloadState.notDownloaded,
  double downloadProgress = 0.0,
  double width = 380,
}) {
  return ProviderScope(
    overrides: [
      sessionProvider.overrideWith(() => _Session()),
      albumRowTileViewModelProvider(
        _album,
      ).overrideWith(() => _StubVm(vmState)),
      albumDownloadStatusProvider(
        _album.albumGroupId,
      ).overrideWith((ref) => downloadStatus),
      albumDownloadProgressProvider(
        _album.albumGroupId,
      ).overrideWith((ref) => downloadProgress),
    ],
    child: MaterialApp(
      theme: buildAppTheme(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.bg1,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width,
              // Tapping triggers context.router.push, but we never tap in
              // these goldens — only render-and-snapshot.
              child: const AlbumRowTile(album: _album),
            ),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('AlbumRowTile — default (no downloads, online)', (tester) async {
    await tester.pumpWidget(
      _harness(
        vmState: const AlbumRowTileViewState(
          isOffline: false,
          showDownload: true,
          showCancel: false,
          showDelete: false,
          showRetry: false,
          hidden: false,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(AlbumRowTile),
      matchesGoldenFile('goldens/album_row_default.png'),
    );
  });

  testWidgets('AlbumRowTile — downloading (running)', (tester) async {
    await tester.pumpWidget(
      _harness(
        vmState: const AlbumRowTileViewState(
          isOffline: false,
          showDownload: false,
          showCancel: true,
          showDelete: false,
          showRetry: false,
          hidden: false,
        ),
        downloadStatus: DownloadState.running,
        downloadProgress: 0.42,
      ),
    );
    await tester.pump(const Duration(milliseconds: 260));
    await expectLater(
      find.byType(AlbumRowTile),
      matchesGoldenFile('goldens/album_row_downloading.png'),
    );
  });

  testWidgets('AlbumRowTile — fully downloaded with delete', (tester) async {
    await tester.pumpWidget(
      _harness(
        vmState: const AlbumRowTileViewState(
          isOffline: false,
          showDownload: false,
          showCancel: false,
          showDelete: true,
          showRetry: false,
          hidden: false,
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(AlbumRowTile),
      matchesGoldenFile('goldens/album_row_downloaded.png'),
    );
  });

  testWidgets('AlbumRowTile — failed downloads (retry available)', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        vmState: const AlbumRowTileViewState(
          isOffline: false,
          showDownload: false,
          showCancel: false,
          showDelete: false,
          showRetry: true,
          hidden: false,
        ),
        downloadStatus: DownloadState.failed,
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(AlbumRowTile),
      matchesGoldenFile('goldens/album_row_failed.png'),
    );
  });
}
