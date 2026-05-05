import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../data/models/downloaded_track.dart';
import '../data/repositories/downloads_repository.dart';

part 'downloaded_tracks_provider.g.dart';

@riverpod
class DownloadedTracks extends _$DownloadedTracks {
  @override
  Stream<List<DownloadedTrack>> build() {
    return getIt<DownloadsRepository>().watchDownloadedTracks();
  }
}
