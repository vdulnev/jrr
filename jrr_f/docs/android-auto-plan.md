# Android Auto Support — Implementation Plan

## 1. Goal

Expose JRR's playback and browsing capabilities to Android Auto so a paired
Android phone running JRR can act as the source for in-car media playback.
The app must:

1. Show a browsable library hierarchy (Artists / Albums / Recent / Downloads)
   in the Android Auto UI.
2. Stream audio to the car (via the phone's Bluetooth/USB connection to the
   head unit) — the car renders, the phone plays.
3. Surface "Now Playing" metadata, album art, and transport controls
   (play/pause, skip, seek) on the head unit.
4. Handle voice commands ("play artist X", "skip track").
5. Behave correctly across drive-time transitions (network loss, screen
   lock, call interruption).

The existing remote-control mode (sending MCWS commands to a server playing
on a different zone) is **out of scope** for v1 — Android Auto playback
requires the audio to come from the phone, so we'll only support the
**Local zone**, **Offline zone**, and the new **Android Auto virtual zone**
described below.

## 2. Architectural framing — Android Auto as a virtual zone

JRR already models two non-MCWS playback targets as **virtual zones** —
[Zone.isLocal](../lib/features/zones/data/models/zone.dart) (the phone's
own just_audio player) and [Zone.isOffline](../lib/features/zones/data/models/zone.dart)
(a synthetic zone backed by downloaded files only). The rest of the app
(queue, player, library) branches on these flags to route reads/writes to
the right backend.

This plan adds a third virtual zone — **Android Auto** — following the
same shape:

- A `Zone` with `isAndroidAuto: true`, surfaced in the zone picker only
  when an Auto session is actually connected.
- A dedicated playback backend (the `audio_service` MediaBrowserService)
  that the rest of the app routes to when this zone is active, in
  exactly the same way `LocalPlayer` is routed to today for the Local
  zone.
- A browse hierarchy exposed to Android Auto that mirrors what the
  active AA zone knows about — library, downloads, recents.

Why a virtual zone rather than grafting AA onto the Local zone:

- AA can run while the phone screen is locked, with no Flutter UI active.
- AA has its own queue / now-playing / focus lifecycle that should not
  fight with the Local zone's just_audio instance.
- The user may want Local-zone playback on the phone *while* AA is
  paused in the car (or vice versa). Two zones, two states.

## 3. Why this is a substantial effort

Flutter has no first-class Android Auto support. Android Auto integrates
with the platform via a Java/Kotlin `MediaBrowserServiceCompat` (or
`MediaLibraryService` on Media3). The Flutter widget tree never runs in
the car — only the metadata exposed via that service is shown. So we
cannot "port the UI" to Auto; we must build a parallel browse hierarchy
on the native side and bridge to Flutter for playback state.

Two practical paths:

- **Path A — adopt `audio_service`**: replace direct just_audio usage
  with `audio_service` (which embeds just_audio under the hood). It
  provides a ready-made `AudioHandler` that already exposes a
  MediaBrowserService and integrates with Android Auto. **Recommended.**
- **Path B — write our own `MediaBrowserService`** in Kotlin and
  communicate with Flutter over MethodChannel/EventChannel. More
  control, far more code, error-prone synchronization.

This plan assumes Path A.

## 4. Zone model and routing changes

### 4.1 `Zone` flag

[zone.dart](../lib/features/zones/data/models/zone.dart):

```dart
@freezed
abstract class Zone with _$Zone {
  const factory Zone({
    required String id,
    required String name,
    required String guid,
    required bool isDLNA,
    @Default(false) bool isLocal,
    @Default(false) bool isOffline,
    @Default(false) bool isAndroidAuto, // NEW
  }) = _Zone;
}
```

### 4.2 Synthetic zone constant

[zone_repository_impl.dart](../lib/features/zones/data/repositories/zone_repository_impl.dart):

```dart
const androidAutoZone = Zone(
  id: 'android-auto',
  name: 'Android Auto',
  guid: 'android-auto-zone-guid',
  isDLNA: false,
  isAndroidAuto: true,
);
```

