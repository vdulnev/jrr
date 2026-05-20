# Flutter Implementation Spec — JRiver Remote (`jrr_f`)

This document specifies the Flutter implementation of the JRiver Remote.
It complements the parent product spec at `../spec.md`, which is the
source of truth for product scope, MCWS API contracts, and cross-platform
behavior. This file describes only *how* the Flutter app realizes that
spec.

If anything here conflicts with the parent spec, the parent spec wins for
behavior and this file wins for Flutter-specific implementation details.

**Version:** 2.7.0
**Status:** Phases 1–11 implemented (remote control, library, design
system, multi-platform layouts, local playback, favorites, offline
startup, adaptive chrome, per-track downloads, Android Auto / AAOS)

---

## 0. Dart rules

- Never use the null-assertion operator (`!`).
- Never use `dynamic` — be explicit.
- Trailing commas in all widget constructors; prefer `const`.
- Run `dart format .` before every commit.
- **Async Synchronization**: Always use synchronization flags (like `_isReloading`) when an asynchronous operation (like queue reloading) must be atomic and non-overlapping.
- **Provider Decoupling**: Avoid direct dependencies between `sessionProvider` and `activeZoneProvider` (or its dependencies like `ZoneList`). Use persistence (e.g. `SharedPreferences`) as a side-channel to communicate desired zone state on login/offline-entry.
- **App Lifecycle**: Use `appLifecycleProvider` to manage global pause/resume events. Components requiring background/foreground transitions should listen to these events rather than implementing local `WidgetsBindingObserver` listeners.
- **Adaptive Chrome**: Use `ScrollChromeListener` and `libraryChromeVisibleProvider` to manage header/mini-player visibility on scroll. Prefer `Sliver`-based layouts for all primary scrolling surfaces to support this behavior.

## 1. Tech Stack

| Concern | Choice | Notes |
|---|---|---|
| Language | Dart ≥ 3.11.4 | null-safe, records, patterns |
| Framework | Flutter (stable) | Material 3 |
| State management | **Riverpod 3** (`flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`) | code-generated `Notifier` / `AsyncNotifier` providers |
| Routing | **auto_route 11** | code-gen, typed routes, nested `AutoTabsRouter` for Library |
| DI / service location | **get_it 9** | base + `'session'` scopes |
| Functional programming | **fpdart** | `Either<AppException, T>` at the repository boundary |
| Logging | **Talker** + `talker_dio_logger` + `talker_riverpod_logger` + `talker_flutter` | single instance, redacts `Token` query param |
| Models / unions | **Freezed 3** + `json_serializable` | sealed classes for state + DTOs |
| HTTP | **Dio 5** | with custom auth + logging interceptors |
| HTTP codegen | **Retrofit** (`retrofit`, `retrofit_generator`) | abstract API → generated implementation |
| Local DB | **drift** + `drift_flutter` (SQLite) | servers, favorites, local queue |
| Simple prefs | **shared_preferences** | active zone GUID, last tab, local player state |
| Secure storage | **flutter_secure_storage** | server passwords (OS keychain/keystore) |
| Local audio playback | **just_audio** + **audio_session** | streams MCWS `File/GetFile` directly to the device |
| Background / system audio | **audio_service** | exposes `BaseAudioHandler` for lock-screen, system notifications, Android Auto `MediaBrowserService` |
| Reactive streams | **rxdart** | `BehaviorSubject` + `switchMap` to pipe the *active* player's streams through the composite handler |
| Network reachability | **connectivity_plus** | reachability checks for offline-mode UX |
| File downloads | **dio** (streaming responses) + **path_provider** | per-track downloads to the app documents directory |
| File picker / share | **file_selector**, **share_plus** | export/share downloaded tracks |
| Hashing | **crypto** | stable cache keys for artwork files exposed to AA |
| Mocking (tests) | **mocktail** | no `mockito` codegen |
| App icons | **flutter_launcher_icons** | per-platform launcher icons |

### Target platforms

iOS, Android, macOS, Windows, Linux. Web is **not** a target.

The Android build additionally targets **Android Auto** (head units
running the AA app) and **Android Automotive OS** (in-vehicle Android)
via the `android.hardware.type.automotive` + `com.android.automotive`
manifest metadata. A single APK covers both surfaces.

The app ships an adaptive layout: a bottom-tab shell on narrow viewports
(phones / portrait tablets) and a sidebar + content shell on wide
viewports (desktops, landscape tablets). See §3 "Adaptive layout".

---

## 2. Project Structure

