# JRR Test Coverage Plan

_Last updated: 2026-05-21_

## 1. Current state

- **Overall line coverage:** 34.06% (1140 / 3347 instrumented lines) — only files exercised by at least one test are instrumented, so true coverage of the whole codebase is lower.
- **Test files:** 11 — all passing (55 tests).
- **Source files (excluding `*.g.dart` / `*.freezed.dart`):** ~140.
- **Tooling:** `flutter_test`, `mocktail`. No widget tests, no golden tests, no integration tests.

### What is covered today (≥50%)

| File | Coverage |
| --- | --- |
| `core/network/mcws_xml_parser.dart` | 100% |
| `features/player/data/repositories/recently_played_repository.dart` | 100% |
| `features/library/data/models/track.dart` | 96% |
| `features/offline/data/models/downloaded_track.dart` | 94% |
| `features/player/services/voice_intent_resolver.dart` | 90% |
| `features/library/data/models/album.dart` | 63% |
| `features/offline/services/download_service.dart` | 62% |
| `features/offline/data/repositories/downloads_repository_impl.dart` | 57% |

### What is NOT covered at all

- All **screens, widgets and view-states** under `features/*/widgets/` (≈ 45 files) and `shared/widgets/` (12 files).
- All **Riverpod view-models / providers** (≈ 35 files across features).
- **Routing / shell:** `core/router/*`, `core/layout/*`.
- **Networking glue:** `dio_factory.dart`, both interceptors, `ssl_trust.dart`, `jriver_lookup_api`.
- **Player services:** `local_player_service*`, `jrr_audio_handler`, `media_item_mapper`, `android_auto_player_service`.
- **Repositories:** library, favorites, queue (local + remote), zones, player.
- **Persistence:** `core/db/app_database.dart` (Drift schema/DAO), beyond the small portion the downloads repo hits.
- **DI:** `core/di/providers.dart`.

## 2. Goals

1. Lift overall line coverage from **34%** to **≥ 75%** measured against the full `lib/` tree (excluding generated code and `main.dart`).
2. Every file under `data/models`, `data/repositories`, `services`, and `providers/*view_model*` has dedicated unit tests at ≥ 85%.
3. Every screen has at least one widget test (smoke + a single interaction).
4. Every Riverpod view-model has tests for each emitted state (idle / loading / data / error).
5. Critical user journeys covered by integration tests (server connect → browse → play → queue → offline download).

## 3. Test strategy by layer

### 3.1 Pure Dart / models (unit tests)
- Fastest to write, no Flutter binding needed.
- Use `flutter_test` with `test()` only; verify JSON round-trips for `*.g.dart`-generated models, equality, copyWith, edge cases (empty / corrupt payloads).

### 3.2 Repositories (unit tests with mocktail)
- Mock `McwsClient` / `Dio` / Drift DAOs.
- Verify: query construction, error mapping into `AppException`, retry/escape behaviour, caching where present.
- For Drift DAOs use the in-memory `NativeDatabase.memory()` driver.

### 3.3 Services (unit tests, fake clocks)
- Player, download, voice resolver, media mapper.
- Stub platform plugins (`just_audio`, `audio_service`, `path_provider`, `shared_preferences`, `flutter_secure_storage`) via mocktail + plugin-channel test helpers.

### 3.4 View-models (provider tests)
- Use `ProviderContainer` + `container.listen` to assert state transitions.
- Override every dependency provider with a mock repository / service.

### 3.5 Widgets (widget tests)
- `pumpWidget` inside a `ProviderScope(overrides: …)`.
- Cover: loading skeleton, populated state, error view, primary tap actions, scroll & paging trigger.
- Golden tests for visually load-bearing widgets (mini player, now-playing scrubber, VU meter, album row tile).

### 3.6 Routing / layout
- Smoke test `RootScreen` with adaptive layout under both narrow and wide `MediaQuery` sizes.
- Verify `navigation_notifier` emits expected events.

### 3.7 Integration tests (`integration_test/`)
- One scripted run per critical journey, using a fake `McwsClient` so tests are hermetic.

## 4. Phased plan

Each phase ends with `flutter test --coverage` recorded in the PR description.