`getZones()` appends `androidAutoZone` only when an Auto session is
currently connected (see §6). `setActiveZone()` short-circuits for the
new zone the same way it does for `local` / `offline` — no MCWS call.

### 4.3 Centralized branching

Introduce derived providers to keep the three-way routing concise:

```dart
@riverpod
bool isAndroidAutoActive(Ref ref) =>
    ref.watch(activeZoneProvider)?.isAndroidAuto == true;

@riverpod
bool isVirtualZoneActive(Ref ref) {
  final z = ref.watch(activeZoneProvider);
  return z?.isLocal == true ||
      z?.isOffline == true ||
      z?.isAndroidAuto == true;
}
```

### 4.4 Audit of existing branches

Every existing consumer of `isLocal` / `isOffline` becomes three-way:

- [queue_provider.dart](../lib/features/queue/providers/queue_provider.dart):
  `build()` checks `zone.isLocal || zone.isOffline` → returns the
  `LocalPlayer` sequence. Add a third branch: when `zone.isAndroidAuto`,
  return the AA handler's current queue (see §7).
- [zone_polling_provider.dart](../lib/features/zones/providers/zone_polling_provider.dart):
  already skips MCWS polling for Local/Offline. Skip for AA too.
- [library_providers.dart](../lib/features/library/providers/library_providers.dart):
  many guards on `isOfflineActiveProvider`. AA's library view follows
  the *Offline* path (downloads-only) for v1, so migrate the relevant
  guards to `isLocalLikeActive` (offline + AA).
- [active_zone_provider.dart](../lib/features/zones/providers/active_zone_provider.dart):
  the `wasOffline` → refresh logic should generalize to
  "was-virtual-zone-without-server" and fire for `wasAndroidAuto` too.

## 5. AA-side playback backend

### 5.1 Handler topology

```
Android Auto head unit ──┐
                         ▼
            JrrAudioHandler (audio_service, background isolate)
                         ▲
                         │ streams + commands (AudioService.connect)
                         ▼
            AndroidAutoPlaybackController (UI isolate)
                         ▲
                         │ ref.watch / ref.read
                         ▼
      queueProvider / playerProvider (when isAndroidAutoActive)
```

- `JrrAudioHandler` is the owner of the AA zone's player state. Its
  queue, current index, and playback state ARE the AA zone's
  `queueProvider` / `playerProvider` data.
- The handler runs even when no UI is open (background isolate on
  Android).
- `AndroidAutoPlaybackController` exposes the handler's streams to
  Riverpod providers in the UI isolate, so when the user opens the
  phone app *while the car is connected* and selects the AA zone, the
  queue screen shows the car's current queue, the player screen shows
  the car's now-playing, and transport buttons in Flutter forward to
  the handler.

The Local zone keeps using `LocalPlayerService` unchanged. Two players
coexist; only one is "active" at a time per the zone selection.

### 5.2 `audio_service` migration steps

1. Add `audio_service: ^0.18.x` to [pubspec.yaml](../pubspec.yaml).
2. Create `lib/features/player/services/jrr_audio_handler.dart` — an
   `AudioHandler` that:
   - Wraps an `AudioPlayer`.
   - Forwards `playbackState`, `mediaItem`, and `queue` streams from
     just_audio events.
   - Implements `play`, `pause`, `stop`, `skipToNext`, `skipToPrevious`,
     `seek`, `setShuffleMode`, `setRepeatMode`, `playFromMediaId`,
     `playFromSearch`, `customAction`.
3. Boot the handler in [injection.dart](../lib/core/di/injection.dart)
   via `AudioService.init(builder: () => JrrAudioHandler(...), config: ...)`
   instead of constructing `AudioPlayer` directly.
4. Decision point — collapse vs coexist:
   - **Collapse**: update
     [local_player_service.dart](../lib/features/player/services/local_player_service.dart)
     to use the handler's player. Cleaner; bigger refactor surface.
   - **Coexist**: keep `LocalPlayerService` for the Local zone; the
     handler owns the AA zone only. Less risk, more code.
   Recommendation: **collapse** in Phase 2 so there's one source of
   truth for playback. If schedule is tight, coexist for v1 and
   collapse later.