```
lib/
  main.dart                        # entry; bootstraps DI, error handlers,
                                   # ProviderScope w/ TalkerRiverpodObserver
  app.dart                         # MaterialApp.router wired to AppRouter
  core/
    di/
      injection.dart               # get_it base-scope registrations
    error/
      app_exception.dart           # sealed Freezed AppException union
      app_exception.freezed.dart
    lifecycle/
      app_lifecycle_provider.dart  # global pause/resume management
    layout/
      layout_breakpoints.dart      # width threshold for narrow vs wide
      adaptive_layout.dart         # AdaptiveLayoutBuilder
      two_panel_shell.dart         # wide layout: Sidebar + content
      sidebar.dart                 # left-rail navigation (wide layout)
    network/
      dio_factory.dart             # createDio() + createPublicDio()
      mcws_api.dart                # Retrofit abstract MCWS endpoints
      mcws_api.g.dart              # generated
      mcws_client.dart             # domain client: query building, parsing
      mcws_xml_parser.dart         # XML → Map<String, String>
      jriver_lookup_api.dart       # Public registry lookup (webplay.jriver.com)
      jriver_lookup_api.g.dart
      models/
        auth_result.dart           # Authenticate response DTO
      interceptors/
        auth_interceptor.dart      # appends Token query param
        logging_interceptor.dart   # Talker-backed, redacts token
    db/
      app_database.dart            # Drift DB; schema v4
      app_database.g.dart
    router/
      app_router.dart              # @AutoRouterConfig (nested routes)
      app_router.gr.dart
      navigation_notifier.dart     # AppTab enum + ActiveTab notifier
      navigation_notifier.g.dart
      root_screen.dart             # auth gate + adaptive shell
      player_placeholder_screen.dart
    theme/
      app_theme.dart               # AppColors, AppFonts, AppTextStyles,
                                   # buildAppTheme()
  features/
    connection/
      data/
        models/
          server_info.dart         # Freezed
        repositories/
          connection_repository.dart       # interface
          connection_repository_impl.dart  # secure storage + scope mgmt
      providers/
        last_server_provider.dart        # autofill on setup screen
        server_setup_provider.dart       # form-submission AsyncValue<void>?
        session_provider.dart            # Session notifier (silent reconnect)
        session_state.dart               # Restoring | Unauthenticated | Authenticated
      widgets/
        server_setup_screen.dart   # access-key OR manual host/port entry
        connecting_screen.dart
        server_manager_screen.dart # Settings tab content
    player/
      data/
        models/
          player_status.dart       # Freezed
          playback_state.dart      # enum
          shuffle_mode.dart        # enum
          repeat_mode.dart         # enum
          local_audio_quality.dart # Conversion + Quality preset enum
          player_state_data.dart   # Freezed wrapper around just_audio state
          sequence_state_data.dart # Freezed wrapper around sequence
          local_palyback_state.dart# combined snapshot (typo preserved)
        repositories/
          player_repository.dart
          player_repository_impl.dart
          recently_played_repository.dart  # in-memory history feed for AA
      services/
        local_player_service_base.dart   # abstract: BaseAudioHandler +
                                         # just_audio surface
        local_player_service.dart        # Local/Offline implementation
        android_auto_player_service.dart # AA implementation w/ MediaBrowser
                                         # children + voice search handling
        jrr_audio_handler.dart           # Composite handler; switchTo()
                                         # pipes active player's streams
        media_item_mapper.dart           # Track → MediaItem (artUri via
                                         # content:// FileProvider on AA)
        voice_intent_resolver.dart       # AA voice-search extras → tracks
      logging/
        talker_extensions.dart
        sequence_state_log.dart
      providers/
        player_provider.dart       # unified Player facade (delegates to
                                   # local or mcws controller)
        mcws_player_provider.dart  # remote AsyncNotifier<PlayerStatus?>
        player_polling_provider.dart    # remote-zone poller
        local_player_provider.dart      # AsyncNotifier driving the active
                                        # LocalPlayerServiceBase
        local_audio_quality_provider.dart # SharedPreferences-backed enum
        player_controller.dart     # abstract interface implemented by
                                   # both local and mcws player notifiers
      widgets/
        now_playing_screen.dart
        mini_player_panel.dart     # in Column flow, not overlay
    zones/
      data/
        models/
          zone.dart                # Freezed (isLocal / isOffline /
                                   # isAndroidAuto flags + Zone.local /
                                   # Zone.offline / Zone.androidAuto
                                   # constants)
          zones.dart               # Freezed wrapper (List<Zone>)
        repositories/
          zone_repository.dart
          zone_repository_impl.dart      # appends Local, Offline, and
                                         # (when AA connected) Android Auto
      services/
        android_auto_session_service.dart # MethodChannel observer +
                                          # ValueNotifier<bool>; synchronous
                                          # audio-handler swap on connect
      providers/
        zone_provider.dart         # ZoneList AsyncNotifier
        zone_polling_provider.dart # 30s poll while authenticated
        active_zone_provider.dart  # restored from SharedPreferences;
                                   # exposes isAndroidAutoActive,
                                   # isOfflineLikeActive,
                                   # isVirtualZoneActive helpers
      widgets/
        zone_list_screen.dart
        zone_tile.dart
    queue/
      data/
        repositories/
          queue_repository.dart            # remote (Playback/Playlist)
          queue_repository_impl.dart
          local_queue_repository.dart      # interface (zone-scoped CRUD)
          local_queue_repository_impl.dart # Drift-backed, per-zone rows
      providers/
        queue_provider.dart        # unified AsyncNotifier<Tracks>;
                                   # routes to local/AA/offline via
                                   # localPlayerSequenceProvider or to
                                   # MCWS via QueueRepository
      widgets/
        queue_screen.dart
        queue_item_tile.dart
    offline/
      data/
        models/
          downloaded_track.dart    # Freezed + json — local-file mirror
                                   # of a Track
          download_job.dart        # Freezed — enqueued / running job
          download_state.dart      # enum
        repositories/
          downloads_repository.dart        # Drift-backed CRUD over
                                           # downloaded_tracks + download_jobs
      services/
        download_service.dart      # serial download runner; Dio streaming
                                   # write to app documents directory
      providers/
        downloaded_tracks_provider.dart    # AsyncNotifier<List<DownloadedTrack>>
        download_jobs_provider.dart        # active job feed
        download_status_provider.dart      # per-track / per-album rollup
      widgets/
        downloaded_albums_screen.dart
        downloaded_artists_screen.dart
        downloaded_album_detail_screen.dart
        album_download_progress_indicator.dart
        download_progress_indicator.dart
        confirm_delete_dialog.dart
    library/
      data/
        models/
          album.dart               # Freezed; AlbumGroup helper for multi-disc
          browse_item.dart         # Freezed
          track.dart               # Freezed + json_serializable; converters
                                   # for tolerant int/string parsing
          tracks.dart              # Freezed wrapper (List<Track>)
        repositories/
          library_repository.dart
          library_repository_impl.dart
      providers/
        library_providers.dart     # artists, albumsByArtist, albumTracks,
                                   # folderTracks, randomAlbums, search,
                                   # browseChildren, browseFiles,
                                   # searchByFileKey, BrowseNavigationStack
      widgets/
        library_screen.dart        # AutoTabsRouter shell (Artists / Random
                                   # / Browse / Favorites)
        library_tab_routers.dart   # router-only @RoutePage stubs per tab
        artists_tab.dart
        random_tab.dart
        browse_tab.dart
        favorites_tab.dart
        artist_albums_screen.dart
        album_detail_screen.dart   # @RoutePage; thin wrapper → TrackListScaffold
        folder_tracks_screen.dart  # parent/child folder navigation
        track_list_scaffold.dart   # shared body for track lists
        multi_disc_list.dart       # disc-grouped view
        album_list_screen.dart     # reusable: List<Album> → screen
        album_list_view.dart
        album_row_tile.dart
        library_item_tile.dart     # collapsible track row + popup menu
        library_action_sheet.dart
        grouped_track_list.dart    # artist → album+date grouping
        browse_screen.dart
        browse_content.dart
        browse_breadcrumb.dart
        browse_item_list.dart
        browse_item_tile.dart
        browse_files_screen.dart
    favorites/
      data/
        repositories/
          favorites_repository.dart
          favorites_repository_impl.dart   # Drift-backed (browse-item only)
      providers/
        favorites_provider.dart            # AsyncNotifier<List<Favorite>>
      widgets/
        favorites_screen.dart
  shared/
    widgets/
      artwork_widget.dart
      progress_bar.dart
      action_chip_button.dart
      transport_button.dart
      volume_slider.dart
      tracks_popup_menu.dart       # shared bulk-track action menu
      track_row.dart
      vu_meter.dart
      sub_screen_header.dart
      error_view.dart
      loading_view.dart
test/
  widget_test.dart
  core/
    network/
      mcws_xml_parser_test.dart
      mcws_client_test.dart
  features/
    connection/
      connection_repository_test.dart
    library/
      track_test.dart
```

---

## 3. Architecture Conventions

### Layered responsibilities
- **Widgets**: render + dispatch. No direct repository or Dio access.
  Read providers via `ref.watch` / `ref.listen`.
- **Providers (Riverpod)**: hold state, expose actions, call
  repositories. Use `AsyncNotifier` for anything that loads.
- **Repositories**: resolve `McwsClient` (or Drift `AppDatabase`,
  `LocalPlayerService`, etc.) from get_it; return `Either<AppException, T>`.
  No Flutter imports.
- **Models**: Freezed only; no logic beyond `fromJson` / computed getters.

### Widget file convention
Every public widget class lives in its own file. One public widget per
file — including router-stub screens (see `library_tab_routers.dart`).

### get_it scopes

| Scope | Lifetime | Registered types |
|---|---|---|
| **base** (default) | app lifetime | `Talker`, `AppDatabase`, `FlutterSecureStorage`, `SharedPreferences`, `McwsXmlParser`, `ConnectionRepository`, `PlayerRepository`, `RecentlyPlayedRepository`, `ZoneRepository`, `QueueRepository`, `LocalQueueRepository`, `LibraryRepository`, `FavoritesRepository`, `DownloadsRepository`, `DownloadService`, `LocalPlayerService`, `AndroidAutoPlayerService`, `JrrAudioHandler`, `AndroidAutoSessionService` |
| **`'session'`** | login → logout | `McwsClient` |

`ConnectionRepository.connect()` builds an `McwsClient` (with the auth
token resolved at request-time via a `tokenGetter` closure on the
`AuthInterceptor`), authenticates, then pushes the `'session'` scope and
registers the client there.
`ConnectionRepository.clearSession()` calls `await getIt.popScope()` —
`McwsClient` and its `Dio` instance are discarded automatically.

All audio-handling services (`LocalPlayerService`,
`AndroidAutoPlayerService`, `JrrAudioHandler`, `AndroidAutoSessionService`)
are **base-scope** singletons: local-style playback (and the Android Auto
notification surface) must survive logout, and on Android the
`MediaBrowserService` may bind before the user has authenticated. The
session scope is only for network-bound services.

All repositories that hit MCWS resolve the client at call-time via
`getIt<McwsClient>()`. They must only run while a session scope is
active (i.e. after successful authentication).

### Adaptive layout

`AdaptiveLayoutBuilder` (in `core/layout/`) chooses between two shells
based on `LayoutBreakpoints.wideScreen`:

- **Narrow shell** (`_NarrowLayout` in `root_screen.dart`):
  `Scaffold` + bottom `_TabBar` (5 tabs: Playing, Queue, Library, Zones,
  Settings) + `IndexedStack` body + optional `MiniPlayerPanel` in the
  Column above the tab bar.
