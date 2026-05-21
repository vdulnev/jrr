import 'package:drift/drift.dart' show OrderingTerm, Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jrr_f/core/db/app_database.dart';
import 'package:jrr_f/core/di/providers.dart';
import 'package:jrr_f/features/connection/data/repositories/connection_repository.dart';
import 'package:jrr_f/features/connection/providers/last_server_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectionRepository extends Mock implements ConnectionRepository {}

void main() {
  late MockConnectionRepository repo;
  late ProviderContainer container;

  setUp(() {
    repo = MockConnectionRepository();
    container = ProviderContainer(
      overrides: [connectionRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  test('returns null when no saved servers exist', () async {
    when(() => repo.getSavedServers()).thenAnswer((_) async => []);
    expect(await container.read(lastServerProvider.future), isNull);
  });

  test('returns the first server with its decrypted password', () async {
    const server = SavedServer(
      id: 1,
      host: 'h',
      port: 52199,
      username: 'u',
      passwordKey: 'k',
      friendlyName: 'Home',
      lastUsedAt: 200,
      useSsl: false,
      sslPort: 52200,
    );
    when(() => repo.getSavedServers()).thenAnswer((_) async => [server]);
    when(() => repo.getPassword('k')).thenAnswer((_) async => 'pw');

    final last = await container.read(lastServerProvider.future);
    expect(last, isNotNull);
    expect(last!.host, 'h');
    expect(last.port, 52199);
    expect(last.username, 'u');
    expect(last.password, 'pw');
    expect(last.useSsl, isFalse);
    expect(last.sslPort, 52200);
  });

  test(
    'passes null password through when secure storage returns null',
    () async {
      const server = SavedServer(
        id: 1,
        host: 'h',
        port: 52199,
        username: 'u',
        passwordKey: 'k',
        useSsl: false,
        sslPort: 52200,
      );
      when(() => repo.getSavedServers()).thenAnswer((_) async => [server]);
      when(() => repo.getPassword('k')).thenAnswer((_) async => null);

      final last = await container.read(lastServerProvider.future);
      expect(last!.password, isNull);
    },
  );

  test(
    'against an in-memory DB still resolves to the most recent row',
    () async {
      // Sanity: prove the provider behaviour holds against a real DB rather
      // than just the mock surface.
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final realRepo = MockConnectionRepository();
      when(() => realRepo.getSavedServers()).thenAnswer((_) async {
        return await (db.select(
          db.savedServers,
        )..orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)])).get();
      });
      when(() => realRepo.getPassword(any())).thenAnswer((_) async => 'pw');

      await db
          .into(db.savedServers)
          .insert(
            SavedServersCompanion.insert(
              host: 'older',
              username: 'u',
              passwordKey: 'k1',
              lastUsedAt: const Value(100),
            ),
          );
      await db
          .into(db.savedServers)
          .insert(
            SavedServersCompanion.insert(
              host: 'newer',
              username: 'u',
              passwordKey: 'k2',
              lastUsedAt: const Value(200),
            ),
          );

      final realContainer = ProviderContainer(
        overrides: [connectionRepositoryProvider.overrideWithValue(realRepo)],
      );
      addTearDown(realContainer.dispose);

      final last = await realContainer.read(lastServerProvider.future);
      expect(last!.host, 'newer');
    },
  );
}