5. Update [main.dart](../lib/main.dart) — `audio_service` requires
   initialization before `runApp`.
6. Configure the foreground notification (channel ID, icon, action
   layout) in `AudioServiceConfig`.

**Phase 2 exit**: existing Local-zone playback works exactly as today,
plus the system media notification (lock screen + pull-down) appears
with the JRR controls.

## 6. Detecting an Android Auto session

The phone needs to know "is the car connected right now" to decide
whether to surface the zone. Source of truth: `MediaBrowserService`
callbacks — Android Auto calls `onGetRoot` / `onLoadChildren` when the
head unit binds.

1. Add `lib/features/zones/services/android_auto_session_service.dart`:
   - Holds a `ValueNotifier<bool> isConnected`.
   - Set `true` from `JrrAudioHandler.getChildren(root)` (called when
     Auto binds) and on receipt of any client-bound event.
   - Set `false` after a debounced "no activity" timeout, or on
     explicit `onUnbind`.
2. Wrap as a Riverpod provider:
   ```dart
   @riverpod
   Stream<bool> androidAutoConnected(Ref ref) => /* from service */;
   ```
3. `ZoneRepositoryImpl.getZones()` includes/excludes the AA zone based
   on the latest connected value.
4. `ZoneList` provider watches `androidAutoConnectedProvider` so the
   list refreshes when the car connects/disconnects.

Edge case: if AA is the saved active zone but no car is currently
connected, fall back to the previous zone with a snackbar (mirrors the
current Offline-fallback behaviour).

## 7. Browse hierarchy

`audio_service` calls `getChildren(parentMediaId)` whenever Android Auto
requests a folder. Expose:

```
ROOT
├── Recent
├── Downloads
├── Artists
│   └── <Artist Name>
│       └── <Album>
│           └── <Track 1>, <Track 2>, …
├── Albums
│   └── <Album>
│       └── <Tracks>
└── Random
```

When the AA zone is active, what the *car* sees and what the *phone UI*
sees must match — the browse hierarchy is computed from the same
providers the phone library screens use, scoped to offline-safe sources:

1. Add `MediaItem` factory helpers in
   `lib/features/player/services/media_item_mapper.dart` that convert
   JRR `Track`/`AlbumGroup`/`Artist` models to `MediaItem`s, including
   artwork URI.
2. In `JrrAudioHandler.getChildren`, route by `parentMediaId` prefix:
   - `root` → top-level categories
   - `artists` / `artist:<id>` / `album:<id>` → drilled-down library
     (from [LibraryRepository](../lib/features/library/data/repositories/library_repository.dart))
   - `downloads` → from
     [DownloadsRepository](../lib/features/offline/data/repositories/downloads_repository.dart)
   - `recent` → from a new small `RecentlyPlayedRepository` (SharedPrefs
     or sqflite, capped at ~100 items)
3. Implement `playFromMediaId(mediaId)` — translate the ID back to a
   `Track`, build a queue, hand off to the handler's player.
4. Search support — implement `search(query)` and `playFromSearch(query)`
   against the existing library search; this is how Auto routes voice
   commands.

**Library mode for AA when server IS reachable**: the
downloads-only restriction applies to the **car-side** browse tree
(MediaItems sent to the head unit), not to the phone UI when AA is the
active zone. Phone screens keep using `isOfflineActiveProvider` and
browse the live MCWS library normally — the user can pick tracks on the
phone and have them play through the car. Only `getChildren`
(implemented in this phase) is downloads-only for v1, to avoid
token-in-URL artwork rotation pain on cached `MediaItem`s.

## 8. Android Auto manifest & validation

1. Create `android/app/src/main/res/xml/automotive_app_desc.xml`:
   ```xml
   <automotiveApp>
     <uses name="media"/>
   </automotiveApp>
   ```
2. Reference it from `AndroidManifest.xml`:
   ```xml
   <meta-data
     android:name="com.google.android.gms.car.application"
     android:resource="@xml/automotive_app_desc"/>
   ```