- **Wide shell** (`TwoPanelShell`): a fixed-width `Sidebar` of the same
  5 nav items beside the same content area. Mini-player sits inside the
  content column above the bottom edge.

Both shells render the same `IndexedStack`-equivalent set of screens;
only the chrome (sidebar vs bottom tab bar) differs. The mini-player
must always participate in layout flow (never an overlay) so it can't
cover modals or popup menus.

### Riverpod rules
- **All state lives in Riverpod providers** — no `setState`, no local
  widget state for business logic.
- `ConsumerStatefulWidget` is allowed only for widget-lifecycle concerns:
  `TextEditingController`, `FocusNode`, `AnimationController`, scroll
  controllers. Never use it to hold loading flags, error state, or
  domain data.
- Use `late`, not `late final`, for fields initialized in `build()` —
  Riverpod can rebuild a notifier and reassign its dependencies.
- Never mutate state outside a notifier.
- Prefer `AsyncValue.guard` for repository calls.
- Compose providers with `ref.watch(otherProvider)`.
- Form-submission state (`AsyncValue<void>?`: null = idle, loading,
  error) belongs in a dedicated screen-scoped `@riverpod` notifier,
  auto-disposed when the screen leaves the tree
  (see `server_setup_provider.dart`).

### Code style
- **Always run `dart format .` after code changes.**
- Follow Dart's official style guide (80-character line limit).
- `dart fix --apply` for automatic mechanical fixes.
- CI rejects unformatted code or `flutter analyze` warnings.

## Routing (auto_route)

The app uses **nested auto_route** rather than the imperative
`NavigationNotifier` push/pop stack from earlier phases.

- A single `AppRouter` (`@AutoRouterConfig(replaceInRouteName: 'Screen,Route')`).
- `RootRoute` is the only top-level route; its children are sibling
  routes for unauthenticated state (`ServerSetupRoute`,
  `ConnectingRoute`) and the four library tab subtrees
  (`ArtistsTabRouterRoute`, `RandomTabRouterRoute`,
  `BrowseTabRouterRoute`, `FavoritesTabRouterRoute`).
- Each library tab has its own dedicated `@RoutePage` stub (e.g.
  `ArtistsTabRouterScreen → AutoRouter()`) so back/forward state is
  preserved per-tab.
- `LibraryScreen` mounts `AutoTabsRouter` over those four sub-routers
  with a custom segmented header for the active tab.
- The bottom-tab / sidebar shell is **not** auto_route-driven — it's a
  Riverpod-managed `IndexedStack` keyed by the `ActiveTab` enum
  (`nowPlaying`, `queue`, `library`, `zones`, `settings`).
  `ActiveTab.select(tab)` simply assigns the new tab; switching tabs
  does not clear sub-stacks.
- `RootScreen` gates access on `sessionProvider`:
  - `Restoring` → spinner.
  - `Unauthenticated` → `AutoRouter.declarative(routes: [ServerSetupRoute()])`.
  - `Authenticated` → `_AuthenticatedShell` (adaptive).
- Library tabs use *imperative* sub-navigation via `context.router.push`
  on `ArtistAlbumsRoute`, `AlbumDetailRoute`, `FolderTracksRoute`. The
  earlier "never use imperative `context.router.push`" rule no longer
  applies — it conflicts with the nested router model.

### Error handling
- Use functional style at repository boundaries — no try/catch in
  business logic.
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

- UI surfaces errors via `AsyncValue.error` + a shared `ErrorView`.
- Top-level safety net: `main.dart` installs `FlutterError.onError`
  and `PlatformDispatcher.instance.onError` to log uncaught widget /
  async errors via Talker.

### Logging (Talker)
- Single `Talker` instance via get_it.
- `TalkerDioLogger` redacts the `Token` query param value.
- `TalkerRiverpodObserver` logs all provider state transitions.
- `TalkerRouteObserver` is registered on the router config.

---

## 4. Persistence

### Drift (`app_database.dart`, schema version 7)

| Table | Columns | Purpose |
|---|---|---|
| `saved_servers` | `id` PK, `host`, `port` (default 52199), `username`, `password_key` (lookup key into `flutter_secure_storage`), `friendly_name?`, `last_used_at?`, `auth_token?`, `use_ssl` (default false), `ssl_port` (default 52200) | Persisted server configurations. Most-recently-used row drives silent reconnect. |
| `favorites` | `id` PK, `type` (always `'browse_item'`), `identifier` (browse node id), `display_name`, `added_at` | User-pinned browse-tree nodes. Surfaced via the Favorites sub-tab inside Library. |
| `local_queue_tracks` | `id` PK, `zone_id`, `file_key`, `track_json` (full serialized `Track`), `position` | Backing store for each virtual zone's just_audio queue so it survives app restarts. Rows are keyed by `zone_id` (Local, Offline, Android Auto each get their own queue). |
| `local_queue_state` | `zone_id` PK, `current_index` (default −1) | Last-played index per virtual zone. |
| `downloaded_tracks` | `file_key` PK, full denormalized track metadata, `file_path` (absolute path under app documents) | One row per locally-downloaded track. Source of truth for the Offline library and AA's "Downloads" browse branch. |
| `download_jobs` | `id` PK, `file_key`, `state` (queued / running / failed), `bytes_downloaded`, `bytes_total`, `enqueued_at`, `started_at?` | Persistent queue for the serial `DownloadService`. Surfaced as live progress in the UI. |

**Migrations** (additive — never edited):
- v1 → v2: create `favorites`.
- v2 → v3: create `local_queue_tracks`.
- v3 → v4: create `local_queue_state`.
- v4 → v5: create `downloaded_tracks` and `download_jobs`.
- v5 → v6: add `zone_id` to `local_queue_tracks`; recreate
  `local_queue_state` with `zone_id` as the primary key (the column
  change requires a table replacement rather than an `ALTER`).
- v6 → v7: add `use_ssl` and `ssl_port` to `saved_servers`.

Never edit a past migration — add a new one.

### flutter_secure_storage

Server passwords are written to the OS keychain/keystore under
`server_<host>_<port>_<username>`. Drift stores only the key, never
the password.

### Auth token persistence (departure from earlier spec)

The auth token **is** persisted on `SavedServers.auth_token`. This
enables silent reconnect on launch: `Session._attemptSilentReconnect()`
re-runs the full `connect()` (Authenticate + Alive) using the stored
password, which produces a fresh token. The persisted token is opaque
state and is wiped on `clearSession()`.

If silent reconnect fails (network down, password changed), the user
lands on `ServerSetupScreen` with fields prefilled from
`lastServerProvider`.

### Access-key lookup

`ServerSetupScreen` accepts either:
- a 6-character JRiver Access Key (resolved via the public registry at
  `http://webplay.jriver.com/libraryserver/lookup?id=...`, parsed by a
  small regex over `<ip>` / `<localiplist>` / `<port>` elements), or
- a manual `host:port`.

The lookup uses a separate `JRiverLookupApi` Retrofit client built with
`createPublicDio()` so it carries no auth interceptor.

### shared_preferences

Used for ephemeral, non-sensitive UI flags only:

| Key | Type | Purpose |
|---|---|---|
| `active_zone_guid` | String | Restored on next launch by `ActiveZone` notifier |
| `local_audio_quality` | String | Selected `LocalAudioQuality` enum name |
| `local_player_<zoneId>_index` | int | Last index in the virtual zone's queue (Local / Offline / Android Auto each get their own key) |
| `local_player_<zoneId>_position_ms` | int | Last playhead position per zone |
| `local_player_volume` | double | Last local-player volume (shared across virtual zones) |

Never credentials; never anything the parent spec lists as
canonical state.

### Logout

`Session.logout()`:
1. `await getIt<ConnectionRepository>().clearSession()` — pops the
   `'session'` get_it scope (discards `McwsClient`); blanks `auth_token`
   on **all** saved servers.
