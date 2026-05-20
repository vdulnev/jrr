# Refactor Plan: One Provider Per Widget (Riverpod ViewModel)

## Goal
Adopt a BLoC-like discipline on top of Riverpod: each widget that consumes
Riverpod state watches **exactly one** provider and receives a single
view-model object. The view model bundles every slice the widget needs and
exposes the commands the widget can fire.

## Why
- Mirrors the BLoC mental model the team already uses elsewhere
  (`Widget ↔ Bloc/state`).
- Widgets stop knowing which underlying providers exist; they consume a
  cohesive `XViewState` and a single notifier surface.
- All the `playerProvider.select(...)` boilerplate moves into one provider
  per screen, so refactoring data shape doesn't touch the widget.
- Tests override the one view-model provider with a stub instead of
  wiring up six dependencies.

## Non-goals
- Don't introduce a new state-management library; this is a layout
  convention on top of Riverpod (provider + notifier + freezed state).
- Don't break the existing service/repo layer (`connectionRepository`,
  `libraryRepository`, etc.). View models depend on those exactly the way
  current screen providers do today.
- Don't aim for view models on every `ConsumerWidget`. Granularity rule
  below.

## Granularity rule
- **Screen-level widget (routable / pushed by the router)**: gets a
  dedicated `XViewModelProvider` returning `XViewState`. The widget
  watches only that provider and forwards callbacks to its notifier.
- **Sub-widget inside the same file (`_Foo extends ConsumerWidget`)**:
  prefer receiving its slice of state as constructor params from the
  parent screen. Only keep it as a `ConsumerWidget` when the slice is
  high-churn and we want the rebuild to be local (e.g. a progress bar that
  ticks every 200 ms). In that case it watches the screen view model with
  `.select(...)`, *not* the underlying providers — that keeps the
  one-provider rule intact.
- **Reusable leaf widgets across screens** (e.g. `ArtworkWidget`,
  `MiniPlayerPanel`): treat as their own screen-equivalent and give them
  their own view model.

This keeps the file count proportional to user-visible screens, not to
every render node.

## Current state — inventory

### Screens that consume providers today
| Screen | Providers watched / read today |
|---|---|
| `now_playing_screen.dart` | `playerProvider` (×8 `.select`), `activeZoneProvider`, `playerPollingProvider`, `searchByFileKeyProvider`, `talkerProvider` |
| `mini_player_panel.dart` | `playerProvider` (×6 `.select`), `talkerProvider` |
| `queue_screen.dart` | `queueProvider`, `playingNowPositionProvider`, `playerProvider`, `talkerProvider` |
| `zone_list_screen.dart` | `zoneListProvider`, `activeZoneProvider`, `localAudioQualityPrefProvider`, `talkerProvider` |
| `server_manager_screen.dart` | `sessionProvider`, `downloadJobsProvider`, `downloadedTracksProvider`, `downloadsRepositoryProvider` |
| `server_setup_screen.dart` | `serverSetupFormProvider`, `lastServerProvider`, `sessionProvider` |
| `connecting_screen.dart` | `sessionProvider` |
| `artists_tab.dart` | `artistsProvider`, `talkerProvider` |
| `album_detail_screen.dart` | `albumTracksProvider` |
| `artist_albums_screen.dart` | `albumGroupsByArtistProvider` |
| `folder_tracks_screen.dart` | `folderTracksProvider` |
| `random_tab.dart` | `randomAlbumsProvider` |
| `browse_tab.dart` / `browse_screen.dart` / `browse_content.dart` / `browse_breadcrumb.dart` | `browseNavigationStackProvider`, `browseChildrenProvider`, `browseFilesProvider` |
| `favorites_tab.dart` / `favorites_screen.dart` | `favoritesProvider`, `libraryChromeVisibleProvider` |
| `library_screen.dart` | `sessionProvider`, `libraryChromeVisibleProvider` |
| `downloaded_artists_screen.dart` / `downloaded_albums_screen.dart` / `downloaded_album_detail_screen.dart` | `downloadedArtistsProvider`, `downloadedAlbumsProvider`, `downloadedAlbumTracksProvider`, `downloadsRepositoryProvider`, `playerProvider` |
| `downloaded_artists_screen.dart` `_ArtistRow` sub-widget | same as parent |
| `queue_item_tile.dart` | `playerProvider` |
| `library_item_tile.dart` | `downloadStatusProvider`, `playerProvider`, `activeZoneProvider`, `downloadsRepositoryProvider` |
| `album_row_tile.dart` | `downloadJobsProvider`, `downloadedTracksProvider`, `downloadsRepositoryProvider`, `playerProvider` |

