import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/di/injection.dart';
import '../data/models/download_job.dart';
import '../data/repositories/downloads_repository.dart';

part 'download_jobs_provider.g.dart';

@riverpod
class DownloadJobs extends _$DownloadJobs {
  @override
  Stream<List<DownloadJob>> build() {
    return getIt<DownloadsRepository>().watchJobs();
  }
}