2. State → `SessionState.unauthenticated()`.

The active zone, polling timers, etc. fall out automatically: they
`ref.watch(sessionProvider)` and pause/clear when the session leaves
`Authenticated`. Local playback continues — it doesn't depend on the
session.

---

## 5. Networking

### Dio interceptor order

Interceptors are added in this order (first added = outermost):

1. **`AuthInterceptor`** — appends `Token=<token>` to every request's
   query parameters. Reads the current token via a `tokenGetter` closure
   captured at `McwsClient` creation. If the token is `null`, rejects
   immediately with `AppException.unauthorized()` (no request sent).
   Pass `options.extra['skipAuth'] = true` to bypass — set on
   `authenticate()` (HTTP Basic) and `alive()` via `@Extra` annotations.
2. **`LoggingInterceptor`** — wraps `TalkerDioLogger`; redacts the
   `Token` query param value (replaces with `***`).

No retry interceptor for v1 — transient failures surface as errors that
the user can retry manually via `ErrorView`.

### Network layer architecture

Two classes split HTTP from domain logic:

**`McwsApi`** (Retrofit) — pure HTTP interface; one method per MCWS
endpoint. Returns raw `String` (XML) or `List<Track>` (JSON).
`filesSearch` covers all library search queries; `browseChildren` (XML)
and `browseFiles` (JSON) handle tree browsing; `searchByFileKey`
fetches a single track via `File/GetInfo`.

**`McwsClient`** — domain client. Wraps `McwsApi` calls with:
- MCWS query-string construction (field filters, `~limit`, `~sort`).
- Value escaping (`_esc()` — prefixes `[ ] ( ) -` with `/`).
- Client-side exact-match filtering (MCWS does substring matching on
  field equality).
- XML response parsing via `McwsXmlParser`.
- `DioException` → `AppException` mapping.
- Domain-model transformation (`Track` → `Album`, flat XML fields →
  `PlayerStatus`).
- Local-streaming URL construction is **not** done here — the local
  player builds its own `File/GetFile` URLs (see §6).

All repositories resolve `McwsClient` from get_it; never `McwsApi`
directly.

### Album artist field

JRiver exposes two related fields per track:

- `Album Artist` — user-set tag, frequently empty.
- `Album Artist (auto)` — JRiver's computed value, **always populated**
  (falls back through compilation/album/track artist rules).

The app uses **`Album Artist (auto)`** (`Track.albumArtistAuto`)
everywhere a canonical album artist is needed: MCWS query construction,
client-side filtering, `Album.fromTrack`, persistence
(`downloaded_tracks.albumArtist`), and UI display. Never use the raw
`Track.albumArtist` for grouping or display — it can be empty and will
fragment albums under "Unknown Artist". When an `Album` is in hand, its
`albumArtist` field already holds the auto value (assigned in
`Album.fromTrack`).

### Virtual zones

`ZoneRepositoryImpl.getZones()` appends up to three synthetic zones to
the MCWS response:

- `Zone.local` — always present once authenticated.
- `Zone.offline` — always present (and the *only* zone in serverless
  mode, §"Offline").
- `Zone.androidAuto` — appended only while
  `AndroidAutoSessionService.isConnected` is `true`.

`Zone.local` and `Zone.androidAuto` are rendered alongside server zones
in the Zone list. The Local tile carries an inline audio-quality
`PopupMenuButton` (`LocalAudioQuality.lossless / lossyHigh / lossyNormal
/ lossyLow`). The AA tile mirrors that quality picker.

When the active zone is any virtual zone (`isLocal`, `isOffline`, or
`isAndroidAuto`):
- `PlayerPolling` stops (no remote `Playback/Info` calls).
- `NowPlayingScreen` and `MiniPlayerPanel` consume the
  `localPlaybackState` provider instead.
- Transport, seek, volume, mute, shuffle, repeat all route through the
  unified `Player` facade (`player_provider.dart`), which delegates to
  the `LocalPlayer` notifier. `LocalPlayer` wraps whichever
  `LocalPlayerServiceBase` implementation is appropriate for the
  active zone.

Consumer code should prefer the helper providers
`isVirtualZoneActive`, `isOfflineLikeActive`, and `isAndroidAutoActive`
over re-deriving these booleans from `activeZoneProvider`.

### Offline

MCWS has no offline mode for remote zones. When any request fails:
- `DioException` → mapped `AppException` variant.
- The provider's `AsyncValue` transitions to `AsyncValue.error`.
- `ErrorView` renders the error with a **Retry** button.
- `PlayerPolling` schedules its next tick regardless (errors are logged
  via Talker; the timer does not stop on transient failures).

The local zone is fully usable while remote zones are offline, **as
long as MCWS itself is reachable** for the streamed `File/GetFile`
URL — the file streams come from the same server.

---

## 6. Local & Android Auto Audio Playback

The Flutter app can play tracks directly on the device — either through
the in-app "Local" zone or through a connected **Android Auto** head
unit. Both surfaces share one playback engine and one set of Riverpod
state providers; they differ only in which `LocalPlayerServiceBase`
implementation is mounted and where playback state is published.

### Stream URL

Built per-track in `LocalPlayerService._createSource()`:

```
{baseUrl}File/GetFile?File={fileKey}&FileType=Key&Playback=1
                     &Conversion={conv}&Quality={qual}&Token={token}
```

`Conversion` and `Quality` come from the active `LocalAudioQuality`:

| Enum value | Conversion | Quality | Label |
|---|---|---|---|
| `lossless` | `wav` | `high` | Lossless |
| `lossyHigh` | `opus` | `high` | Lossy (high) |
| `lossyNormal` | `opus` | `normal` | Lossy (normal) |
| `lossyLow` | `opus` | `low` | Lossy (low) |

The selected quality is stored in `shared_preferences` under
`local_audio_quality`. Changing quality reloads the queue at the
current playhead position via `LocalPlayer._reloadWithNewQuality()`.

When the active zone is **Offline** and the chosen track is already in
`downloaded_tracks`, the player substitutes an `AudioSource.uri` over
the local `file://` path instead of building a `File/GetFile` URL.
Adding or removing a download triggers a queue reload so already-queued
items swap to or from the local file source.

### Layered design

| Layer | Type | Responsibility |
|---|---|---|
| **`LocalPlayerServiceBase`** | abstract `BaseAudioHandler` | Shared interface for any local playback engine: just_audio state + streams, transport, queue mutators. Subclasses live in `lib/features/player/services/`. |
| **`LocalPlayerService`** | base-scope singleton | Implementation for the Local and Offline zones. Wraps `just_audio.AudioPlayer`. `init()` configures `AudioSession.music` and activates it. Builds `AudioSource.uri` per track with the `Track` instance as `tag`. |
| **`AndroidAutoPlayerService`** | base-scope singleton | Implementation for the Android Auto zone. Also wraps `just_audio`, but adds `MediaBrowser` browse/search children and exposes a foreground-eligible `playbackState` from construction so the OS's foreground-service deadline can be met (§"Android Auto"). |
| **`JrrAudioHandler`** | composite `BaseAudioHandler` | Outer handler given to `AudioService.init`. Holds a `BehaviorSubject<BaseAudioHandler>` of the *active* player; pipes its `playbackState`, `mediaItem`, and `queue` to the OS via `rxdart.switchMap`. `switchTo(newPlayer)` swaps the active transport and pauses the previous one. All `MediaBrowser` overrides delegate to `AndroidAutoPlayerService`. |
| **`LocalPlayer{Position,State,Sequence,Volume,Duration}` providers** | `@Riverpod(keepAlive: true)` | One provider per just_audio stream. Each subscribes in `build()` (against the **currently mounted** `LocalPlayerServiceBase`) and cancels in `onDispose`. |
| **`localPlayerServiceProvider`** | `@Riverpod(keepAlive: true)` | Resolves the right `LocalPlayerServiceBase` for the active zone (`AndroidAutoPlayerService` when AA, otherwise `LocalPlayerService`) and tells `JrrAudioHandler.switchTo(...)` to follow. |
| **`localPlaybackState` provider** | computed | Aggregates the five stream providers into one `LocalPlaybackState` snapshot for UI consumption. |
| **`LocalPlayerSequence` provider** | `$StreamNotifierProvider` | Exposes `Stream<SequenceStateData>` — the just_audio sequence-state stream lifted into Riverpod. The Queue notifier watches this for the local/offline/AA branch instead of going through `LocalPlayer.future` (which would re-fire on every position tick). |
| **`LocalPlayer` (AsyncNotifier)** | `@Riverpod(keepAlive: true)` | Bootstraps the per-zone queue (`_loadQueue` reads Drift, restores index/position/volume) and exposes the action surface (`playPause`, `next`, `playNow`, `playNext`, `addToQueue`, etc.). Listens to its own sequence/index/volume changes and persists them per-zone. Reacts to `localAudioQualityPrefProvider` and `downloadedTracksProvider` to reload at new quality or to swap streaming↔local sources. Switching zones (Local → Offline → AA) triggers a synchronous re-load except for Android Auto, where the queue is driven exclusively by `playFromMediaId` / `playFromSearch` from the head unit (see "AA queue ownership" below). |
| **`McwsPlayer` (AsyncNotifier)** | `@Riverpod(keepAlive: true)` | Mirror of `LocalPlayer` for remote MCWS zones. Returns `null` for any virtual zone. |
| **`Player` (AsyncNotifier)** | `@Riverpod(keepAlive: true)` | Unified facade. Watches `activeZoneProvider`, then forwards every command (`playPause`, `next`, `seekTo`, `playNow`, etc.) to either `localPlayerProvider.notifier` or `mcwsPlayerProvider.notifier`. UI never branches on locality. |
| **`LocalQueueRepository`** | Drift-backed | Reads/writes the `local_queue_tracks` and `local_queue_state` tables. Rows are keyed by `zone_id` so each virtual zone has an independent queue. |

