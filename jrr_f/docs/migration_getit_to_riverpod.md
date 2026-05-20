# Migration Plan: `get_it` → Riverpod-only DI

## Goal
Remove the `get_it` dependency entirely. Every service, repository, and shared resource currently registered in `getIt` is exposed as a Riverpod provider, resolved through `ref.read` / `ref.watch` at the call site.

## Why
- One DI / state-management mechanism instead of two parallel ones.
- Session-scoped resources (`McwsClient`) drop the manual `pushNewScope` / `popScope` dance — Riverpod auto-invalidates dependents when the session state changes.
- Providers participate in `ProviderObserver` logging and testing overrides; `getIt` calls don't.
- Removes hidden coupling: today `xRepositoryImpl` reaches into `getIt<McwsClient>()` from inside its methods, making the dependency invisible at the type level.

## Inventory (what `getIt` currently holds)
From `lib/core/di/injection.dart` and `lib/main.dart`:

| Type | Lifetime | Init kind |
|---|---|---|
| `Talker` | app | sync |
| `AppDatabase` | app | sync |
| `FlutterSecureStorage` | app | sync |
| `SharedPreferences` | app | **async (pre-`runApp`)** |
| `McwsXmlParser` | app | sync |
| `ConnectionRepository` | app | sync (depends on db/secure/parser/talker) |
| `PlayerRepository` / `ZoneRepository` / `QueueRepository` / `LibraryRepository` / `FavoritesRepository` | app | sync, resolve `McwsClient` at call-time |
| `LocalQueueRepository` | app | sync (depends on db) |
| `DownloadsRepository` | app | sync (depends on db/talker) |
| `DownloadService` | app | sync, started immediately |
| `AndroidAutoSessionService` | app | sync |
| `RecentlyPlayedRepository` | app | sync (depends on prefs) |
| `LocalPlayerService` / `AndroidAutoPlayerService` / `JrrAudioHandler` | app | **async (post-`AudioService.init`, pre-`runApp`)** |
| `McwsClient` | **session-scoped** (push/pop on connect/disconnect) | sync |

~179 `getIt<…>()` call sites across `lib/features/**`, plus 2 in tests.

## Strategy

### 1. Bootstrap async work, then override providers
Keep `main()` doing the async pre-init it already does (SharedPreferences, AudioService.init, log file), but instead of stuffing the results into `getIt`, hand them to `ProviderScope` via `overrideWithValue`:

```dart
runApp(
  ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      talkerProvider.overrideWithValue(talker),
      localPlayerServiceProvider.overrideWithValue(localHandler),
      androidAutoPlayerServiceProvider.overrideWithValue(autoHandler),
      jrrAudioHandlerProvider.overrideWithValue(mainHandler),
    ],
    observers: [TalkerRiverpodObserver(talker: talker)],
    child: const App(),
  ),
);
```

Each overridden provider has a stub `throw UnimplementedError()` body — they must be overridden before use. This is the standard Riverpod pattern for "constructed before the widget tree."

### 2. Plain singletons → `@Riverpod(keepAlive: true) Provider<T>`
For sync-constructible app-lifetime objects (`AppDatabase`, `FlutterSecureStorage`, `McwsXmlParser`, repositories, services), expose a `keepAlive` provider whose body just `new`s the object and wires its dependencies via `ref.watch`.

```dart
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
ConnectionRepository connectionRepository(Ref ref) => ConnectionRepositoryImpl(
  db: ref.watch(appDatabaseProvider),
  secureStorage: ref.watch(flutterSecureStorageProvider),
  parser: ref.watch(mcwsXmlParserProvider),
  talker: ref.watch(talkerProvider),
);
```

### 3. Session-scoped `McwsClient` → reactive provider
Today `connectionRepository_impl.dart:194,235` calls `getIt.pushNewScope(...registerSingleton<McwsClient>(client))` on connect, and `_popScope()` on `clearSession`. Replace with:

- An `activeMcwsClientProvider` that exposes the current `McwsClient?` (or `AsyncValue<McwsClient>`).
- `ConnectionRepository` no longer pushes a scope — it just updates state that this provider watches (e.g. via a `sessionProvider` notifier holding the connected server).
- Every place that currently does `getIt<McwsClient>()` becomes `ref.read(activeMcwsClientProvider)` (or `ref.watch` from inside a provider). Repositories take `Ref` (or the resolved client) in their constructor instead of reaching out.

This is the single highest-value win: today, callers can grab an `McwsClient` from a popped scope and crash; with Riverpod, the dependency tree invalidates automatically when the session changes.

### 4. Repositories: stop reaching out from inside methods
Currently `LibraryRepositoryImpl.browseChildren` (and ~all sibling methods) call `getIt<McwsClient>()` inline. Refactor to receive the client in the constructor, so the repository provider naturally re-creates when the client changes:

