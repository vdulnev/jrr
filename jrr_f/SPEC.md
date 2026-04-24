# Flutter Implementation Spec — JRiver Remote (`jrr_f`)

This document specifies the Flutter implementation of the JRiver Remote. It complements the parent product spec at `../SPEC.md`, which is the source of truth for product scope, user stories, functional requirements, and API contracts. This file only describes *how* the Flutter app realizes that spec.

If anything here conflicts with the parent spec, the parent spec wins for behavior and this file wins for Flutter-specific implementation details.

---

## 0. Dart rules

Never use null assertion operator.

## 1. Tech Stack

| Concern | Choice | Notes |
|---|---|---|
| Language | Dart ≥ 3.11.4 | null-safe, records, patterns |
| Framework | Flutter (stable) | Material 3 |
| State management | **Riverpod** (`flutter_riverpod`) | `Notifier` / `AsyncNotifier` providers |
| Routing | **auto_route** | code-gen, typed routes, guards |
| DI / service location | **get_it** | registered in `lib/core/di/` |
| Functional programming | **fpdart** | error handling |
| Logging | **Talker** + custom redacting Dio logger + `talker_flutter` | in-process redaction of secrets |
| Models / unions | **Freezed** + `json_serializable` | sealed classes for state + DTOs |
| HTTP | **Dio** | with custom interceptors |
| Local DB | **drift** (SQLite) | favorites, cached portfolio + history, alerts, settings |
| Simple prefs | **shared_preferences** | non-sensitive UI-only flags |
| HTTP codegen | **Retrofit** (`retrofit`) | abstract API → generated implementation |
| Notifications | **awesome_notifications** | local price alerts |
| Mocking (tests) | **mocktail** | per project test convention |

### Target platforms

iOS, Android, macOS, Windows, Linux. Web is **not** a target.

---

## 2. Project Structure