The order in `LocalPlayer.build()` matters:
1. `_loadQueue()` runs **synchronously before** any `ref.listen`
   subscriptions are registered. Otherwise the zero values just_audio
   emits during `setAudioSources` race against the saved index/position
   and overwrite them.
2. After load, the index, position, volume, and sequence listeners are
   wired up, and only then does the player begin saving state.

### AA queue ownership

For the Android Auto zone, **never** call `_loadQueue` on
`LocalPlayer.build()`. The head unit drives its own queue through
`playFromMediaId`, `playFromSearch`, and the browse-tree children
handlers — loading a persisted queue here would race against the
foreground-service deadline (`startForeground` must be called within
~5 s of the `MediaBrowserService` bind that opens the AA session) and
deadlock the main isolate with `setAudioSources`. The same provider
behavior is therefore conditional on `_currentZoneId != 'android-auto'`.

### Why the playback services are base-scope

The local player must outlive a session: a user can sign out from a
remote server while a track is still playing on the device. The Android
Auto handler must additionally be ready *before* a user authenticates,
because the OS may bind `MediaBrowserService` to enumerate the app's
browse root before the user opens the app. Every audio-related service
(`LocalPlayerService`, `AndroidAutoPlayerService`, `JrrAudioHandler`,
`AndroidAutoSessionService`) therefore lives in the base `get_it` scope.

---

## 6.1 Android Auto

The Android build participates in Android Auto and Automotive OS via the
`audio_service` plugin. The implementation has three moving parts:

### Session detection (`AndroidAutoSessionService`)

A `MethodChannel` (`com.jrr.jrr_f/android_auto`) receives a native
`onConnectionChanged(bool)` signal whenever a head unit binds or
unbinds. On `true`, the service:

1. Synchronously calls
   `JrrAudioHandler.switchTo(AndroidAutoPlayerService)` — the AA player
   seeds a foreground-eligible `playbackState` on construction so a
   subsequent `startForeground` call from the OS will succeed.
2. Flips `isConnected` (a `ValueNotifier<bool>`), which Riverpod's
   `androidAutoConnectedProvider` mirrors so the zone list refreshes.

On `false`, the service flips `isConnected` to `false`; the zone falls
out of the picker on the next zone refresh.

### Composite handler (`JrrAudioHandler`)

Implements `BaseAudioHandler`. Owns a `BehaviorSubject<BaseAudioHandler>`
seeded with `LocalPlayerService`. `playbackState`, `mediaItem`, and
`queue` from the active player are piped to the outer handler via
`switchMap`, so the lock-screen / notification / car UI always reflect
the active zone's player.

All `MediaBrowser` overrides (`getRoot`, `getChildren`, `search`,
`playFromMediaId`, `playFromSearch`) delegate to the
`AndroidAutoPlayerService` regardless of the active transport — the
head unit always talks to the AA player even if the user happens to be
playing through the Local zone simultaneously in the UI.

### AA player (`AndroidAutoPlayerService`)

Subclasses `LocalPlayerServiceBase`. Its browse tree is downloads-first
and **does not reach into the live MCWS library** (v1 — keeps the AA
surface usable offline):

```
Downloads
  ├── Recent
  ├── Artists ──► <artist> ──► <album> ──► track
  └── Albums ──► <album> ──► track
```

`MediaItem.id` for every leaf encodes the parent path via a `_join`
helper, so on `playFromMediaId(<trackId>)` the player can reconstruct
the *parent queue* (the album, the artist, etc.) and start playback at
the chosen track instead of playing the single item.

### Voice search (`VoiceIntentResolver`)

A pure Dart unit (no Flutter binding) that parses
`playFromSearch(query, extras)`:

- `android.intent.extra.focus = vnd.android.cursor.item/{artist|album|audio|genre}` selects the search dimension.
- `android.intent.extra.{artist,album,title,genre}` carry the structured fields.
- A leading `shuffle ` token strips and sets shuffle.
- When `extras` is empty, falls back to a free-text scan against
  downloaded tracks.

Returns a `VoiceIntent(tracks, shuffle)` for the AA player to load.

### Artwork (`MediaItemMapper`)

Android Auto loads `artUri` in the **system process**, not the app
process, so http(s) URLs that require auth tokens fail. The mapper
prefers a `content://` URI exposed by an Android `FileProvider` over the
cached artwork file on disk. The cache key is a stable hash (via
`crypto`) of the source MCWS URL. For non-downloaded tracks the mapper
falls back to the MCWS image URL (cleartext or HTTPS as configured),
relying on the head unit's own loader.

### AAOS compatibility

The Android manifest declares both `android.hardware.type.automotive`
and `com.android.automotive` metadata so the same APK serves phone-AA
and native Automotive OS head units.

---

## 6.2 Offline Downloads

Per-track downloads live in `lib/features/offline/`.

| Component | Responsibility |
|---|---|
| `DownloadsRepository` | Drift CRUD over `downloaded_tracks` and `download_jobs`. |
| `DownloadService` | Serial download runner. Streams `File/GetFile?Conversion=…&Quality=…` via Dio to the app documents directory; updates `bytes_downloaded` / `bytes_total` on the row; honors a `CancelToken` for in-flight cancels. |
| `downloadedTracksProvider` | `AsyncNotifier<List<DownloadedTrack>>` watched by the Offline library, the AA browse tree, and `LocalPlayer` (to swap streaming sources for local files). |
| `downloadJobsProvider` | Live feed of running and queued jobs for the in-app progress UI. |
| `downloadStatusProvider` | Per-track / per-album rollup for `AlbumDownloadProgressIndicator`. |

A `DownloadedTrack` is a denormalized mirror of `Track` plus the local
`file_path`. When the Offline zone is active, the library tab shows
only downloaded albums and artists; selecting a track plays the local
file directly. When the Local zone is active, the player still uses the
local file when one exists — downloads transparently accelerate Local
playback as well.

---

## 7. Code Generation

Run `dart run build_runner build --delete-conflicting-outputs` after
changes to:
- Freezed models (`*.freezed.dart`)
- Drift tables (`*.g.dart`)
- auto_route definitions (`*.gr.dart`)
- json_serializable DTOs (`*.g.dart`)
- Retrofit API definitions (`mcws_api.dart`, `jriver_lookup_api.dart`)
- Riverpod generator (`*.g.dart`)