### Phase 1 — Pure model & utility unit tests _(target +8% coverage)_
- [ ] `core/network/models/auth_result.dart`
- [ ] `core/error/app_exception.dart`
- [ ] `features/library/data/models/albums.dart`
- [ ] `features/library/data/models/album_group.dart`
- [ ] `features/library/data/models/browse_item.dart`
- [ ] `features/library/data/models/tracks.dart`
- [ ] `features/offline/data/models/download_job.dart`
- [ ] `features/offline/data/models/download_state.dart`
- [ ] `features/player/data/models/player_state_data.dart`
- [ ] `features/player/data/models/player_status.dart`
- [ ] `features/player/data/models/repeat_mode.dart`
- [ ] `features/player/data/models/shuffle_mode.dart`
- [ ] `features/player/data/models/local_audio_quality.dart`
- [ ] `features/player/data/models/local_palyback_state.dart`
- [ ] `features/player/data/models/sequence_state_data.dart`
- [ ] `features/zones/data/models/zone.dart` + `zones.dart`
- [ ] `features/connection/data/models/server_info.dart`
- [ ] `shared/extensions/string_extensions.dart` (fill remaining)

### Phase 2 — Networking & low-level core _(target +6%)_
- [ ] `core/network/mcws_client.dart` — push from 48% → 90%: cover every query helper, error mapping, encoding edge cases (`[]()-`, unicode).
- [ ] `core/network/dio_factory.dart` — verify base URL, timeouts, interceptor wiring.
- [ ] `core/network/interceptors/auth_interceptor.dart` — token injection, refresh-on-401.
- [ ] `core/network/interceptors/logging_interceptor.dart` — masking secrets, sample payload assertions.
- [ ] `core/network/ssl_trust.dart` — trust-all behaviour gated by flag (use HttpServer fake).
- [ ] `core/network/jriver_lookup_api.dart` — happy path + 4xx mapping.

### Phase 3 — Repositories _(target +10%)_
- [ ] `features/connection/data/repositories/connection_repository_impl.dart` — push 42% → 90%, including discovery + secure-storage fallback.
- [ ] `features/library/data/repositories/library_repository_impl.dart`
- [ ] `features/favorites/data/repositories/favorites_repository_impl.dart`
- [ ] `features/player/data/repositories/player_repository_impl.dart`
- [ ] `features/queue/data/repositories/queue_repository_impl.dart`
- [ ] `features/queue/data/repositories/local_queue_repository_impl.dart`
- [ ] `features/zones/data/repositories/zone_repository_impl.dart`
- [ ] `features/offline/data/repositories/downloads_repository_impl.dart` — push 57% → 95%.
- [ ] `core/db/app_database.dart` — DAO tests with `NativeDatabase.memory()` (covers a meaningful slice of `app_database.g.dart`).

### Phase 4 — Services _(target +6%)_
- [ ] `features/player/services/local_player_service.dart` + `local_player_service_base.dart`
- [ ] `features/player/services/jrr_audio_handler.dart`
- [ ] `features/player/services/media_item_mapper.dart`
- [ ] `features/player/services/android_auto_player_service.dart` — at minimum, callback dispatch.
- [ ] `features/zones/services/android_auto_session_service.dart`
- [ ] `features/offline/services/download_service.dart` — push 62% → 95% (cover cancel, fail, resume paths).

### Phase 5 — View-models / providers _(target +12%)_
For each, override the underlying repository/service with mocks and assert the state sequence.
- [ ] `features/connection/providers/{server_manager_view_model, server_setup_view_model, session_provider, last_server_provider}.dart`
- [ ] `features/library/providers/{library_providers, album_row_tile_view_model, library_item_tile_view_model}.dart`
- [ ] `features/favorites/providers/favorites_provider.dart`
- [ ] `features/offline/providers/{download_jobs_provider, download_status_provider, downloaded_tracks_provider, downloaded_artists_view_model}.dart`
- [ ] `features/player/providers/{player_provider, player_controller, mcws_player_provider, local_player_provider, local_audio_quality_provider, mini_player_view_model, now_playing_view_model, player_polling_provider}.dart`
- [ ] `features/queue/providers/{queue_provider, queue_view_model}.dart`
- [ ] `features/zones/providers/{active_zone_provider, zone_list_view_model, zone_polling_provider, zone_provider}.dart`
- [ ] `shared/widgets/tracks_popup_menu_view_model.dart`
- [ ] `core/router/navigation_notifier.dart`
- [ ] `core/lifecycle/app_lifecycle_provider.dart`