```
lib/
  main.dart                        # entry point; bootstraps DI + app
  app.dart                         # MaterialApp.router wired to AppRouter
  core/
    di/
      injection.dart               # get_it base-scope registrations (startup singletons)
    error/
      app_exception.dart           # sealed Freezed AppException union
      app_exception.freezed.dart
    network/
      dio_factory.dart             # builds the Dio instance with interceptors
      mcws_api.dart                # Retrofit abstract class — annotated HTTP endpoints
      mcws_api.g.dart              # generated Retrofit implementation
      mcws_client.dart             # domain-level client: error mapping, query building, response parsing
      mcws_xml_parser.dart         # XML → Map<String, String>
      models/
        auth_result.dart           # Authenticate response DTO
      interceptors/
        auth_interceptor.dart      # appends Token= query param
        logging_interceptor.dart   # Talker-based, redacts token values
    db/
      app_database.dart            # Drift database + migrations
      app_database.g.dart          # generated
    router/
      app_router.dart              # @AutoRouterConfig
      app_router.gr.dart           # generated
      navigation_notifier.dart     # Riverpod notifier owning the route stack
      root_screen.dart             # AutoRouter.declarative + mini player
  features/
    connection/
      data/
        models/
          server_info.dart         # from Alive response (Freezed)
        repositories/
          connection_repository.dart      # abstract interface
          connection_repository_impl.dart # impl with secure storage
      providers/
        last_server_provider.dart
        server_setup_provider.dart
        session_provider.dart      # manages auth state
        session_state.dart         # Restoring | Unauthenticated | Authenticated
      widgets/
        server_setup_screen.dart   # host/port/credential entry
        connecting_screen.dart     # spinner while Alive + Authenticate run
    player/
      data/
        models/
          player_status.dart       # Freezed; includes Track?
          playback_state.dart      # enum
          shuffle_mode.dart        # enum
          repeat_mode.dart         # enum
        repositories/
          player_repository.dart   # abstract interface
          player_repository_impl.dart
      providers/
        player_provider.dart       # AsyncNotifier<PlayerStatus>
        polling_provider.dart      # timer-based orchestrator
      widgets/
        now_playing_screen.dart    # main tab screen; artwork, transport, seek, volume
        mini_player_panel.dart     # persistent mini player in layout flow (Column-based)
        transport_controls.dart
        seek_bar.dart
        volume_control.dart
        artwork_widget.dart
    zones/
      data/
        models/
          zone.dart
        repositories/
          zone_repository.dart     # abstract interface
          zone_repository_impl.dart
      providers/
        zone_provider.dart         # AsyncNotifier<List<Zone>>
        active_zone_provider.dart  # StateProvider<Zone?>
      widgets/
        zone_list_screen.dart      # top-level tab with zone list, volume control for active zone
    queue/
      data/
        repositories/
          queue_repository.dart    # abstract interface
          queue_repository_impl.dart
      providers/
        queue_provider.dart        # AsyncNotifier<List<Track>>
      widgets/
        queue_screen.dart
        queue_item_tile.dart
    library/
      data/
        models/
          album.dart               # Freezed; Album.fromTrack() factory
          browse_item.dart         # Freezed; id + name for browse tree nodes
          track.dart               # Freezed + json_serializable; shared by queue & library
        repositories/
          library_repository.dart  # abstract interface
          library_repository_impl.dart
      providers/
        library_providers.dart     # artists, albumsByArtist, albumTracks, folderTracks, randomAlbums, search, browseChildren, browseFiles, libraryTabIndex
      widgets/
        library_screen.dart        # top-level tab with segmented control (Artists/Random/Browse)
        album_list_screen.dart     # reusable: takes List<Album>, title, subtitle, onRefresh; SubScreenHeader, filter field (>5 albums), AlbumRowTile
        album_detail_screen.dart   # thin @RoutePage wrapper → TrackListScaffold
        album_row_tile.dart        # album row with art placeholder, kebab PopupMenuButton (play/play-next/add/open-folder)
        folder_tracks_screen.dart  # folder-based track view with parent/child navigation
        track_list_scaffold.dart   # shared scaffold: SubScreenHeader + title widget + subtitle + track list body + multi-disc grouping
        artist_albums_screen.dart  # @RoutePage wrapper for artist → albums
        random_albums_screen.dart  # @RoutePage wrapper for random albums
        library_item_tile.dart     # track tile with collapsible info, kebab popup menu, long-press path sheet
        browse_screen.dart         # tree navigation with internal stack; Browse/Children for nodes, Browse/Files for leaves; also BrowseTreeView for embedded use
        browse_files_screen.dart   # leaf node track list with flat/grouped toggle; grouped by artist → album+date; kebab popup menus per group
        library_action_sheet.dart
  shared/
    widgets/
      error_view.dart              # surfaces AsyncValue.error
      loading_view.dart
      sub_screen_header.dart       # shared header: back button, title/titleWidget, subtitle, trailing, content
      transport_button.dart        # reusable circular icon button for transport controls
      volume_slider.dart           # compact horizontal volume slider with mute toggle
    extensions/
      async_value_ext.dart         # .whenWidget() helper
test/
  features/
    connection/
    player/
    zones/
    queue/
  core/
    network/
      mcws_xml_parser_test.dart
      mcws_client_test.dart
```

---

## 3. Architecture Conventions

### Layered responsibilities
- **Widgets**: render + dispatch. No direct repository or Dio access. Read providers via `ref.watch` / `ref.listen`.
- **Providers (Riverpod)**: hold state, expose actions, call repositories. Use `AsyncNotifier` for anything that loads.
- **Repositories**: resolve `McwsClient` from get_it, parse DTOs, return typed `Either<AppException, T>`. No Flutter imports.
- **Models**: Freezed only; no logic beyond `fromJson` / computed getters.

### Widget file convention
Every public widget class lives in its own file. One public widget per file — no exceptions, including router scaffolding screens and placeholders.

### get_it scopes

get_it manages two scope layers:

| Scope | Lifetime | Registered types |
|---|---|---|
| **base** (default) | app lifetime | `Talker`, `AppDatabase`, `FlutterSecureStorage`, `SharedPreferences`, `McwsXmlParser`, `ConnectionRepository` |
| **`'session'`** | login → logout | `McwsClient` |

`ConnectionRepository.connect()` pushes the `'session'` scope and registers `McwsClient` there (with the auth token baked into the `AuthInterceptor` closure).  
`ConnectionRepository.clearSession()` calls `await getIt.popScope()` — `McwsClient` and its `Dio` instance are discarded automatically.

All repositories that need to make MCWS requests resolve the client at call-time: `getIt<McwsClient>()`. They must only be called while a session scope is active (i.e. after successful authentication).