3. Declare foreground service permissions:
   - `FOREGROUND_SERVICE`
   - `FOREGROUND_SERVICE_MEDIA_PLAYBACK` (Android 14+)
4. Add the Android Auto launcher icon (`ic_launcher_car.png`) at
   densities mdpi/hdpi/xhdpi/xxhdpi.
5. Validate via `adb shell dumpsys car_service` and the
   [Auto desktop validator](https://developer.android.com/training/cars/testing).

## 9. Auth, connectivity, now-playing, transport, voice

### 9.1 Auth & connectivity

In-car edge cases:

- The phone may have an authenticated session **or** be cold-started in
  the car. Session restore happens via
  [Session._attemptSilentReconnect()](../lib/features/connection/providers/session_provider.dart);
  ensure this completes before `getChildren(root)` returns, otherwise
  the user sees an empty library.
- If the user has only ever logged in via SSL, the saved-server SSL
  trust list (see [ssl_trust.dart](../lib/core/network/ssl_trust.dart))
  must be populated **during** the headless audio service startup —
  not later during widget tree build.
- Network loss: `playFromMediaId` of a streaming track must show a
  clear error to Android Auto (use `playbackState.errorMessage`).
  Downloaded tracks must keep working with no network.
- Offline-first root: if the saved server is unreachable, show
  "Downloads" as the only child of root rather than a confusing empty
  list.

### 9.2 Now Playing metadata & artwork

1. Emit `MediaItem` updates whenever the player advances tracks —
   include `title`, `artist`, `album`, `duration`, `artUri`.
2. Choose artwork URI strategy:
   - **Downloaded tracks**: `file://` URI to the cached artwork.
   - **Streaming tracks**: HTTPS URI to the JRR `File/GetImage` MCWS
     endpoint with the session token. Risk: token is in URL; rotate it
     when the session changes. (Sidestepped in v1 — see §7.)
3. Verify the head unit's small/large artwork sizes (Auto requests
   192x192 and 800x800 typically).

### 9.3 Transport / playback state

`audio_service` wires this up automatically once the handler emits
proper `PlaybackState`. Verify:

- Skip-next / skip-previous in the car.
- Scrubber position updates while playing.
- Pause/resume on transient interruptions (incoming call) —
  `audio_service` handles audio focus.
