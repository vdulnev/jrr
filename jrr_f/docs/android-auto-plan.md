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
5. Behave correctly across drive-time transitions (network loss, screen lock,
   call interruption).

The existing remote-control mode (sending MCWS commands to a server playing
on a different zone) is **out of scope** for v1 — Android Auto playback
requires the audio to come from the phone, so we'll only support the
**Local zone** + **Offline zone** initially.

## 2. Why this is a substantial effort

Flutter has no first-class Android Auto support. Android Auto integrates
with the platform via a Java/Kotlin `MediaBrowserServiceCompat` (or
`MediaLibraryService` on Media3). The Flutter widget tree never runs in the
car — only the metadata exposed via that service is shown. So we cannot
"port the UI" to Auto; we must build a parallel browse hierarchy on the
native side and bridge to Flutter for playback state.

Two practical paths:

- **Path A — adopt `audio_service`**: replace just_audio with
  `audio_service` (which embeds just_audio under the hood). It provides a
  ready-made `AudioServiceBackgroundTask`/`AudioHandler` that already
  exposes a MediaBrowserService and integrates with Android Auto.
  Recommended.
- **Path B — write our own `MediaBrowserService`** in Kotlin and
  communicate with Flutter over MethodChannel/EventChannel.
  More control, far more code, error-prone synchronization.

This plan assumes Path A.

## 3. Phases

### Phase 0 — Research & spike (1–2 days)

- Run the official `audio_service` example app on a phone with Android Auto
  installed; confirm it appears in the car launcher (use the Desktop Head
  Unit emulator — DHU).
- Verify just_audio compatibility with `audio_service` 0.18+ (current API).
- Confirm we can set custom MediaItem `extras` for things like bitrate /
  sample-rate badges if we want them.
- Document any Android 14/15 background-execution restrictions that affect
  the foreground service.

**Exit criteria**: a stripped-down sample running on DHU showing one
hard-coded MediaItem and playing one local file.

### Phase 1 — Refactor playback to `audio_service` (3–5 days)

This is the bulk of the work and must not regress the existing in-app UX.

1. Add `audio_service: ^0.18.x` to [pubspec.yaml](../pubspec.yaml).
2. Create `lib/features/player/services/jrr_audio_handler.dart` — an
   `AudioHandler` that:
   - Wraps the existing `LocalPlayerService` `AudioPlayer`.
   - Forwards `playbackState`, `mediaItem`, and `queue` streams from
     just_audio events.
   - Implements `play`, `pause`, `stop`, `skipToNext`, `skipToPrevious`,
     `seek`, `setShuffleMode`, `setRepeatMode`, `playFromMediaId`,
     `customAction` (used by Android Auto for transport controls).
3. Boot the handler in [injection.dart](../lib/core/di/injection.dart) via
   `AudioService.init(builder: () => JrrAudioHandler(...), config: ...)`
   instead of constructing `AudioPlayer` directly.
4. Update [local_player_service.dart](../lib/features/player/services/local_player_service.dart)
   to use the handler's player rather than its own — or fold its public
   API into the handler if we'd rather collapse the layers.
5. Keep [LocalPlayer riverpod provider](../lib/features/player/providers/local_player_provider.dart)
   unchanged from the consumer side; it now reads streams from
   `AudioService` instead of just_audio directly.
6. Update [main.dart](../lib/main.dart) — `audio_service` requires
   initialization before `runApp`.
7. Configure the foreground notification (channel ID, icon, action layout)
   in `AudioServiceConfig`.
8. Sanity check on phone: lock screen, notification controls, and app UI
   all still work.

**Exit criteria**: existing Local-zone playback works exactly as today,
plus the system media notification (lock screen + pull-down) appears with
the JRR controls.

### Phase 2 — Browse hierarchy (2–3 days)

`audio_service` calls `getChildren(parentMediaId)` whenever Android Auto
requests a folder. Implement this to expose:

```
ROOT
├── Recent
├── Downloads (offline-only)
├── Artists
│   └── <Artist Name>
│       └── <Album>
│           └── <Track 1>, <Track 2>, …
├── Albums
│   └── <Album>
│       └── <Tracks>
└── Random
```

Tasks:

1. Add `MediaItem` factory helpers in `lib/features/player/services/media_item_mapper.dart`
   that convert JRR `Track`/`AlbumGroup`/`Artist` models to `MediaItem`s,
   including artwork URI (use the MCWS artwork endpoint with the active
   session token, or local-file URI for downloaded tracks).