### Riverpod rules
- **All state lives in Riverpod providers** — no `setState`, no local widget state for business logic.
- `ConsumerStatefulWidget` is allowed only for widget-lifecycle concerns: `TextEditingController`, `FocusNode`, `AnimationController`, scroll controllers. Never use it to hold loading flags, error state, or domain data.
- Use `late`, not `late final`, for fields initialized in `build()` — Riverpod can rebuild a notifier and reassign its dependencies.
- Never mutate state outside a notifier.
- Prefer `AsyncValue.guard` for repository calls.
- Compose providers with `ref.watch(otherProvider)`.
- Form submission state (`AsyncValue<void>?`: null = idle, loading, error) belongs in a dedicated screen-scoped `@riverpod` notifier, auto-disposed when the screen leaves the tree.

### Code style
- **Always run `dart format .` after code changes** — code must be formatted before committing.
- Follow Dart's official style guide (80-character line limit, etc.).
- Use `dart format .` to automatically apply formatting.
- CI should reject commits with unformatted code.

## Routing (auto_route)
- **Declarative routing via `AutoRouter.declarative()`** — all navigation state flows through Riverpod providers.
- Single `AppRouter` with `@AutoRouterConfig`.
- **`RootScreen`** wraps authentication guard + `_AuthenticatedShell`:
  - `sessionProvider` state (Restoring | Unauthenticated | Authenticated) gates access
  - `_AuthenticatedShell` renders the bottom tab bar with 4 tabs (Playing, Queue, Library, Zones)
  - Tab content rendered via `IndexedStack` for state preservation
  - When nav stack is non-empty, sub-screens rendered via `AutoRouter.declarative()` on top
  - `MiniPlayerPanel` shown in Column layout flow (between content and tab bar) when not on NowPlaying tab or when sub-screens are pushed
- **`ActiveTab`** (Riverpod `@riverpod` notifier) manages bottom tab selection:
  - `AppTab` enum: `nowPlaying`, `queue`, `library`, `zones`
  - `select(tab)` clears nav stack then switches tab
- **`NavigationNotifier`** (Riverpod) manages the sub-screen navigation stack:
  - `push()` — add route to stack
  - `pop()` — remove from stack
  - `replace()` — replace top route
  - `clear()` — reset stack
- **Never use imperative `context.router.push/pop`** — all navigation goes through `ref.read(navigationProvider.notifier)`.

### Error handling
- Use functional style for error handling. Do not use try/catch.
- All API errors normalized into `AppException` (sealed Freezed union):

  ```dart
  @freezed
  sealed class AppException with _$AppException implements Exception {
    const factory AppException.connectionRefused({required String address}) =
        ConnectionRefusedException;
    const factory AppException.unauthorized() = UnauthorizedException;
    const factory AppException.serverFailure({required String message}) =
        ServerFailureException;
    const factory AppException.parseError({required String details}) =
        ParseErrorException;
    const factory AppException.timeout({required String address}) =
        TimeoutException;
    const factory AppException.unknown({required Object error}) =
        UnknownException;
  }
  ```

  | Cause | AppException variant |
  |---|---|
  | Socket / connection refused | `connectionRefused` |
  | HTTP 401 | `unauthorized` |
  | `<Response Status="Failure">` | `serverFailure` |
  | Malformed XML / missing field | `parseError` |
  | `DioException` timeout | `timeout` |
  | Anything else | `unknown` |

- UI surfaces errors via `AsyncValue.error` + a shared `ErrorView` widget.

### Logging (Talker)
- Single `Talker` instance via get_it.

---

## 4. Persistence

### Drift (`app_database.dart`)
Tables:

| Table | Columns | Purpose |
|---|---|---|
| `saved_servers` | `id` (int PK autoincrement), `host` (text), `port` (int), `username` (text), `password_encrypted` (text), `friendly_name` (text nullable), `last_used_at` (int nullable — unix ms) | Persisted server configurations. `password_encrypted` uses `flutter_secure_storage` indirection: the column stores a lookup key; the actual credential lives in the OS keychain/keystore. |

Only one table is needed for v1. The `last_used_at` field drives pre-selection on startup (most recently used server is auto-selected).

Auth tokens are **not** persisted — they are held in memory for the duration of the session and discarded on logout or app termination.

Migrations are versioned in `app_database.dart`; never edit a past migration — add a new one.