`*.g.dart`, `*.freezed.dart`, `*.gr.dart` are committed (so CI doesn't
need to codegen).

---

## 8. Testing Strategy

### Scope for v2

| Layer | What to test | Tool |
|---|---|---|
| `McwsXmlParser` | All XML → map parsing, including failure responses | `flutter_test` |
| `McwsClient` | Each method: correct endpoint, params, token injection; error mapping | `mocktail` (mock `Dio`) |
| Repositories | Delegate correctly to `McwsClient`; map domain types | subclass + `buildClient` override; get_it scope in tearDown |
| Notifiers / Providers | State transitions (loading → data → error), polling start/stop, silent reconnect | `ProviderContainer` + `mocktail` |
| `Track` model | `parentPath()` + JSON converters (string/int coercion) | `flutter_test` |
| Key widgets | `NowPlayingScreen`, `TransportControls`, `ZoneListScreen` — render, tap, check state | `flutter_test` (planned) |

### Conventions
- Test files live in `test/features/<feature>/` mirroring
  `lib/features/<feature>/`.
- File naming: `<source_filename>_test.dart`.
- Use `mocktail` for all mocks — no `mockito` codegen.
- Widget tests use `ProviderScope` with overrides to inject mock
  repositories.
- No golden tests for v2.
- Run the full suite with `flutter test`; CI must pass before merge.

---

## 9. Build & Run

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs

flutter run                       # default device
flutter run -d macos              # macOS
flutter run -d windows            # Windows
flutter run -d linux              # Linux

flutter analyze
flutter test                      # offline unit + widget
dart format .
dart fix --apply
```

Pre-commit checklist (matches the global Dart rules):
1. `dart format .` — **mandatory**.
2. `flutter analyze` — zero warnings.
3. `flutter test` — green.

CI release pipeline builds Android, Windows, macOS, and Linux artifacts
on tagged releases (`actions/upload-artifact@v4` per platform, then a
release-collector job).

---

## 10. Implementation Phases

### Phase 1 — Foundation (done)
`flutter create`, dependencies, `build_runner`, get_it DI,
`AppRouter` scaffold, `McwsXmlParser`, `AppException` union, `Dio`
factory + `AuthInterceptor` + `LoggingInterceptor`, Drift database with
`saved_servers`, `flutter_secure_storage` integration, macOS network /
keychain entitlements.

### Phase 2 — Connection & Authentication (done)
`ServerInfo`, `McwsApi` + `McwsClient` two-layer architecture,
`ConnectionRepository`, `Session` notifier + `SessionState`,
`ServerSetupScreen` + `ConnectingScreen`, navigation guard.

### Phase 3 — Player Core (done)
Domain models, transport / info / seek / volume / mute / shuffle /
repeat methods, `PlayerRepository` + `ZoneRepository`,
`PlayerPolling` (intervals from parent spec §5.1), `PlayerProvider` +
`ZoneProvider` + `ActiveZoneProvider`, `NowPlayingScreen`,
`ZoneListScreen`.

### Phase 4 — Playing Now Queue (done)
Queue uses shared `Track` / `Tracks` model. `QueueRepository` covers
Playlist, PlayByIndex, PlayByKey, EditPlaylist, ClearPlaylist.
`QueueProvider` refreshes when `playingNowChangeCounter` increments.
`QueueScreen` + `QueueItemTile`.

### Phase 5 — Library Browse & Search (done)
- API: single `filesSearch` Retrofit endpoint; `_esc()` escaping.
- Browse: artists → albums → tracks drill-down; multi-disc grouping
  via `AlbumGroup` (`MultiDiscList` widget).
- Search via `librarySearchProvider`.
- Random Albums via `~limit` + `~n` modifiers.
- Folder browsing via `[Filename (path)]="path"`.
- Browse tree via `Browse/Children` + `Browse/Files`.
- `Track` extended with `dateReadable`, `fileType`, `albumArtist`,
  `albumArtistAuto`, `totalDiscs`, `discNumber`, `totalTracks`.
- Tolerant JSON parsing (`ForceStringConverter`, `ForceIntConverter`).

### Phase 6 — Mini Player (done)
`MiniPlayerPanel` in Column flow (not overlay). Shared between narrow
and wide shells. Tap navigates back to the Now Playing tab.

### Phase 7 — UI Design System (done)
`AppColors`, `AppFonts`, `AppTextStyles`, `buildAppTheme()` (Material 3
ThemeData wired to tokens). Consistent kebab `PopupMenuButton<String>`
across all playable items (Play / Play next / Add to playing now).
`SubScreenHeader`, `TransportButton`, `VolumeSlider` shared widgets.

### Phase 8 — Multi-platform & Local Playback (done)
- **Adaptive layout**: `AdaptiveLayoutBuilder` + `TwoPanelShell` +
  `Sidebar` for wide viewports; bottom-tab shell for narrow.
- **Settings tab**: `ServerManagerScreen` mounted as the 5th tab.
- **JRiver Access Key**: `JRiverLookupApi` resolves a 6-char key to
  `host:port`. `ServerSetupScreen` toggles between access-key and
  manual modes.
- **Silent reconnect**: persisted `auth_token` + secure-storage
  password drive `Session._attemptSilentReconnect()` on launch.
- **Local playback**: `just_audio` + `audio_session`,
  `LocalPlayerService`, full Riverpod stream wiring,
  `LocalQueueRepository` (Drift) for queue persistence,
  `LocalAudioQuality` selector on the Local zone tile.
- **Favorites**: Drift-backed `favorites` table; Favorites sub-tab in
  Library mirrors the Browse navigation stack.
- **Library navigation**: nested `AutoTabsRouter` with one router stub
  per sub-tab (Artists / Random / Browse / Favorites) so each tab has
  independent back-stack state.
- **Top-level error capture**: `FlutterError.onError` and
  `PlatformDispatcher.instance.onError` route to Talker.

### Phase 9 — Offline Startup & Stability (done)
- **Offline Startup**: Synthetic `ServerInfo.offline` session for
  server-less operation.
- **Manual Entry**: "Continue Offline" button on `ServerSetupScreen`
  to bypass login.
- **Silent Offline Reconnect**: App restores "Offline" zone state on
  launch without network checks if it was the last active zone.
- **Album Download Progress**: `AlbumDownloadStatusProvider` +
  `AlbumDownloadProgressIndicator` for aggregated album tracking.
- **Player Robustness**: Locking mechanism (`_isReloading`) and awaited
  async operations in `LocalPlayer` and `LocalPlayerService` to prevent
  race conditions and `RangeError` crashes.
- **Dynamic Logout**: Logout button becomes "Setup Server / Login" in
  offline mode.

### Phase 10 — Per-track Downloads (done)
- **Downloads schema**: `downloaded_tracks` + `download_jobs` Drift
  tables (schema v5).
- **`DownloadService`**: serial Dio-streamed downloads to the app
  documents directory; cancellable; live-updates `bytes_downloaded`.
- **Providers**: `downloadedTracksProvider`, `downloadJobsProvider`,
  `downloadStatusProvider` (per-track + per-album rollup).
- **Offline library**: Downloaded Albums / Downloaded Artists screens;
  the Offline zone restricts the library to these.
- **Source-swapping**: `LocalPlayer` watches `downloadedTracksProvider`
  and reloads the queue when downloads change, so playing items swap
  between streaming and local-file sources transparently. On the
  Offline zone, deleting a downloaded track in the queue drops it
  (no streaming fallback).

### Phase 11 — Android Auto / AAOS (done)
- **Virtual zone**: `Zone.androidAuto` (`isAndroidAuto: true`) appended
  to the zone list while a head unit is bound.
- **Service abstraction**: extracted `LocalPlayerServiceBase`;
  introduced `AndroidAutoPlayerService` alongside `LocalPlayerService`.
- **Composite handler**: `JrrAudioHandler` pipes the active
  transport's `playbackState` / `mediaItem` / `queue` to the OS via
  `rxdart.switchMap`; `MediaBrowser` overrides delegate to the AA
  player unconditionally.
- **Session detection**: `AndroidAutoSessionService` consumes a native
  `MethodChannel` (`com.jrr.jrr_f/android_auto`); synchronous
  `switchTo(AndroidAutoPlayerService)` on connect satisfies the
  foreground-service deadline.
- **Browse tree**: Downloads-first hierarchy (Downloads / Recent /
  Artists / Albums); `MediaItem.id` encodes parent path so a leaf tap
  reconstructs the parent queue.
- **Voice search**: pure-Dart `VoiceIntentResolver` handles
  `playFromSearch` extras (focus / artist / album / title / genre,
  leading `shuffle ` token) over downloaded tracks.
- **Artwork**: `MediaItemMapper` exposes cached art as `content://`
  via a Flutter-side `FileProvider` because AA loads `artUri` in the
  system process.