- Repeat / shuffle controls (if visible on the head unit's UI).

### 9.4 Voice & search polish

- Implement `playFromSearch(query)` for natural-language queries.
- Map common spoken intents:
  - `play <artist>` → search artists, queue all
  - `play album <title>` → search albums
  - `shuffle <artist>` → shuffle on + queue all artist tracks

Test with the real head unit voice button — Auto delivers a transcribed
string plus extras like `EXTRA_MEDIA_ARTIST`.

## 10. Phases & effort

Status legend: 🟢 done · 🟡 in progress · ⚪ pending · ⏸ deferred

| Phase | Scope | Days | Status |
|---|---|---|---|
| 0 — Spike | Stripped-down `audio_service` sample on DHU; one hard-coded MediaItem playing one local file | 1–2 | ⏸ user-side (needs DHU + device) |
| 1 — Zone model | Add `isAndroidAuto`; insert synthetic zone; routing audit (`isVirtualZoneActive` derived providers; refactor existing `isOffline`/`isLocal` guards) | 2 | 🟢 done |
| 2 — `audio_service` migration | `JrrAudioHandler`; collapse vs coexist decision for `LocalPlayerService`; foreground notification config | 3–5 | 🟢 done |
| 3 — UI ↔ handler bridge | `AndroidAutoPlaybackController`; wire `queueProvider` / `playerProvider` to read from handler when AA is active | 2–3 | 🟢 done |
| 4 — Session detection | `androidAutoConnectedProvider`; zone-list refresh on connect/disconnect; fallback for saved-active-zone-AA-but-no-car | 1–2 | ⚪ |
| 5 — Browse hierarchy | `MediaItem` mapping; `getChildren` routing; `playFromMediaId`; `RecentlyPlayedRepository` | 2–3 | ⚪ |
| 6 — Manifest & validation | `automotive_app_desc.xml`; manifest meta-data; permissions; car launcher icon | 1 | ⚪ |
| 7 — Phone-side AA zone screens | Queue / Player show car state; transport controls forward to handler | 1–2 | ⚪ |
| 8 — Voice & search polish | `playFromSearch`; common-intent mappings | 1–2 | ⚪ |
| 9 — QA & store submission | DHU validation checklist; real-car testing (2 cars min); Play Console AA review | 2–3 | ⚪ |
| **Total** | | **16–25 days** | |

### Phase 1 — Completion notes

Changes landed:

- [zone.dart](../lib/features/zones/data/models/zone.dart): added
  `isAndroidAuto` flag (default `false`).
- [zone_repository_impl.dart](../lib/features/zones/data/repositories/zone_repository_impl.dart):
  hoisted `offlineZone` and `localZone` to top-level constants, added
  exported `androidAutoZone` constant, and extended `setActiveZone`
  short-circuit list to include `android-auto`. The AA zone is **not**
  yet returned from `getZones()` — that lands in Phase 4 with session
  detection.
- [active_zone_provider.dart](../lib/features/zones/providers/active_zone_provider.dart):
  added `isAndroidAutoActiveProvider`, `isOfflineLikeActiveProvider`
  (offline + AA, for library guards), and `isVirtualZoneActiveProvider`
  (all three virtual zones). Generalized the previous `wasOffline` refresh
  trigger in `setZone` to cover any serverless virtual zone.
- Routing hardened so the AA zone, if it ever becomes active before
  Phase 3 wiring, never dispatches to MCWS:
  - [player_polling_provider.dart](../lib/features/player/providers/player_polling_provider.dart)
    now uses `isVirtualZoneActiveProvider` (skips polling for AA —
    MCWS player isn't the active transport, and LocalPlayer is
    event-driven).
  - [zone_polling_provider.dart](../lib/features/zones/providers/zone_polling_provider.dart)
    keeps polling for both Local and Android Auto: in both cases the
    phone still has a live MCWS session, and the user must be able to
    pick a real zone from the picker. Only Offline skips polling
    (no server context).
  - [player_provider.dart](../lib/features/player/providers/player_provider.dart)
    routes AA to the local controller (placeholder until Phase 3 swaps
    in the AA handler).
  - [mcws_player_provider.dart](../lib/features/player/providers/mcws_player_provider.dart)
    early-returns for AA in `build`, `refresh`, and `_run`.
  - [queue_provider.dart](../lib/features/queue/providers/queue_provider.dart)
    returns empty queue for AA and turns mutating methods (`removeItem`,
    `moveItem`, `clearQueue`) into no-ops with `Phase 3` TODO markers.
- `isOfflineLikeActiveProvider` is **defined but not yet used** —
  reserved for Phase 5 to scope the *car-side* `getChildren` browse
  tree to downloads-only. Phone-side library widgets continue to use
  `isOfflineActiveProvider` (Offline only), so when the AA zone is
  active on the phone, the user can still browse the live MCWS library
  normally. The token-rotation concern that motivated downloads-only
  applies to `MediaItem`s cached on the head unit, not to the phone UI
  itself.

Verification: `flutter analyze` clean, all 38 existing tests pass,
`dart format` applied.

Deferred / not done in Phase 1:

- AA zone is intentionally invisible (no session detection yet — Phase 4).
- `local_player_provider` still early-returns for AA via its existing
  `isLocal || isOffline` guards; Phase 3 will replace this with the
  handler bridge.

### Phase 2 — Completion notes

Decisions (confirmed with user):
- **Collapse, not coexist.** `LocalPlayerService` itself now extends
  `BaseAudioHandler with SeekHandler` and is the single owner of the
  `just_audio` `AudioPlayer`. No second handler class introduced —
  keeps the diff small and consumers untouched.
- **Package version:** `audio_service: ^0.18.18` (latest stable).

Changes landed:

- [pubspec.yaml](../pubspec.yaml): added `audio_service: ^0.18.18`
  (and its transitive `rxdart` dependency).
- [local_player_service.dart](../lib/features/player/services/local_player_service.dart):
  class now extends `BaseAudioHandler with SeekHandler`. Existing public
  surface (state getters, just_audio streams, `setTracks`, `playNow`,
  `seekTo`, `setShuffle`, `setRepeat`, etc.) is preserved so all
  consumers in [local_player_provider.dart](../lib/features/player/providers/local_player_provider.dart)
  keep working unchanged. Added:
  - `audio_service` transport overrides: `play`, `pause`, `stop`,
    `seek`, `skipToNext`, `skipToPrevious`, `setShuffleMode`,
    `setRepeatMode`. These route to the underlying `_player` and are
    invoked from the system notification, lock screen, and (Phase 3+)
    Android Auto head unit.
  - Stream forwarding from `just_audio` to `audio_service`: a
    `_bindPlayerToAudioServiceStreams()` binder fires on construction,
    listens to `playbackEventStream` and `sequenceStateStream`, and
    pushes `PlaybackState` / `MediaItem` / `queue` updates to the
    audio_service `BehaviorSubject`s.
  - `_mapPlaybackState`: just_audio `PlaybackEvent` →
    audio_service `PlaybackState` (controls, system actions, processing
    state, position, buffered position, speed, queue index).
  - `_toMediaItem`: `Track` → `MediaItem` (id from `fileKey`, title /
    artist / album / duration). Artwork URI not wired yet — Phase 5.
- [main.dart](../lib/main.dart): now calls `AudioService.init(builder,
  config)` before `runApp`, constructs the `AudioPlayer` and
  `LocalPlayerService` there, and registers both into `getIt`. Notification
  channel ID `com.jriver.remote.audio`, ongoing notification, foreground
  stops on pause.
- [injection.dart](../lib/core/di/injection.dart): removed direct
  `AudioPlayer()` / `LocalPlayerService` construction (moved to
  `main.dart`); imports cleaned up.
- [AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml):
  added `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_MEDIA_PLAYBACK`, and
  `WAKE_LOCK` permissions (the last is **required** — audio_service
  acquires a `PARTIAL_WAKE_LOCK` inside `enterPlayingState` between
  `startForegroundService` and `startForeground`; without it,
  `SecurityException` aborts the method and the system ANRs the
  foreground service it was asked to start); added `<service>` for
  `com.ryanheise.audioservice.AudioService`
  (`foregroundServiceType="mediaPlayback"`, intent filter
  `android.media.browse.MediaBrowserService`) and `<receiver>` for
  `com.ryanheise.audioservice.MediaButtonReceiver` (intent filter
  `android.intent.action.MEDIA_BUTTON`). Added `xmlns:tools` so the
  required `tools:ignore="Instantiatable"` attribute parses. Full
  Phase 6 manifest work (`automotive_app_desc.xml`, car launcher icon,
  AA meta-data) still pending.
- [MainActivity.kt](../android/app/src/main/kotlin/com/jrr/jrr_f/MainActivity.kt):
  now extends `com.ryanheise.audioservice.AudioServiceActivity`
  instead of `FlutterActivity`. Required by `audio_service` so its
  MethodChannel can find the correct `FlutterEngine`; without this
  `AudioService.init` throws a `PlatformException` at startup.
- [ic_audio_service_notification.xml](../android/app/src/main/res/drawable/ic_audio_service_notification.xml):
  added a monochrome vector drawable as the notification icon.
  Android requires notification icons to be alpha-masks (the system
  tints them); the default `mipmap/ic_launcher` is a multicolor PNG
  that silently crashes the foreground service on some devices when
  the first notification is posted, ending up as "Lost connection to
  device" with no Dart-visible error.
- [main.dart](../lib/main.dart) `AudioServiceConfig`:
  - `androidNotificationIcon: 'drawable/ic_audio_service_notification'`
    points at the new drawable.
  - `androidStopForegroundOnPause` removed (was `true`). In
    `audio_service ^0.18.x` on Android 12+ this triggers a native
    crash when the foreground service tries to detach while
    `FOREGROUND_SERVICE_MEDIA_PLAYBACK` is the only justification for
    being foreground. Safer default is to leave the service in the
    foreground while paused; we can revisit once the rest of the
    pipeline is stable.

Known not-yet-Phase-2 issues observed during runtime testing:

- Riverpod state-change log storm: every 200ms position tick fires
  `localPlayerPositionProvider` →
  `localPlayerProvider` → `playerProvider` → `queueProvider`
  through AsyncLoading→AsyncData transitions, and
  [TalkerRiverpodObserver](../lib/main.dart) dumps the full Tracks
  list each time. Pre-existing; not blocking Phase 2 but worth a
  cleanup pass before Phase 3 since it amplifies any I/O pressure
  from `audio_service`'s notification updates. Either drop the
  observer from the production `ProviderScope` or trim its included
  providers list.
- [Info.plist](../ios/Runner/Info.plist): added `UIBackgroundModes`
  with `audio` so iOS playback continues when the app is backgrounded.

Verification: `flutter analyze` clean, all 38 tests pass, `dart format`
applied.

Runtime verification (requires a device, **user-side**):
- Confirm Local-zone playback works as before.
- Confirm a system media notification appears with title/artist/album
  and play/pause/skip controls.
- Lock-screen controls forward to the handler.
- (iOS) Backgrounding the app continues playback.
- (Android) `adb shell dumpsys media_session` lists the JRR session.

### Phase 3 — Completion notes

Because Phase 2 **collapsed** `LocalPlayerService` into the single
`BaseAudioHandler`, the planned separate `JrrAudioHandler` +
`AndroidAutoPlaybackController` pair from §5.1 is **not needed**. There is
one handler, one `AudioPlayer`. Phase 3 reduces to: route the AA zone
through the existing local handler with its own persisted queue, and
remove the Phase 1 placeholder early-returns.

Changes landed:

- [local_player_provider.dart](../lib/features/player/providers/local_player_provider.dart):
  - `build()` zone-id resolution now maps `isAndroidAuto` to a third
    persisted-queue id `'android-auto'`. The existing per-zone
    SharedPreferences keys (`local_player_<zone>_index`,
    `local_player_<zone>_position_ms`) and `LocalQueueRepository` keys
    automatically give AA its own queue / index / position state,
    independent of Local and Offline.
  - The `localPlaybackStateProvider` listener and the initial
    `_calculateStatus` snapshot now treat AA the same as Local/Offline,
    so `playerProvider` receives `PlayerStatus` updates when the AA
    zone is active.
- [queue_provider.dart](../lib/features/queue/providers/queue_provider.dart):
  - Removed the AA early-return in `build()` and the three AA
    `Phase 3: wire to AA handler` no-ops on `removeItem` / `moveItem`
    / `clearQueue`. AA now falls through to the local-zone branch and
    operates on the same handler.
- [player_provider.dart](../lib/features/player/providers/player_provider.dart):
  - Updated the `_controllerFor` comment to reflect that Local/Offline/AA
    all share the single audio_service-backed handler — Phase 3
    placeholder language removed. The actual dispatch was already
    correct from Phase 1's hardening pass.

Not needed (vs the original plan):

- **No `AndroidAutoPlaybackController` class.** Subsumed by the
  collapsed handler. The handler streams already feed the
  `localPlayer*Provider` family, which the unified `playerProvider`
  and `queueProvider` read from when AA is the active zone.
- **No queue-state divergence between car and phone.** With one
  handler, "what the car sees" and "what the phone sees while AA is
  the active zone" are the same `MediaItem` / `queue` /
  `PlaybackState` streams. No additional bridge required.

Implication for later phases:

- Phase 4 (session detection) — when AA binds and the car-side
  `getChildren` callback fires, the existing handler can be left
  alone; we only need to surface the AA zone in `getZones()` and let
  the user pick it (or auto-pick it on connect, TBD §12).
- Phase 5 (`playFromMediaId`) — wires directly to
  `LocalPlayerService.playNow` (or a thin AA-flavoured variant that
  also sets the active zone). No new player object is introduced.
- The "two-player coexistence" risk in §11 is **resolved by the Phase
  2 collapse decision** — there is one player. AA and Local can't
  fight each other; switching the active zone simply swaps which
  persisted queue is loaded.

Deferred / not done in Phase 3:

- AA zone is still invisible (no session detection — Phase 4).
- The AA zone's queue is empty until `playFromMediaId` lands in
  Phase 5; manually switching to the AA zone from the picker (once
  Phase 4 surfaces it) will show an empty queue, which is correct.
- The `localPlayerProvider` quality-change / downloads-change reload
  listeners (L265–332) fire regardless of active zone. That's fine
  for v1 — AA's queue is downloads-only per §7 so the streaming-URL
  swap path is a no-op for AA tracks, and quality changes are still
  user-driven from the same settings screen. Revisit only if we
  expose quality settings inside the car-side UI.

Verification: `flutter analyze` clean, all 38 tests pass, `dart format`
applied.

For a single engineer, plan on **4–5 calendar weeks** including review,
DHU iteration, and one round of Play Console feedback.

## 11. Risks and unknowns

- **`audio_service` migration scope**: replacing direct `AudioPlayer`
  usage may surface state-sync bugs in
  [LocalPlayer](../lib/features/player/providers/local_player_provider.dart)
  that were hidden by the current single-instance setup. Budget time
  for flake.
- **Background isolate**: `audio_service` runs the handler in a
  separate isolate on Android (depending on config). Anything in the
  handler must not touch widget-tree-only state. Riverpod providers
  used in the handler must be created inside the audio isolate's
  container, not the UI one. Common foot-gun.
- **Token-in-URL artwork**: if the auth token rotates while a
  `MediaItem` is cached on the head unit, artwork will 401. Mitigation
  (when we enable live MCWS browsing post-v1): include the current
  token at emission time and re-emit `MediaItem` on session refresh.
- **MCWS over HTTPS in-car**: SSL trust hosts must be re-applied in
  the audio isolate, since `JRiverHttpOverrides` is process-global but
  not isolate-shared in some Flutter versions.
- **Battery / data**: in-car streaming over phone LTE while the user
  drives away from their LAN — current code assumes LAN-only. The
  v1 downloads-only AA library sidesteps this; v2 needs graceful
  "server unreachable" detection (we already partially handle this
  with the offline zone).
- **Two-player coexistence (if we don't collapse in Phase 2)**:
  `audio_service` traditionally assumes a single `AudioHandler`. We
  will *not* run two simultaneously — the handler is the only player
  in the collapsed design. If we coexist, the active zone gates which
  player accepts commands; race conditions on zone switch are the
  risk.

## 12. Open questions

- **Saved-active-zone = AA, but no car connected at startup**: silent
  fallback to the previous zone with a snackbar (recommended) vs a
  "Connect to Android Auto" placeholder screen.
- **Auto disconnects mid-playback**: handler is still alive — auto-
  switch the active zone to Local and continue on the phone, or stop?
  Recommend stop (matches today's behaviour when a remote zone
  disappears).
- **Library mode for AA when server IS reachable**: downloads-only
  for v1 (recommended) vs live MCWS browse with token-rotation
  handling.
- **Collapse `LocalPlayerService` into the handler in Phase 2** vs
  keep both and gate by active zone. Decide before Phase 2 starts.

## 13. Out of scope (future)

- **Remote zone playback over Android Auto**: streaming a remote MCWS
  zone (e.g. an amp at home) to the car. Possible but requires a
  separate "play to phone" mode in MCWS, or a phone-side proxy that
  pulls audio from the server and re-streams to the car. Big work.
- **Android Automotive (AAOS)**: cars with built-in Google Auto OS
  (no phone). Different product — separate manifest, no phone app
  context, different review track. Reuses ~80% of the work above but
  with extra packaging and entitlements.
- **CarPlay (iOS)**: parallel iOS effort. Shares the conceptual model
  (browse hierarchy + playback) but uses entirely different APIs
  (`MPPlayableContentManager` / `CPNowPlayingTemplate`). Plan
  separately.
