import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/features/offline/data/models/download_state.dart';

void main() {
  test('DownloadState enumerates all expected states', () {
    expect(DownloadState.values, [
      DownloadState.notDownloaded,
      DownloadState.queued,
      DownloadState.running,
      DownloadState.downloaded,
      DownloadState.failed,
      DownloadState.cancelled,
    ]);
  });

  test('DownloadState.name returns the camelCase identifier', () {
    expect(DownloadState.notDownloaded.name, 'notDownloaded');
    expect(DownloadState.downloaded.name, 'downloaded');
    expect(DownloadState.cancelled.name, 'cancelled');
  });
}
