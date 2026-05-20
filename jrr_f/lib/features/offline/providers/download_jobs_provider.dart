import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/providers.dart';
import '../data/models/download_job.dart';

part 'download_jobs_provider.g.dart';

@riverpod
class DownloadJobs extends _$DownloadJobs {
  @override
  Stream<List<DownloadJob>> build() {
    return ref.read(downloadsRepositoryProvider).watchJobs();
  }
}