### shared_preferences
Only ephemeral UI flags (last selected tab, last viewed symbol). Never credentials. Never anything the parent spec lists as persistent.

### Logout
`Session.logout()` (Riverpod notifier):
1. `await getIt<ConnectionRepository>().clearSession()` — pops the `'session'` get_it scope, discarding `McwsClient` and its token.
2. Cancel the active polling timer (`pollingProvider`).
3. Clear the active zone (`activeZoneProvider`).
4. Set state to `SessionState.unauthenticated()`.
5. Reset the navigation stack via `ref.read(navigationProvider.notifier).clear()`.
6. Do **not** delete the saved server record — let the user reconnect without re-entering credentials.

`clearSession()` is `async` because `getIt.popScope()` returns `Future<void>`. Always `await` it.

---

## 5. Networking

### Dio interceptor order

Interceptors are added in this order (first added = outermost):

1. **`AuthInterceptor`** — appends `Token=<token>` to every request's query parameters. Reads the current token from `ConnectionRepository` via a closure captured at `McwsClient` creation time. If the token is `null`, rejects immediately with `AppException.unauthorized()` (no request sent). Pass `options.extra['skipAuth'] = true` to bypass (used by `authenticate()` which uses HTTP Basic auth instead).
2. **`LoggingInterceptor`** — wraps `TalkerDioLogger`; redacts the `Token` query param value in all log output (replaces with `***`).

No retry interceptor for v1 — transient failures surface as errors that the user can retry manually.

### Network layer architecture

Two classes split HTTP from domain logic:

**`McwsApi`** (Retrofit) — pure HTTP interface. Each method has a `@GET` annotation and maps to one MCWS endpoint. Returns raw `String` (XML) or `List<Track>` (JSON). Generated `_McwsApi` class implements it via Dio. `filesSearch` is used for all library search queries; `browseChildren` (XML) and `browseFiles` (JSON) are used for tree browsing.

**`McwsClient`** — domain-level client. Wraps `McwsApi` calls with:
- MCWS query string construction (field filters, `~limit`, `~sort`, etc.)
- Value escaping (`_esc()` — prefixes `[]()-` with `/` for literal use)
- Client-side exact-match filtering (MCWS does substring matching)
- XML response parsing via `McwsXmlParser`
- Error mapping (`DioException` → `AppException`)
- Domain model transformation (`Track` → `Album`, flat XML fields → `PlayerStatus`)

All repositories resolve `McwsClient` from get_it, never `McwsApi` directly.

### Offline

MCWS has no offline mode. When any request fails due to a network error:
- Map `DioException` with type `connectionError` / `receiveTimeout` / `sendTimeout` to the appropriate `AppException` variant.
- The provider's `AsyncValue` transitions to `AsyncValue.error`.
- `ErrorView` displays the error with a **Retry** button.
- Polling is suspended automatically when the last `Playback/Info` call fails (the `pollingProvider` catches the error and pauses the timer).
- When the user taps Retry, `pollingProvider` resumes polling and the first successful response re-activates normal operation.

---

## 6. Code Generation

Run `dart run build_runner build --delete-conflicting-outputs` after changes to:
- Freezed models
- Drift tables
- auto_route definitions
- json_serializable DTOs
- Retrofit API definitions (`mcws_api.dart`)