### What's already shaped like a view model
- `serverSetupFormProvider` (already a `Notifier` with one state, the
  commands live on the notifier) — keep as-is, this is the target shape.
- `lastServerProvider` (one async record) — same.
- `randomAlbumsProvider`, `albumTracksProvider`, `artistsProvider`, etc.
  — one provider, one state, no commands. Good as-is.
- Class-based notifiers like `ActiveZone`, `Player`, `Queue`,
  `BrowseNavigationStack` — these are app-/feature-wide state, not view
  models. They stay in the "shared state" layer; view models compose
  them.

### What needs a view model the most (high `.select` density)
1. `now_playing_screen.dart` — 11 sub-widgets each `.select` from
   `playerProvider`. Single biggest payoff.
2. `mini_player_panel.dart` — 6+ `.select` calls.
3. `queue_screen.dart` — mixes `queueProvider`, `playingNowPositionProvider`,
   `playerProvider`.
4. `zone_list_screen.dart` — 3 providers + a popup that watches a fourth.
5. `server_manager_screen.dart` — 4 providers, log-export commands.
6. `library_item_tile.dart` / `album_row_tile.dart` — 4 providers each;
   reusable across screens so they need their own view model.

## Target structure per screen

```
lib/features/<feature>/
  providers/
    <screen>_view_model.dart           // new — view model notifier + state
    <screen>_view_model.g.dart         // riverpod_generator output
  widgets/
    <screen>.dart                       // unchanged path; body simplified
```

### Convention
- **State**: `@freezed class XViewState` with **only** what the widget
  renders. No `AsyncValue` wrappers unless the widget actually has
  loading/error branches; resolve those inside the view model.
- **Notifier**: `@riverpod class XViewModel extends _$XViewModel` whose
  `build()` composes underlying providers via `ref.watch` and returns
  `XViewState`. Commands are instance methods.
- **Widget**:
  ```dart
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(xViewModelProvider);
    final vm = ref.read(xViewModelProvider.notifier);
    return ...
  }
  ```
- **No direct calls to `talkerProvider`, repositories, or other
  providers from the widget.** The view model handles those.

### Example skeleton — `NowPlayingViewModel`
```dart
@freezed
class NowPlayingViewState with _$NowPlayingViewState {
  const factory NowPlayingViewState({
    required Zone? activeZone,
    required int fileKey,
    required Track? track,
    required String name,
    required String artist,
    required String album,
    required int positionMs,
    required int durationMs,
    required double volume,
    required bool isMuted,
    required bool isPlaying,
    required RepeatMode repeatMode,
    required ShuffleMode shuffleMode,
    required int playingNowPosition,
    required int playingNowTracks,
  }) = _NowPlayingViewState;
}

@riverpod
class NowPlayingViewModel extends _$NowPlayingViewModel {
  @override
  NowPlayingViewState build() {
    ref.watch(playerPollingProvider); // keep poll alive
    final zone = ref.watch(activeZoneProvider);
    final status = ref.watch(playerProvider).value;
    final fileKey = status?.fileKey ?? -1;
    final track = fileKey >= 0
        ? ref.watch(searchByFileKeyProvider(fileKey)).asData?.value
        : null;
    return NowPlayingViewState(/* … */);
  }

  void playPause() => ref.read(playerProvider.notifier).playPause();
  void next() => ref.read(playerProvider.notifier).next();
  void setVolume(double v) => ref.read(playerProvider.notifier).setVolume(v);
  // … etc
}
```

The widget becomes:
```dart
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(nowPlayingViewModelProvider);
  final vm = ref.read(nowPlayingViewModelProvider.notifier);
  if (state.activeZone == null) return const Scaffold(body: LoadingView());
  if (state.fileKey < 0) return _NowPlayingEmptyState(zone: state.activeZone!);
  return Scaffold(/* uses state.* and vm.* only */);
}
```

Sub-widgets inside `now_playing_screen.dart` (`_VolumeControl`,
`_RepeatButton`, etc.) receive their slice via constructor parameters
from the screen build method. They become `StatelessWidget` again.

## Migration order
Each step compiles and passes `flutter analyze && flutter test`.

1. **Add infrastructure**
   - Add `nowPlayingViewModelProvider` *alongside* existing providers.
   - Keep `now_playing_screen.dart` untouched for now.
   - Confirms freezed + riverpod_generator wiring for the view-model
     pattern.