- **Recently played**: `RecentlyPlayedRepository` feeds the "Recent"
  AA branch.
- **Unified player surface**: split into `mcwsPlayerProvider` (remote)
  + `localPlayerProvider` (virtual zones); `playerProvider` is now a
  thin facade implementing the shared `PlayerController` interface.
- **Per-zone queue persistence**: `local_queue_tracks.zone_id` (schema
  v6); per-zone `local_player_<zoneId>_index` /
  `local_player_<zoneId>_position_ms` keys in `shared_preferences`.
- **AAOS manifest**: `android.hardware.type.automotive` +
  `com.android.automotive` so one APK serves both surfaces.

### Phase 12 — Future polish (planned)
- Adaptive layouts beyond the binary breakpoint (compact phone vs
  large tablet vs desktop).
- App-lifecycle pause/resume of polling timers
  (`AppLifecycleListener`).
- Reconnect / retry UX flows beyond `ErrorView`.
- macOS / Windows menu-bar integration.
- Cached artwork (see §11).

---

## 11. Open Questions (Flutter-specific)

1. **Image caching**: artwork URLs include `Token` as a query param.
   `cached_network_image` would need a custom `cacheKey` that strips
   the token to avoid stale entries after re-auth. Currently uncached.

2. **App-lifecycle handling**: parent spec §5.3 calls for paused
   polling on background / minimize. Not yet wired —
   `AppLifecycleListener` should drive `PlayerPolling.pause()` /
   `resume()` and the same on `ZonePolling`.

3. **Multiple saved servers UI**: the `saved_servers` table supports
   multiple rows. The UI today only surfaces the most-recent one
   (autofill on `ServerSetupScreen`); a server-picker is not yet built.

4. **Desktop window sizing**: no minimum window dimensions enforced.

5. **Local playback parity with remote**: shuffle/repeat in
   `LocalPlayerService` map to just_audio's modes; advanced shuffle
   (`Automatic`) and repeat (`Stop`) variants from MCWS are mapped to
   the closest just_audio equivalent (`shuffleEnabled` / `LoopMode`).

---

## 12. Best Practices

These reflect the rules we've converged on after eight phases. New
code should follow them by default; review should call out deviations.

### Async + state
1. **Order of operations matters in async notifiers.** When
   bootstrapping a `keepAlive` notifier from persisted state, finish
   loading **before** wiring listeners that persist updates — otherwise
   transient zero-values emitted during init overwrite the saved state.
   Pattern: `await _loadFromDisk(); ref.listen(...); ref.onDispose(...)`.
2. **Use `AsyncValue.guard` at the repository call boundary.** Don't
   try/catch inside notifier methods; let `Either<AppException, T>`
   bubble up and convert with `getOrElse((e) => throw e)` inside an
   `AsyncValue.guard` wrapper.
3. **Cancel every stream subscription in `ref.onDispose`.** Including
   stream-backed notifiers — a leaked subscription will keep
   `keepAlive` providers alive after the user logs out.
4. **ref.watch(sessionProvider) to gate work.** Polling notifiers,
   active-zone restoration, and library queries should *all* gate on
   the session state so logout naturally pauses them without explicit
   teardown.
5. **Synchronize recursive async actions.** Use a private boolean flag
   (e.g., `_isReloading`) to guard complex async loops. If a new request
   arrives while one is active, buffer it (e.g., `_reloadRequestedDuringReload`)
   instead of launching a parallel overlapping task.

### Routing
6. **Prefer nested AutoTabsRouter over a hand-rolled stack notifier.**
   When you need per-tab back history, give each tab its own
   `@RoutePage` router stub and let auto_route own the stack. Use
   `context.router.push` inside that subtree freely.
7. **Use `AutoRouter.declarative()` for binary flow gates** (auth,
   onboarding) where the route depends purely on a Riverpod state.

### Networking
8. **Inject the auth token via a closure, never via a captured
   string.** `AuthInterceptor` reads `tokenGetter()` at request-time;
   the token can be rotated in `ConnectionRepository` without rebuilding
   the `Dio` instance.
9. **Mark public endpoints with `@Extra({'skipAuth': true})`.** This
   keeps the auth interceptor declarative — no per-call branching in
   the interceptor itself.
10. **Build `Dio` per scope.** A second `createPublicDio()` for
   non-MCWS calls (e.g. the JRiver access-key registry) keeps
   interceptors targeted and avoids accidentally leaking the auth
   token to third-party hosts.
11. **Always set `ZoneType=ID` when a `Zone` parameter is present.**
   Codified as a default parameter in every Retrofit method.
12. **Tolerate type drift in JSON.** MCWS sometimes returns `"Key"` as
   a number, sometimes as a string. `ForceIntConverter` /
   `ForceStringConverter` keep deserialization stable.
13. **Client-side exact filter after MCWS field equality.** MCWS does
    substring matching on `[Field]=value`. For unique-key lookups
    (artist exact match, file path exact match) post-filter in the
    client.
14. **Check for synthetic sessions in Repositories.** When implementing
    MCWS methods, check if the current token or server address indicates
    an "Offline" state (e.g. `session == null` or `address.isEmpty`)
    and return a local fallback instead of making network calls.

### Local playback
15. **Local-zone services live in the base scope, not the session
    scope.** Logging out should not stop music that is already playing
    on the device. This extends to *every* audio-handling service —
    `LocalPlayerService`, `AndroidAutoPlayerService`, `JrrAudioHandler`,
    `AndroidAutoSessionService` — because the OS may bind
    `MediaBrowserService` before the user authenticates.
16. **Tag every `AudioSource` with the source `Track`.** The mini
    player and now-playing screen consume `tag` rather than carrying a
    parallel index.
17. **Persist queue state through Drift, not shared_preferences.**
    `shared_preferences` is fine for scalar UI flags; queues are
    structured data and want migrations.
18. **Await ALL audio player operations.** Operations like `insert`,
    `remove`, and `move` in `just_audio` are asynchronous. Failing to
    await them before the next state update can cause index out-of-bounds
    errors (RangeError).
19. **Per-zone queues, per-zone playhead.** Local, Offline, and
    Android Auto each have an independent `local_queue_tracks.zone_id`
    row set and their own `local_player_<zoneId>_*` keys in
    `shared_preferences`. Don't reuse a single global queue across
    virtual zones — switching back to a previous zone must restore
    what was last playing there.
20. **One unified `Player` facade.** All transport calls from the UI
    go to `playerProvider`. The facade dispatches to either
    `localPlayerProvider` or `mcwsPlayerProvider` based on
    `activeZoneProvider`. UI code never branches on locality.
21. **Composite audio handler for system integrations.** A single
    `JrrAudioHandler` is what `audio_service` knows about; the active
    inner player is swapped via `switchTo(...)`. `playbackState`,
    `mediaItem`, and `queue` flow through `BehaviorSubject.switchMap`,
    so the lock-screen and AA UI always reflect the active zone.