### Phase 6 — Widgets (smoke + interaction) _(target +8%)_
- [ ] Connection: `connecting_screen`, `server_manager_screen`, `server_setup_screen`.
- [ ] Library: `library_screen`, `album_list_view`, `album_detail_screen`, `artist_albums_screen`, `browse_screen` + tabs, `track_list_scaffold`, `browse_breadcrumb`, `multi_disc_list`, `grouped_track_list`, `library_action_sheet`.
- [ ] Player: `mini_player_panel`, `now_playing_screen`.
- [ ] Queue: `queue_screen`, `queue_item_tile`.
- [ ] Offline: `downloaded_albums_screen`, `downloaded_artists_screen`, `downloaded_album_detail_screen`, `confirm_delete_dialog`, `download_progress_indicator`, `album_download_progress_indicator`.
- [ ] Zones: `zone_list_screen`, `zone_tile`.
- [ ] Favorites: `favorites_screen`.
- [ ] Shared: `artwork_widget`, `progress_bar`, `track_row`, `tracks_popup_menu`, `transport_button`, `vu_meter`, `volume_slider`, `error_view`, `loading_view`, `sub_screen_header`, `action_chip_button`, `scroll_chrome_listener`.

### Phase 7 — Routing, layout, theme _(target +3%)_
- [ ] `core/router/app_router.dart` — guard / redirect logic.
- [ ] `core/router/root_screen.dart` — narrow vs wide layout under `MediaQuery`.
- [ ] `core/layout/adaptive_layout.dart`, `two_panel_shell.dart`, `sidebar.dart`, `layout_breakpoints.dart`.
- [ ] `core/theme/app_theme.dart` — both themes resolve without throwing; key color tokens present.
- [ ] `core/orientation/orientation_lock.dart`.

### Phase 8 — Golden tests _(no coverage impact, regression safety)_
- [ ] `mini_player_panel` (compact + playing + paused).
- [ ] `now_playing_screen` (with / without artwork).
- [ ] `album_row_tile`.
- [ ] `vu_meter` at multiple amplitudes.
- [ ] `track_row` (downloaded badge / playing indicator / queued).

### Phase 9 — Integration journeys _(no line-coverage impact, but locks behaviour)_
Place under `integration_test/`, run on a host with `flutter test integration_test`.
- [ ] First-run: discover server → enter credentials → land on library.
- [ ] Browse → tap album → play track → confirm now-playing reflects state.
- [ ] Queue: add tracks, reorder, remove, persist across app restart.
- [ ] Offline: download an album → go airplane mode → play from cache.
- [ ] Zone switch updates active player and resumes from the right state.

## 5. Tooling & conventions

- Test layout mirrors `lib/`: `test/features/<feature>/<layer>/<file>_test.dart`.
- Per `dart.md`: trailing commas, `const` where possible, `dart format .` before staging.
- Use `mocktail` (already a dev dep) — register fallback values for sealed classes / freezed unions in a shared `test/setup/fallbacks.dart`.
- Add `test/setup/test_pump.dart` helper: `pumpWithRiverpod(WidgetTester, Widget, {List<Override> overrides})`.
- Add `test/setup/fake_mcws_client.dart` — programmable fake to be reused across repository and view-model tests.
- Coverage: gate CI on `flutter test --coverage` and a minimum threshold (see §6). Generate HTML locally with `genhtml coverage/lcov.info -o coverage/html` (install lcov via Homebrew).
- Excludes for coverage: `lib/main.dart`, `**/*.g.dart`, `**/*.freezed.dart`, `lib/core/router/app_router.gr.dart`. Add to a `coverage_excludes` script or use `lcov --remove`.

## 6. Milestones & ratchet

| Milestone | Cumulative target | Done after |
| --- | --- | --- |
| M1 | 45% | Phase 1 + 2 |
| M2 | 60% | Phase 3 + 4 |
| M3 | 72% | Phase 5 |
| M4 | 80% | Phase 6 + 7 |
| M5 | _no number_ — golden + integration safety net | Phase 8 + 9 |

Add a CI step that fails the build if line coverage drops more than 1% below the latest milestone.

## 7. Open questions

- **Platform channels** for `just_audio`, `audio_service`, `flutter_secure_storage` need fake channel handlers. Decide whether to write per-test fakes or one shared `test/setup/platform_channels.dart`.
- **Android Auto** services are tightly coupled to platform code — agree on a minimum smoke contract before investing in deeper tests.
- **Golden tests** require a fixed font (`flutter_test`'s Ahem) — decide if we want platform-specific goldens or a single golden set on Linux CI.