2. **`NowPlayingScreen` — pilot**
   - Convert the screen + all 11 sub-widgets to consume
     `nowPlayingViewModelProvider`. Sub-widgets become `StatelessWidget`
     with `final` fields. Largest single payoff, validates the convention.

3. **`MiniPlayerPanel`**
   - Same shape as NowPlaying but smaller. Lives in `shared/widgets/`?
     check current path. Keep the file path; add
     `lib/features/player/providers/mini_player_view_model.dart`.

4. **`QueueScreen`**
   - View model returns `(tracks, currentIndex, isEmpty, isLoading,
     error)` plus commands for `playByIndex`, `removeItem`, `clear`.

5. **`ZoneListScreen` and `_QualityPopup`**
   - View model combines `zoneListProvider`, `activeZoneProvider`, and
     `localAudioQualityPrefProvider`. Quality popup gets its own VM.

6. **`ServerManagerScreen`** + the three `_*Section` sub-widgets
   - VM exposes server info, storage stats, failed-download retry
     commands, log export commands. The log-export side effects belong
     in the notifier, not the widget.

7. **`ServerSetupScreen` + `ConnectingScreen`**
   - `serverSetupFormProvider` is already a notifier; rename / wrap it
     so the screen consumes one VM. Pre-fill from
     `lastServerProvider` happens inside the VM.

8. **Library family**
   - `ArtistsTabScreen`, `AlbumDetailScreen`, `ArtistAlbumsScreen`,
     `FolderTracksScreen`, `RandomTab`. Most are already "one provider,
     one async list" — just wrap and rename to `xViewModel` so the
     convention is uniform.
   - `BrowseTab` / `BrowseScreen` / `BrowseContent` /
     `BrowseBreadcrumb` share `browseNavigationStackProvider`. One VM
     keyed by `BrowseScope`.

9. **Offline family**
   - `downloaded_*_screen.dart` each get their own VM. Action handlers
     (`play`, `playNext`, `add`, `deleteDownload`) move from the widget
     into the VM.

10. **Reusable tiles** — `LibraryItemTile`, `AlbumRowTile`,
    `QueueItemTile`
    - These currently watch 3–4 providers each. Each gets a VM keyed by
      the item being rendered (`libraryItemTileViewModelProvider(track)`
      etc.). Use `autoDispose` family providers so memory stays bounded.

11. **Cleanup pass**
    - Strip remaining `ref.read(talkerProvider)` from widget files;
      logging moves into view models.
    - Update the `MEMORY.md` reference notes to mention the new
      convention.

## Risks & gotchas

- **Family providers blow up memory if used per-list-item**. For
  `LibraryItemTile` use `autoDispose` + `family`, *or* pass plain data
  in and only use a VM when the tile has state of its own (download
  progress). Otherwise stick with the parent screen's VM.
- **VMs that just forward state** are noise. If a screen already
  consumes exactly one provider with no commands (e.g. `RandomTab`
  reading `randomAlbumsProvider`), the existing provider already *is*
  the VM. Just rename and document; don't add a wrapper.
- **High-churn slices** (position ticker, VU meter) — the parent VM
  rebuilds whenever they change. For those, give the inner widget its
  own `ConsumerWidget` that watches `vmProvider.select((s) => s.posMs)`.
  That keeps "one provider per widget" intact while preserving rebuild
  locality.
- **`autoDispose` vs `keepAlive`** — screen VMs should NOT be
  `keepAlive`; they're scoped to the screen's lifetime. Shared state
  (player, session, zone) stays `keepAlive` in the existing providers.
- **Tests** — view-model tests use `ProviderContainer` with overrides
  for the underlying providers. Widget tests override the view-model
  provider only.

## What stays the same
- `lib/core/di/providers.dart` (the DI/service layer) — unchanged.
- Cross-cutting state notifiers (`activeZoneProvider`, `playerProvider`,
  `sessionProvider`, `browseNavigationStackProvider`) — unchanged. View
  models read them.
- Service classes and repositories — unchanged.

## Rough size estimate
- ~20 new `*_view_model.dart` files + freezed state classes.
- ~20 widget files trimmed (mostly removed imports, fewer `ref.watch`
  calls, sub-widgets demoted to `StatelessWidget`).
- One big refactor of `NowPlayingScreen` (~500 LoC touched) up front;
  the rest are smaller.

Land in ~10–12 commits, one per migration step above.