`*.g.dart`, `*.freezed.dart`, `*.gr.dart` are committed (so CI doesn't need to codegen).

---

## 7. Testing Strategy

### Scope for v1

| Layer | What to test | Tool |
|---|---|---|
| `McwsXmlParser` | All XML → map parsing, including error/failure responses | `dart:test` |
| `McwsClient` | Each method: correct endpoint, params, token injection; error mapping | `mocktail` (mock `Dio`) |
| Repositories | Delegate correctly to `McwsClient`; map domain types | subclass + `buildClient` override; get_it scope in tearDown |
| Notifiers / Providers | State transitions (loading → data → error), polling start/stop | `ProviderContainer` + `mocktail` |
| Key widgets | `NowPlayingScreen`, `TransportControls`, `ZoneListScreen` — render, tap, check state | `flutter_test` |

### Conventions
- Test files live in `test/features/<feature>/` mirroring `lib/features/<feature>/`.
- File naming: `<source_filename>_test.dart`.
- Use `mocktail` for all mocks — no `mockito` codegen.
- Widget tests use `ProviderScope` with overrides to inject mock repositories.
- No golden tests for v1.
- Run the full suite with `flutter test`; CI must pass before merge.

---

## 8. Build & Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs

flutter run                       # default device
flutter run -d macos              # macOS

flutter analyze
flutter test                      # offline unit + widget
dart format .
dart fix --apply
```

Pre-commit checklist (matches the global Dart rules):
1. `dart format .` — **mandatory**, must be run before every commit
2. `flutter analyze` — zero warnings
3. `flutter test` — green

---

## 9. Implementation Phases

### Phase 1 — Foundation (done)
- `flutter create`, `pubspec.yaml` with all dependencies, `build_runner` working
- `get_it` DI setup (`injection.dart`)
- `AppRouter` scaffold + `NavigationNotifier`
- `McwsXmlParser` (pure Dart, tested)
- `AppException` union
- `Dio` factory with `AuthInterceptor` + `LoggingInterceptor`
- Drift database with `saved_servers` table
- `flutter_secure_storage` integration for credential storage
- macOS entitlements: `com.apple.security.network.client`, keychain access

### Phase 2 — Connection & Authentication (done)
- `ServerInfo` model
- `McwsApi` (Retrofit) + `McwsClient` two-layer architecture
- `ConnectionRepository` (interface + impl with `FlutterSecureStorage`)
- `SessionProvider` + `SessionState` (Restoring | Unauthenticated | Authenticated)
- `ServerSetupScreen` + `ConnectingScreen`
- Navigation guard: redirect to setup when unauthenticated

### Phase 3 — Player Core (done)
- Domain models: `Zone`, `PlayerStatus`, `Track`, enums
- `McwsClient` transport, info, seek, volume, mute, shuffle, repeat methods
- `PlayerRepository` + `ZoneRepository` (interfaces + impls)
- `PollingProvider` (timer-based, respects intervals from parent spec §5.1)
- `PlayerProvider` + `ZoneProvider` + `ActiveZoneProvider`
- `NowPlayingScreen` with `TransportControls`, `SeekBar`, `VolumeControl`, `ArtworkWidget`
- Drawer navigation in NowPlayingScreen (Library sub-items: Artists, Random Albums)
- `ZoneListScreen`

### Phase 4 — Playing Now Queue (done)
- Queue uses shared `Track` model (no separate `PlayingNowItem`)
- `QueueRepository` (Playlist, PlayByIndex, PlayByKey, EditPlaylist, ClearPlaylist)
- `QueueProvider` (refreshes when `playingNowChangeCounter` increments)
- `QueueScreen` + `QueueItemTile`

### Phase 5 — Library Browse & Search (done)
- **API layer:** Single `filesSearch` Retrofit endpoint; `McwsClient` builds MCWS queries with `_esc()` escaping for `[]()-` characters
- **Browse:** Artist list → album list → track list drill-down
  - `LibraryScreen` — top-level tab with segmented control (Artists/Random/Browse); `ConsumerWidget` with `libraryTabIndexProvider`
  - `AlbumListScreen` — reusable: takes `List<Album>`, title, subtitle, optional onRefresh; `SubScreenHeader`, filter field (shown when >5 albums), `AlbumRowTile` items
  - `TrackListScaffold` — shared scaffold for all track list screens; `SubScreenHeader` with title widget, subtitle, kebab `_TracksPopupMenu` trailing action; loading/error/empty states, multi-disc grouping with disc headers, optional `headerContent` slot
  - `AlbumDetailScreen` — thin `@RoutePage` wrapper passing album title + subtitle (artist) + `albumTracksProvider` to `TrackListScaffold`
  - `FolderTracksScreen` — displays all tracks matching a folder path; stateful with parent/child folder navigation (up/down arrows in `headerContent`); uses `Track.parentPath()` for folder hierarchy traversal; history stack enables forward (up to root) and back (down to original album folder)
  - `ArtistAlbumsScreen` / `RandomAlbumsScreen` — thin `@RoutePage` wrappers
- **Search:** `McwsClient.searchFiles(query)` — multi-field search (Name, Artist, Album)
- **Random Albums:** 10 random albums via `~limit` + `~n` modifiers
- **Folder browsing:** `McwsClient.getTracksByFolder(folderPath)` — queries `[Filename (path)]="path"` to fetch all audio files in a directory; accessible via "Open folder" action on album list items
- **Models:**
  - `Track` (Freezed + json_serializable) — shared by queue, library, and player; `Track.parentPath()` static utility for folder hierarchy navigation
  - `Album` (Freezed) — derived from Track via `Album.fromTrack()` factory; includes `albumArtist`, `date` (readable date string)
  - `Album.folderPath` — uses `parentFolderPath` for multi-disc albums
- **Track tile:** `LibraryItemTile` with `collapsedByDefault` parameter; tap toggles expanded state (shows folder/file paths); long-press shows bottom sheet with selectable file path + clipboard copy; kebab `PopupMenuButton` for play actions
- **Queue integration:** Play now / Add to queue actions on albums, tracks, and folders via `Playback/PlayByKey`
- **Client-side filtering:** Exact artist match (MCWS does substring matching)
- **Browse tree:** Hierarchical library browsing via MCWS `Browse/Children` and `Browse/Files` endpoints
  - `BrowseScreen` — tree navigation with internal stack; `Browse/Children` fetches child nodes, leaf nodes (empty children) switch to `Browse/Files` for tracks
  - `BrowseFilesView` — displays tracks at leaf nodes; toggle between flat list and grouped view (by artist → album+date+folderPath); kebab popup menus on individual tracks, artist groups, and album groups
  - `BrowseItem` model (Freezed) — `id` + `name` for browse tree nodes
  - Accessible via drawer → Library → Browse
- **Providers:** `artistsProvider`, `albumsByArtistProvider`, `albumTracksProvider`, `folderTracksProvider`, `randomAlbumsProvider`, `librarySearchProvider`, `browseChildrenProvider`, `browseFilesProvider`
- **LibraryRepository** interface + impl (includes `getTracksByFolder`, `browseChildren`, `browseFiles`)

### Phase 6 — Mini Player (done)
- `MiniPlayerPanel` — persistent panel in layout flow (Column-based, not overlay)
- Shows artwork, track name, artist, prev/play-pause/next transport buttons, 2px progress bar, inline volume slider with mute toggle
- Tap navigates back to NowPlaying tab
- Positioned in Column between Expanded content and bottomNavigationBar — participates in layout flow so it never overlaps modals or menus
- Integrated in `RootScreen._AuthenticatedShell` via `showMiniPlayer` flag (true when not on NowPlaying tab or when sub-screens are pushed)

### Phase 7 — UI Design System & Polish (done)
- **Design token system:**
  - `AppColors` — dark theme color palette (bg0–bg4, line/line2, text/text2/text3, accent/accentDim)
  - `AppFonts` — font family constants (Inter sans, IBMPlexMono mono)
  - `AppTextStyles` — centralized text style constants (~18 named styles: sectionLabel, screenTitle, subScreenTitle, itemTitle, itemSubtitle, monoLabel, nowPlayingTitle, nowPlayingArtist, labelLarge, accentButton, accentSmall, avatarLetter, sectionHeading, emptyState, chipLabel)
  - `buildAppTheme()` — Material 3 ThemeData wired to design tokens (colorScheme, textTheme, listTileTheme, inputDecorationTheme, snackBarTheme, appBarTheme, dividerTheme)
- **Consistent kebab popup menus:**
  - All playable items use `PopupMenuButton<String>` with consistent menu items: Play, Play next, Add to playing now
  - Uniform icon: `Icons.more_vert` (18px, `AppColors.text3`)
  - Menu items use `ListTile` with `contentPadding: EdgeInsets.zero` and `VisualDensity.compact`
  - Applied across: `LibraryItemTile` (individual tracks), `AlbumRowTile` (albums + optional "Open folder"), `TrackListScaffold._TracksPopupMenu` (bulk track actions), `BrowseFilesView` (via shared `TracksPopupMenu` for browse leaf actions per artist/album group)
- **Bottom tab navigation:**
  - 4 tabs: Playing, Queue, Library, Zones
  - Custom `_TabBar` with uppercase mono labels, accent color for active tab
  - `IndexedStack` preserves tab state
  - `ActiveTab` Riverpod notifier clears nav stack on tab switch
- **Sub-screen navigation:**
  - `SubScreenHeader` shared widget: back button (chevron + "Back"), title (string or widget), optional subtitle (uppercase mono label), optional trailing widget, optional content area
  - Used by: `AlbumListScreen`, `TrackListScaffold`, `BrowseScreen`, `FolderTracksScreen`
- **Library screen redesign:**
  - `LibraryScreen` as `ConsumerWidget` with segmented tab control (Artists/Random/Browse)
  - `libraryTabIndexProvider` manages active tab
  - Artists tab: text filter field, avatar circles with initial letter, chevron navigation
  - Random tab: shuffle button, `AlbumListView` with `AlbumRowTile`
  - Browse tab: embedded `BrowseTreeView`
- **Track tile enhancements:**
  - `LibraryItemTile`: collapsible info (tap toggles expanded state showing folder/file paths), long-press shows bottom sheet with selectable file path + copy button, kebab popup menu for play actions
- **Zone screen redesign:**
  - Top-level tab (not pushed route)
  - Custom header with OUTPUT/Zones labels
  - Zone tiles with icon (cast for DLNA, speaker for local), active zone indicator dot
  - Active zone highlighted with accent dim background
- **Shared widgets:**
  - `TransportButton` — circular icon button for transport controls
  - `VolumeSlider` — compact horizontal volume slider with mute toggle icon

### Phase 8 — Polish & Multi-platform
- Adaptive layouts (compact mobile vs expanded desktop)
- App lifecycle handling — pause/resume polling (§5.3 of parent spec)
- Error recovery UX (retry flows, reconnect)
- macOS / Windows menu bar integration (if time permits)

---

## 10. Open Questions (Flutter-specific)

1. **Credential storage backend**: Use `flutter_secure_storage` for raw credentials (bypasses Drift entirely for secrets), or store an opaque key in Drift and the actual value in the keychain? Leaning toward direct `flutter_secure_storage` with server `id` as key namespace.

2. **Polling granularity**: Single polling loop for the active zone only, or one `PollingProvider` instance per zone? Single loop is simpler for v1; multi-zone polling can be added in v2 when zone linking is exposed in the UI.

3. **Multiple saved servers**: `saved_servers` table supports it, but the UI for v1 only needs to handle one "current" server. Should the setup screen show a list of saved servers on second launch, or always show a blank form?

4. **Image caching**: `cached_network_image` or `flutter_cache_manager` for artwork? Artwork URLs include the auth token as a query param — need to ensure the cache key strips or separates the token to avoid stale entries after re-auth.

5. **Desktop window sizing**: Default window dimensions and minimum size constraints for macOS/Windows/Linux — not covered by the parent spec.

---

## 11. Changelog

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | 2026-04-14 | Initial Flutter spec — all TODO sections filled in |
| 0.1.1 | 2026-04-15 | get_it scopes for McwsClient session lifecycle; `skipAuth` in AuthInterceptor; logout is async |
| 0.1.2 | 2026-04-16 | Added Phase 5 — Library Browse & Search (parent spec v2.0); Polish renamed to Phase 6 |
| 0.2.0 | 2026-04-19 | Phases 1–6 done. Added: Retrofit API layer, mini player with AnimatedSlide, library browse (artists → albums → tracks), random albums, Album/Track models with date, MCWS query escaping, client-side exact filtering, multi-disc album support. Updated project structure to match reality. |
| 0.2.1 | 2026-04-20 | Folder browsing: FolderTracksScreen with parent/child folder navigation, TrackListScaffold extracted as shared track list widget, "Open folder" action on album list, collapsible track info in LibraryItemTile, Album.albumArtist field, Track.dateReadable field. |
| 0.3.0 | 2026-04-21 | Browse tree: BrowseScreen with hierarchical navigation via Browse/Children and Browse/Files MCWS endpoints. BrowseFilesView with flat/grouped toggle (group by artist → album+date), play/add actions per artist and album group. BrowseItem model. Drawer "Browse" entry. |
| 0.4.0 | 2026-04-21 | UI design system: centralized AppTextStyles, consistent kebab PopupMenuButton menus across all playable items, bottom tab navigation (Playing/Queue/Library/Zones), mini player in Column layout flow, SubScreenHeader shared widget, LibraryScreen segmented tabs, ZoneListScreen as top-level tab, TransportButton/VolumeSlider shared widgets. Phase 7 done, renumbered Phase 8 for future polish. |