```dart
@Riverpod(keepAlive: true)
LibraryRepository libraryRepository(Ref ref) =>
    LibraryRepositoryImpl(client: ref.watch(activeMcwsClientProvider));
```

When the session is cleared, `activeMcwsClientProvider` flips to null/error and `libraryRepositoryProvider` rebuilds — anything `ref.watch`ing it gets a clean state.

### 5. Migrate call sites mechanically
Of the 179 `getIt<…>()` sites, the vast majority are inside providers that already have a `Ref`:

```dart
// before
final repo = getIt<LibraryRepository>();
// after
final repo = ref.read(libraryRepositoryProvider);
```

A smaller set lives in widgets. Those become `ref.read` inside callbacks or `ref.watch` in `build`. Use `ConsumerWidget` / `ConsumerStatefulWidget` where the widget isn't one already.

### 6. Tests
Two test files use `getIt`. Replace with `ProviderContainer(overrides: [...])` + `container.read(...)`. This is also better — currently mocking via `getIt` is global mutable state across tests.

## Step-by-step execution order
Each step compiles and passes tests on its own; commit between steps.

1. **Add providers alongside `getIt`.** Create `lib/core/di/providers.dart` with `@Riverpod(keepAlive: true)` providers for every type currently in `getIt`. Bodies can temporarily delegate to `getIt<T>()` so behaviour is unchanged. Run `build_runner`.
2. **Override pre-initialized values in `main.dart`.** Set up `ProviderScope` overrides for `SharedPreferences`, `Talker`, `LocalPlayerService`, `AndroidAutoPlayerService`, `JrrAudioHandler`. Still keep them in `getIt` for now so unmigrated call sites work.
3. **Migrate feature `lib/features/**/providers/*.dart`** one feature at a time (connection → zones → player → queue → library → favorites → offline). In each file, swap `getIt<X>()` for `ref.read(xProvider)`. Run `flutter analyze && flutter test` between features.
4. **Migrate widgets.** Same swap, but with `ConsumerWidget` / `ref.read` in callbacks. Mostly mechanical.
5. **Refactor repositories to receive deps via constructor.** Once all call sites use providers, repositories no longer need `getIt<McwsClient>()` inside methods — change them to take the client in the constructor and let the provider wire it.
6. **Replace `McwsClient` scope-push with a reactive provider.** Modify `ConnectionRepositoryImpl.restoreSession` / `clearSession` / `connect` to update a Riverpod-watched state instead of pushing/popping `getIt` scopes. Delete the `_sessionScopeName` machinery.
7. **Delete `lib/core/di/injection.dart`**, remove the `await configureDependencies()` call from `main.dart`, drop `get_it` from `pubspec.yaml`, and remove the `core/di/providers.dart` `getIt<T>()` shims (replace each delegating body with the real construction).
8. **Migrate tests** off `getIt` to `ProviderContainer` overrides.
9. **Final pass**: `dart fix --apply`, `dart format .`, `flutter analyze && flutter test`.

## Risks & gotchas
- **`@Riverpod(keepAlive: true)`** is required for app-lifetime singletons; without it, providers dispose when no widget watches them, defeating the singleton semantics for repositories.
- **`DownloadService.start()`** is called eagerly today. The provider must do the same — either eagerly read it in `main.dart` (`container.read(downloadServiceProvider)`) or call `.start()` inside the provider body. Eager read from `main` is cleaner.
- **`AndroidAutoSessionService` is resolved from a platform callback** (`getChildren` override on the audio handler). Audio handlers live outside the widget tree, so they can't use `ref` directly. Pass a `ProviderContainer` (created in `main`) into the handlers, or have the handler hold a direct reference to the service injected at construction. Prefer the latter — it's already how `LocalPlayerService` is wired.
- **Codegen burden**: every new provider needs `build_runner`. Use `dart run build_runner watch` during the migration.
- **Circular dependencies** are easier to create accidentally with `ref.watch` than with `getIt`. If `connectionRepositoryProvider` watches `activeMcwsClientProvider` which watches `connectionRepositoryProvider`, Riverpod will throw. Keep `McwsClient` as state owned by a notifier, not derived through the repository.

## What stays the same
- `get_it` removal doesn't change MCWS API, queue logic, or UI behaviour — it's pure plumbing.
- `audio_service` initialization order in `main.dart` is unchanged: pre-init, then `runApp`.
- File-on-disk logging (`FileLogObserver`) and Talker observer are unchanged.

## Rough size estimate
- ~180 call-site swaps (mostly trivial: regex-driven).
- ~10 new provider files, ~30 new providers.
- ~3 non-trivial refactors: `McwsClient` reactive wiring, repositories taking deps in constructor, audio handlers receiving services without `getIt`.
- 2 test files.

Plan to land in ~6–8 commits, one per step above.