2. In `JrrAudioHandler.getChildren`, route by `parentMediaId` prefix:
   - `root` → top-level categories
   - `artists` → list of artists from the existing
     [LibraryRepository](../lib/features/library/data/repositories/library_repository.dart)
   - `artist:<id>` → that artist's albums
   - `album:<id>` → tracks
   - `downloads` → from
     [DownloadsRepository](../lib/features/offline/data/repositories/downloads_repository.dart)
   - `recent` → recently played (need to add a "recent" persistence layer
     if we don't have one — or pull from MCWS Files/Search by date).
3. Implement `playFromMediaId(mediaId)` — translate the ID back to a
   `Track`, build a queue, hand off to `LocalPlayer`.
4. Search support — implement `search(query)` to query the existing
   library search and return `MediaItem`s. Android Auto routes voice
   commands through this.

**Exit criteria**: opening JRR in DHU shows the full browse tree, tapping
a track plays it, voice "play artist X" works.

### Phase 3 — Android Auto manifest & validation (1–2 days)

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
3. Declare the foreground service permissions:
   - `FOREGROUND_SERVICE`
   - `FOREGROUND_SERVICE_MEDIA_PLAYBACK` (Android 14+)
4. Add the Android Auto launcher icon (`ic_launcher_car.png`) at densities
   mdpi/hdpi/xhdpi/xxhdpi.
5. Validate via `adb shell dumpsys car_service` and the Auto desktop
   validator (`https://developer.android.com/training/cars/testing`).

### Phase 4 — Auth & connectivity (2–3 days)

In-car edge cases that matter:

- The phone may have an authenticated session **or** be cold-started in the
  car. Currently a session restore happens via
  [Session._attemptSilentReconnect()](../lib/features/connection/providers/session_provider.dart);
  ensure this completes before `getChildren(root)` returns, otherwise the
  user sees an empty library.
- If the user has only ever logged in via SSL, the saved-server SSL trust
  list (see [ssl_trust.dart](../lib/core/network/ssl_trust.dart)) must be
  populated **during** the headless audio service startup — not later
  during widget tree build.
- Network loss: `playFromMediaId` of a streaming track must show a clear
  error to Android Auto (use `playbackState.errorMessage`). Downloaded
  tracks must keep working with no network.
- Implement an **offline-first** root: if the saved server is unreachable,
  show "Downloads" as the only child of root rather than a confusing empty
  list.

### Phase 5 — Now Playing metadata & artwork (1 day)

1. Emit `MediaItem` updates whenever the local player advances tracks —
   include `title`, `artist`, `album`, `duration`, `artUri`.
2. Choose artwork URI strategy:
   - **Downloaded tracks**: `file://` URI to the cached artwork.
   - **Streaming tracks**: HTTPS URI to the JRR `File/GetImage` MCWS
     endpoint with the session token. Risk: token is in URL; rotate it
     when the session changes.
3. Verify the head unit's small/large artwork sizes (Auto requests
   192x192 and 800x800 typically).

### Phase 6 — Transport / playback state (0.5 days)

The `audio_service` library wires this up automatically once the handler
emits proper `PlaybackState`. Verify:

- Skip-next / skip-previous in the car
- Scrubber position updates while playing
- Pause/resume on transient interruptions (incoming call) — `audio_service`
  handles audio focus
- Repeat / shuffle controls (if visible on the head unit's UI)

### Phase 7 — Voice & search polish (1–2 days)

- Implement `playFromSearch(query)` for natural-language queries.
- Map common spoken intents:
  - "play <artist>" → search artists, queue all
  - "play album <title>" → search albums
  - "shuffle <artist>" → shuffle on + queue all artist tracks

Test with the actual head unit voice button — Auto delivers a transcribed
string plus extras like `EXTRA_MEDIA_ARTIST`.

### Phase 8 — QA & store submission (2–3 days)

1. Run **all** items on Android Auto's
   [DHU validation checklist](https://developer.android.com/training/cars/testing#validation):
   - "Drive distraction" rules (no excessive UI updates while driving)
   - Browseable item counts (Auto truncates after a limit)
   - Loading states (spinners are fine, but mustn't last >10s)
2. Real-car testing: at least 2 cars (one wired, one wireless), one ride
   from cold-start to several hour drive.
3. Submit to Play Console and request the **Android Auto** review track —
   Google reviews this separately from the regular store listing and can
   reject for distraction violations.

## 4. Risks and unknowns

- **`audio_service` migration scope**: replacing `AudioPlayer` direct
  usage may surface state-sync bugs in
  [LocalPlayer](../lib/features/player/providers/local_player_provider.dart)
  that were hidden by the current single-instance setup. Budget time for
  flake.
- **Background isolate**: `audio_service` runs the handler in a separate
  isolate on Android (depending on config). Anything in the handler must
  not touch widget-tree-only state. Riverpod providers used in the
  handler must be created inside the audio isolate's container, not the UI
  one. This is a common foot-gun.
- **Token-in-URL artwork**: if the auth token rotates while a `MediaItem`
  is cached on the head unit, artwork will 401. Mitigation: include the
  current token at emission time and re-emit `MediaItem` on session
  refresh.
- **MCWS over HTTPS in-car**: SSL trust hosts must be re-applied in the
  audio isolate, since `JRiverHttpOverrides` is process-global but not
  isolate-shared in some Flutter versions.
- **Battery / data**: in-car streaming over phone LTE while the user
  drives away from their LAN — current code assumes LAN-only. Need to
  detect "server unreachable" gracefully (we already partially handle
  this with the offline zone).

## 5. Estimated effort

| Phase | Days |
|---|---|
| 0 — Spike | 1–2 |
| 1 — `audio_service` migration | 3–5 |
| 2 — Browse hierarchy | 2–3 |
| 3 — Manifest & validation | 1–2 |
| 4 — Auth & connectivity | 2–3 |
| 5 — Now Playing metadata | 1 |
| 6 — Transport state | 0.5 |
| 7 — Voice & search | 1–2 |
| 8 — QA & submission | 2–3 |
| **Total** | **13–21 days** |

For a single engineer, plan on **3–4 calendar weeks** including review,
DHU iteration, and one round of Play Console feedback.

## 6. Out-of-scope (future)

- **Remote zone playback over Android Auto**: streaming a remote MCWS
  zone (e.g. an amp at home) to the car. Possible but requires a
  separate "play to phone" mode in MCWS, or a phone-side proxy that
  pulls audio from the server and re-streams to the car. Big work.
- **Android Automotive (AAOS)**: cars with built-in Google Auto OS (no
  phone). This is a different product — separate manifest, no phone
  app context, different review track. Reuses ~80% of the work above
  but with extra packaging and entitlements.
- **CarPlay (iOS)**: parallel iOS effort. Shares the conceptual model
  (browse hierarchy + playback) but uses entirely different APIs
  (`MPPlayableContentManager`/`CPNowPlayingTemplate`). Plan separately.