22. **Synchronous handler swap on Android Auto connect.** The OS
    opens a foreground-service deadline (~5 s) when it binds
    `MediaBrowserService`. `AndroidAutoSessionService.markActive` must
    call `switchTo(AndroidAutoPlayerService)` **synchronously** before
    the Riverpod zone refresh — the AA player seeds a
    foreground-eligible `playbackState` so `startForeground` from the
    OS will succeed. Going through Riverpod first is too late.
23. **AA queue is driven by the head unit, not by persisted state.**
    Skip `_loadQueue` when the active zone is `android-auto` — the
    car's `playFromMediaId` / `playFromSearch` is the source of truth,
    and a parallel `setAudioSources` from disk races the FGS deadline.
24. **`content://` artwork for Android Auto.** AA loads `artUri` in the
    *system* process, not the app's. Expose cached artwork via a
    `FileProvider` and a stable hash-based cache key (via `crypto`);
    do not hand AA an `http://…?Token=…` URL.
25. **Voice-search resolver stays a pure unit.** `VoiceIntentResolver`
    takes the downloaded-tracks catalog and the extras map; no Flutter
    binding, no platform channels. Tests run as plain `flutter_test`.
26. **Use the zone helper providers.** Consumer code should prefer
    `isVirtualZoneActive`, `isOfflineLikeActive`, and
    `isAndroidAutoActive` over re-deriving these booleans from
    `activeZoneProvider`. New zone types only need to update the
    helpers, not every call site.
27. **Stream-shaped providers for downstream `select`.** Player state
    that updates frequently (`LocalPlayerSequence`) exposes a
    `Stream<T>`; downstream notifiers `ref.watch(provider.select(...))`
    on the projection they care about (e.g. `.sequence` only) rather
    than awaiting `provider.future` — that would re-fire on every
    position tick.

### UI
28. **Mini-player participates in layout flow.** Never an overlay —
    overlays cover modals and popup menus.
29. **`PopupMenuButton` for every playable surface.** Same items, same
    icon, same density. The user shouldn't have to learn three
    different action surfaces.
30. **One public widget per file.** Including stub router widgets.
31. **Centralize text styles.** All non-trivial `TextStyle`s live in
    `AppTextStyles`.
32. **Sliver-based primary scrolling surfaces.** Library, Artists,
    Favorites, Browse, Queue, and Downloaded Artists all use
    `CustomScrollView` + slivers so they can integrate with
    `ScrollChromeListener` (header / mini-player auto-hide).

### Persistence
33. **`flutter_secure_storage` for credentials, Drift for everything
    else.** Never put a password in `shared_preferences` or in the
    Drift schema directly.
34. **Schema migrations are append-only.** Never edit a previous
    migration; add a new one and bump `schemaVersion`.
35. **Wipe the persisted auth token on `clearSession()`.** Token reuse
    after logout is a footgun; force a fresh `Authenticate` next time.
36. **Decouple Session from ActiveZone via Preferences.** Instead of
    reading the `activeZoneProvider` notifier during session transitions,
    write the desired GUID to `SharedPreferences`. This avoids circular
    initialization loops between the session and zone providers.

### Logging
37. **One `Talker` instance.** Inject via get_it; route Dio,
    Riverpod, and route-observer logs through it. The
    `LoggingInterceptor` redacts the token query param.
38. **Catch top-level errors at `main()`.** `FlutterError.onError` for
    framework errors, `PlatformDispatcher.instance.onError` for async
    errors that escape the framework.

### Case-Insensitivity
39. **String equality for models is case-insensitive where appropriate.** Many MCWS tags (Artist, Album, Genre) are inconsistent in their casing. The `Track`, `Album`, and `DownloadedTrack` models override `operator ==` and `hashCode` to use case-insensitive comparison for these fields.
40. **Use `equalsIgnoreCase` extension.** For consistency, always use the `equalsIgnoreCase` extension (from `lib/shared/extensions/string_extensions.dart`) instead of `toLowerCase() == toLowerCase()`.
41. **Normalize grouping keys to lowercase.** The `albumGroupId` getter on `Track` and the `id` on `AlbumGroup` must be fully lowercased: `'${name.toLowerCase()}|${parentFolderPath.toLowerCase()}'`. This ensures consistent grouping across different track entries and filesystem paths.
42. **Filter offline data case-insensitively.** When filtering `downloaded_tracks` in providers (e.g. by artist name), use `equalsIgnoreCase`.

---

## 13. Changelog

| Version | Date | Notes |
|---|---|---|
| 0.1.0 | 2026-04-14 | Initial Flutter spec — all TODO sections filled in |
| 0.1.1 | 2026-04-15 | get_it scopes for `McwsClient`; `skipAuth`; logout async |
| 0.1.2 | 2026-04-16 | Phase 5 added; Polish renumbered |
| 0.2.0 | 2026-04-19 | Phases 1–6 done. Retrofit API, mini player, library browse, random albums, escaping, multi-disc support |
| 0.2.1 | 2026-04-20 | Folder browsing, `TrackListScaffold`, collapsible track info, `Album.albumArtist`, `Track.dateReadable` |
| 0.3.0 | 2026-04-21 | Browse tree (Browse/Children + Browse/Files); `BrowseFilesView` flat/grouped toggle |
| 0.4.0 | 2026-04-21 | UI design system (Phase 7): `AppTextStyles`, kebab popup menus everywhere, bottom tabs, `MiniPlayerPanel` in Column flow, `SubScreenHeader`, segmented Library tabs |
| 2.2.0 | 2026-05-05 | Phase 8: adaptive narrow/wide layouts (`AdaptiveLayoutBuilder` + `TwoPanelShell` + `Sidebar`), Settings tab, JRiver Access Key lookup, silent reconnect with persisted `auth_token`, **local playback** (just_audio + audio_session, `LocalPlayerService`, persisted local queue via Drift, `LocalAudioQuality` selector), Favorites tab + Drift-backed `favorites` table, nested `AutoTabsRouter` per Library sub-tab, top-level error handlers in `main`, `Tracks`/`Zones` Freezed wrappers, AlbumGroup multi-disc helper, `Track.fileType`, `Track.albumArtistAuto`. Schema bumped to v4 (favorites, local_queue_tracks, local_queue_state). Added Best Practices section. Imperative `context.router.push` allowed inside library sub-routers. |
| 2.3.0 | 2026-05-06 | Case-insensitive string comparison for Track/Album fields; `StringExtensions.equalsIgnoreCase`; lowercase normalization for `albumGroupId` and `AlbumGroup.id`. |
| 2.5.1 | 2026-05-10 | Phase 9: Offline Startup, synthetic offline sessions, album download progress tracking, synchronized player reloads, and decoupling of session/zone providers. Added Best Practices for async synchronization and provider decoupling. |
| 2.6.0 | 2026-05-13 | Adaptive chrome (`ScrollChromeListener` + `libraryChromeVisibleProvider`); sliver migration across Artists/Random/Favorites/Browse/Queue/Downloaded Artists; chrome-visibility cleanup on disposal. |
| 2.7.0 | 2026-05-16 | Phase 10 (per-track downloads: `downloaded_tracks` / `download_jobs` schema v5, `DownloadService`, source-swapping in `LocalPlayer`) + Phase 11 (Android Auto / AAOS: `Zone.androidAuto`, `LocalPlayerServiceBase` abstraction, `AndroidAutoPlayerService`, composite `JrrAudioHandler`, `AndroidAutoSessionService`, downloads-first browse tree, `VoiceIntentResolver`, `MediaItemMapper` with `content://` artwork, per-zone queue persistence schema v6, `use_ssl`/`ssl_port` on `saved_servers` schema v7). Unified `playerProvider` facade over `localPlayerProvider` + `mcwsPlayerProvider` via `PlayerController`. New helper providers `isAndroidAutoActive`, `isOfflineLikeActive`, `isVirtualZoneActive`. `LocalPlayerSequence` now exposes `Stream<SequenceStateData>`; `Queue` notifier reacts via `.select((s) => s?.sequence)` instead of awaiting `LocalPlayer.future` on every position tick. Added `audio_service`, `rxdart`, `connectivity_plus`, `share_plus`, `file_selector`, `crypto`, `path_provider` to the tech stack. |

