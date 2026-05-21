import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:jrr_f/core/network/mcws_client.dart';
import 'package:jrr_f/features/library/data/models/track.dart';
import 'package:jrr_f/features/library/data/models/tracks.dart';
import 'package:jrr_f/features/queue/data/repositories/queue_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockMcwsClient extends Mock implements McwsClient {}

void main() {
  late MockMcwsClient client;
  late QueueRepositoryImpl repo;

  setUp(() {
    client = MockMcwsClient();
    repo = QueueRepositoryImpl(client: () => client);
  });

  test('getQueue forwards to getPlayingNow', () async {
    final tracks = Tracks.fromList(const [Track(fileKey: 1)]);
    when(
      () => client.getPlayingNow('z'),
    ).thenAnswer((_) async => right(tracks));
    final result = await repo.getQueue('z');
    expect(result.getOrElse((_) => Tracks.empty), tracks);
  });

  test('removeItem forwards to removeFromQueue', () async {
    when(
      () => client.removeFromQueue('z', 2),
    ).thenAnswer((_) async => right(unit));
    await repo.removeItem('z', 2);
    verify(() => client.removeFromQueue('z', 2)).called(1);
  });

  test('moveItem forwards source and target', () async {
    when(
      () => client.moveInQueue('z', 1, 4),
    ).thenAnswer((_) async => right(unit));
    await repo.moveItem('z', 1, 4);
    verify(() => client.moveInQueue('z', 1, 4)).called(1);
  });

  test('clearQueue delegates', () async {
    when(() => client.clearQueue('z')).thenAnswer((_) async => right(unit));
    await repo.clearQueue('z');
    verify(() => client.clearQueue('z')).called(1);
  });
}
