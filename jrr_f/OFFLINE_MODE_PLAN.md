# Offline Mode — Implementation Plan

A new feature in `jrr_f` that lets a user download tracks for fully
offline listening. When offline mode is active, the app performs
**no network I/O**: library browsing, queue, artwork, and playback
all run from local files.

This document is the implementation plan only — no code changes yet.

---

## 1. Goals

- Download any track (or whole album / folder / browse-leaf set) for
  offline use.
- Encode downloads as **FLAC** (lossless, compressed) via MCWS
  `File/GetFile?Conversion=wav`.
- **Offline mode is a zone**, not a separate setting. The zone list
  exposes a virtual **Offline** zone alongside **Local** and the
  remote zones. Selecting it activates offline behavior; selecting
  any other zone deactivates it. There is no offline-mode checkbox.
- While the Offline zone is active the app does **no network I/O**:
  no MCWS calls, no artwork fetches, no token checks, no polling.
- Manage downloads: delete a track, delete an album, clear everything.
- At download time, persist full track metadata so we never need MCWS
  to render the offline UI.
- Multi-disc albums supported end-to-end.
- Offline browse hierarchy:
  **Album Artist → "Year — Album" → Tracks**
  (with disc grouping for multi-disc albums).

## 2. Non-Goals (this phase)

- Background downloads while the app is killed (Android `WorkManager`,
  iOS `BGProcessingTask`).
- Resumable / chunked downloads. Failed downloads restart from zero.
- Cross-device sync of the downloaded set.
- Selective bitrate/format choice (FLAC is the only target).
- Smart eviction / cache size limits. The user manages disk usage
  manually.
- Auto-download (e.g. "favorite an album → download it").

These are reasonable v2 follow-ups; the plan keeps the door open for
each but does not implement them.

## 3. User Stories

1. From a track row, album row, folder row, or browse-leaf, the user
   taps "Download". The track(s) move into a "Queued" → "Downloading"
   → "Downloaded" state. Progress is visible.
2. The user can cancel a queued or in-progress download.
3. The user can delete one downloaded track, one downloaded album,
   or clear all downloads.
4. The user opens the **Downloads** sub-tab inside Library. They see
   a list of album artists. Tapping one shows that artist's
   downloaded albums (sorted year-descending), with `Year — Album`
   labels. Tapping an album shows its tracks (multi-disc grouped).
5. The user opens the Zones tab and taps **Offline**. The app
   immediately stops all network activity and begins behaving as an
   offline player. Library tabs other than Downloads are disabled;
   the Queue tab is hidden; the only player is the local just_audio
   player streaming `file://` URIs.
6. The user taps any other zone (Local or a remote zone) to leave
   offline mode. Network activity resumes.
7. Downloaded tracks are also preferred over the network when the
   **Local** zone is active (online): if a track has been downloaded,
   it plays from disk regardless of the active zone choice. Saves
   bandwidth and works the way users expect.

## 4. MCWS Notes

- `File/GetFile?File=<key>&FileType=Key&Playback=0&Conversion=wav`
  returns a streaming FLAC body. `Playback=0` so the download does
  not bump play counts or change "last played" timestamps on the
  server.
- `File/GetImage?File=<key>&Format=jpg&Width=512&Height=512` provides
  the artwork. We persist one image per album (keyed on album group
  id), not per track.
- Both endpoints append the auth token. The token must be present
  when the **download** is initiated; once the file is on disk, no
  further network is needed.

## 5. Storage Layout

```
{appDocs}/
  downloads/
    tracks/
      {fileKey}.flac          # one file per downloaded track
    artwork/
      {albumGroupId}.jpg      # one image per album group
    .tmp/
      {fileKey}.part          # in-progress download; renamed atomically
```

`appDocs` resolved via `path_provider` (`getApplicationDocumentsDirectory()`).
Atomic rename from `.tmp/{key}.part` → `tracks/{key}.flac` on
completion guarantees no half-files survive a crash.

Album group id: stable hash of `albumArtist|album|parentFolderPath`
(matches `AlbumGroup.id` in the existing library code).

## 6. Drift Schema (v5)

Two new tables.

### `downloaded_tracks`

| Column | Type | Notes |
|---|---|---|
| `id` | int PK auto | |
| `file_key` | int | unique; file_key from MCWS Track |
| `track_json` | text | full serialized `Track` (forward-compatible) |
| `local_path` | text | absolute path to FLAC file |
| `artwork_path` | text nullable | absolute path to album artwork JPG |
| `album_group_id` | text | for grouping multi-disc tracks under one album |
| `album_artist` | text | denormalized for fast index |
| `album` | text | denormalized |
| `date_readable` | text | denormalized; rendered as `Year — Album` |
| `disc_number` | int | for sort + grouping |
| `total_discs` | int | |
| `track_number` | int | for sort |
| `file_size_bytes` | int | for storage UI |
| `downloaded_at` | int | unix ms |

Indexes: `file_key` (unique), `album_group_id`, `album_artist`.

### `download_jobs`

Tracks the queue and lifecycle of in-progress downloads. Persisted so
that the queue survives app restarts.

| Column | Type | Notes |
|---|---|---|
| `id` | int PK auto | |
| `file_key` | int | unique |
| `track_json` | text | full Track at queue time |
| `state` | text | `queued`, `running`, `failed`, `cancelled` |
| `error` | text nullable | last error message |
| `bytes_done` | int | |
| `bytes_total` | int | -1 if unknown |
| `enqueued_at` | int | unix ms |
| `started_at` | int nullable | |

Successful downloads are removed from `download_jobs` and inserted
into `downloaded_tracks`. Failed/cancelled jobs stay so the user can
see history; a separate "Clear failed" action removes them.

### Migration v4 → v5

- Create `downloaded_tracks`.
- Create `download_jobs`.

No backfill needed — first-run migration only.

## 7. New Dependencies

| Package | Why |
|---|---|
| `path_provider: ^2` | resolve app documents directory |
| `crypto: ^3` | stable hash for `albumGroupId` and tmp filenames |
| `connectivity_plus: ^6` | drive auto-offline UX (optional, see §13) |

`dio` (already a dependency) handles streaming HTTP downloads via
`Dio.download()` / `ResponseType.stream`.

## 8. Architecture

### 8.1 Layering

```
features/offline/
  data/
    models/
      download_job.dart          # Freezed: file_key, state, progress
      downloaded_track.dart      # Freezed view over the Drift row
      download_state.dart        # enum: queued, running, downloaded,
                                 #       failed, cancelled, notDownloaded
    repositories/
      downloads_repository.dart           # interface
      downloads_repository_impl.dart      # Drift + filesystem
  services/
    download_service.dart        # serial worker: pulls queue, runs Dio
                                 # download, writes file, updates Drift
  providers/
    download_jobs_provider.dart  # AsyncNotifier<List<DownloadJob>>
    downloaded_tracks_provider.dart # AsyncNotifier<List<DownloadedTrack>>
    downloaded_artists_provider.dart  # derived: List<String>
    downloaded_albums_provider.dart   # derived: List<DownloadedAlbumGroup>
    is_offline_active_provider.dart   # derived: activeZone?.isOffline == true
    download_status_provider.dart # family<int /*fileKey*/, DownloadState>
  widgets/
    downloads_tab.dart                 # new sub-tab inside Library
    downloaded_artists_screen.dart     # level 1
    downloaded_albums_screen.dart      # level 2 (per artist)
    downloaded_album_detail_screen.dart # level 3 (multi-disc grouped)
    download_progress_indicator.dart   # small inline indicator
    storage_usage_panel.dart           # for Settings
```

### 8.2 Get_it registrations (base scope)

- `DownloadsRepository`
- `DownloadService` (singleton; owns the run loop)

`DownloadService.start()` is called once during `configureDependencies()`.
The service stays alive for the app lifetime and reads/writes Drift
directly. It does not depend on `McwsClient` from the session scope —
it builds its own `Dio` per download (with the `AuthInterceptor`
short-circuit logic inlined) so downloads can complete after a logout
if they were enqueued before. Alternatively, downloads pause on
logout and resume after re-auth — see §13.

### 8.3 Download flow

1. UI calls `DownloadsRepository.enqueue(Track)` (or `enqueueAll(Tracks)`).
2. Repo writes a `download_jobs` row with `state=queued`.
3. `DownloadService` is signaled (Stream / completer); it pulls the
   next `queued` job, marks `state=running`, and starts a Dio
   download.
4. On bytes received, the service updates `bytes_done` (throttled to
   ~5/sec to avoid Drift write storms).
5. On success:
   - Move tmp → final path.
   - Fetch artwork once per `albumGroupId` if not already on disk.
   - Insert `downloaded_tracks` row.
   - Delete the `download_jobs` row.
6. On failure: `state=failed`, `error=<msg>`, leave `.part` in place
   (cleaned on next start).
7. The service then loops to the next queued job.

Downloads are **serial** for the first cut. Multiple parallel
downloads are an obvious follow-up but introduce concurrency bugs
(disk pressure, rate limiting, DB write contention) that aren't
worth fighting in v1.

### 8.4 Cancellation

`DownloadService.cancel(fileKey)`:
- If the job is `queued`, mark `state=cancelled`.
- If `running`, call `CancelToken.cancel()`, mark `state=cancelled`,
  delete the `.part` file.

### 8.5 Deletion

`DownloadsRepository.delete(fileKey)`:
- Remove the FLAC file.
- Delete the `downloaded_tracks` row.
- If the deletion was the last track of an album group, also remove
  the artwork file and the empty entry from derived providers.

`DownloadsRepository.clearAll()`:
- Cancel all in-flight jobs.
- `rm -rf` the `downloads/` directory.
- Truncate both Drift tables.

## 9. UI Plan

### 9.1 Triggers

Add a **Download** entry to the existing kebab `PopupMenuButton<String>`
on:

- `LibraryItemTile` (single track)
- `AlbumRowTile` (whole album: enqueues all tracks of the album,
  including all discs of a multi-disc album)
- `TrackListScaffold._TracksPopupMenu` (bulk: download all visible
  tracks)
- `BrowseFilesView` group menus (artist group / album group)
- `FolderTracksScreen` (whole folder)

The menu item shows current state when applicable:

| Track state | Menu label |
|---|---|
| `notDownloaded` | "Download" |
| `queued` / `running` | "Cancel download" |
| `downloaded` | "Delete download" |
| `failed` | "Retry download" |

### 9.2 Inline progress

`DownloadProgressIndicator` — a compact widget shown next to the
kebab on a track row when the track is `queued` or `running`. Reads
`downloadStatusProvider(fileKey)`. Hidden in the `downloaded` and
`notDownloaded` states.

### 9.3 Downloads sub-tab in Library

Add a fifth Library tab: `Artists / Random / Browse / Favorites / Downloads`.

The tab uses the same `AutoTabsRouter` pattern as the others, with a
nested router stack:

```
DownloadsTabRouterRoute
  ├─ DownloadedArtistsRoute (initial)
  ├─ DownloadedAlbumsRoute (per artist)
  └─ DownloadedAlbumDetailRoute (per album group)
```

**Level 1 — `DownloadedArtistsScreen`**

- `ListView` of distinct `album_artist` values from `downloaded_tracks`.
- Sorted alphabetically (case-insensitive).
- Tap → push `DownloadedAlbumsRoute(artist: …)`.

**Level 2 — `DownloadedAlbumsScreen`**

- Reuses `AlbumListView` with `AlbumRowTile`.
- Each row: `albumArtist · Year — Album` (year extracted from
  `dateReadable`, falling back to album-only when missing).
- Sorted year-descending, then album name ascending.
- Tap → push `DownloadedAlbumDetailRoute(albumGroupId: …)`.

**Level 3 — `DownloadedAlbumDetailScreen`**

- Built on `TrackListScaffold` so it gets the standard header,
  multi-disc grouping (`MultiDiscList`), and kebab popup wiring for
  free.
- Header subtitle: `albumArtist · Year`.
- Track tiles: identical to library track tiles but with no
  network-dependent menu items (Play next / Add to playing now still
  work — they enqueue the local-zone player using the file:// URI).

### 9.4 Zones tab — the Offline zone

`ZoneRepositoryImpl.getZones()` already appends a synthetic Local zone.
It also appends a second synthetic **Offline** zone:

```dart
const Zone(
  id: 'offline',
  name: 'Offline',
  guid: 'offline-zone-guid',
  isDLNA: false,
  isLocal: false,
  isOffline: true,
);
```

`Zone` gains an `isOffline` flag (Freezed, defaults to `false`).
`isLocal` and `isOffline` are mutually exclusive in practice but the
flags stay independent for clarity.

The zone tile renders with its own icon (`Icons.cloud_off_rounded` or
similar) and an `OFFLINE` mono label. No quality popup (downloads are
already FLAC; there's no streaming to switch quality on).

### 9.5 Settings

`ServerManagerScreen` (the Settings tab) gains:

- **Storage Usage** panel — total downloaded size, count of tracks
  and albums.
- **Clear all downloads** destructive button (with a confirm dialog).
- **Manage failed downloads** — list with per-row Retry / Remove
  (Phase F).

No offline-mode switch — that lives in the Zones tab.

## 10. Offline Behavior (Offline zone active)

Offline mode is purely derived from the active zone:

```dart
final isOfflineActive = ref.watch(
  activeZoneProvider.select((z) => z?.isOffline == true),
);
```

There is no persisted offline-mode flag. The active zone GUID is
already persisted in `shared_preferences` (`active_zone_guid`), so
selecting Offline once is remembered across launches.

While the Offline zone is active:

- `PlayerPolling` and `ZonePolling` early-return — they already gate
  on `activeZone?.isLocal`; the gate becomes "is local *or* offline".
- The library tabs (Artists / Random / Browse / Favorites) are
  disabled with a tooltip "Offline — only downloaded tracks are
  available". Only **Downloads** is enabled. The Queue tab is hidden
  (server-side state, unreachable).
- Now Playing draws entirely from the local just_audio player
  sequence — same code path as the Local zone.
- The local player only resolves `file://` sources. It will refuse to
  enqueue a track that is not downloaded (the action menus already
  show "Download" instead of "Play" / "Play next" / "Add to playing
  now" for non-downloaded tracks while offline — see §10.1).
- The session may remain `Authenticated`; we do not force logout. No
  requests are made because nothing watches them — every
  network-bound provider gates on the active zone or session.
- On launch, if the last-active zone was Offline, **silent reconnect
  is skipped**. The app boots straight into the offline shell. The
  user can switch to a remote zone to trigger a reconnect.

When **any other zone** is active (Local or remote):

- Standard online behavior.
- The local player still prefers a downloaded `file://` over the MCWS
  stream URL when one exists. Saves bandwidth and matches user
  expectation.

### 10.1 Action-menu adaptation while offline

While `isOfflineActive == true`, the kebab popup menu items are
filtered:

| Track state | Available actions |
|---|---|
| `downloaded` | Play, Play next, Add to playing now, Delete download |
| `notDownloaded` | (menu hidden — track is not actionable) |
| `queued` / `running` | (menu hidden — wait for completion) |

"Play next" and "Add to playing now" route to the local just_audio
queue, not to MCWS `Playback/PlayByKey`.

## 11. Local Player Integration

`LocalPlayerService._createSource(track)` becomes:

```
final localPath = downloadsRepo.localPathFor(track.fileKey);
if (localPath != null) {
  return AudioSource.uri(Uri.file(localPath), tag: track);
}
// Offline zone with no local file → refuse to build a streaming source
if (isOfflineActive) {
  throw StateError('Track ${track.fileKey} is not downloaded');
}
// existing streaming branch
return AudioSource.uri(Uri.parse(streamUrl), tag: track,
    headers: {...});
```

The `LocalQueueRepository` is unchanged — it persists `Track` JSON
which already contains `fileKey`, so the source resolution happens at
play-time, not enqueue-time. A track downloaded *after* being
enqueued automatically switches to the local file on next play.

`localAudioQualityPrefProvider` change listener already triggers a
queue reload; we add a similar listener for the downloads set so a
new download mid-queue prompts a reload at the current playhead.

The Offline zone shares the same `LocalPlayer` AsyncNotifier as the
Local zone — the only difference is that source construction refuses
to fall back to streaming. The local queue (in Drift) is shared
between both zones; switching from Local to Offline does not clear
playback.

## 12. Telemetry & Logging

- Talker logs at `info` for queue/start/finish/cancel/error.
- No PII in log lines (the file path is fine; the Track JSON is not
  written verbatim).
- A `DownloadServiceObserver` exposes counts (queued, running,
  downloaded, failed) for the Settings storage panel without doing
  a full Drift query on every rebuild.

## 13. Open Questions

1. **Auto-switch to Offline zone on connectivity loss.** Should
   `connectivity_plus` automatically switch the active zone to
   Offline when the device drops the network? Manual avoids
   surprises but leaves a broken UX when Wi-Fi just died. Proposed
   default: manual, with a banner suggesting the switch. Lower
   priority now that switching is one tap.

2. **Hide vs disable Library sub-tabs while offline.** Hiding is
   simpler; disabling with a tooltip preserves muscle memory.
   Proposed: disable.

3. ~~**What happens to the Playing Now queue in offline mode?**~~
   **Resolved:** Queue tab is hidden while the Offline zone is
   active (server-side state is unreachable). Local just_audio queue
   remains via Now Playing.

4. **Download FLAC vs source format.** MCWS can also serve the
   original file via `Conversion=` omitted — which would preserve the
   exact source bits and avoid any transcode. FLAC `Conversion=flac`
   re-encodes from PCM (since MC's streaming pipeline is PCM). For
   max fidelity *and* compression, we stick with FLAC; users wanting
   bit-perfect originals are a v2 concern.

5. **`jr_proxy` interaction.** When the user has configured the app
   to point at the proxy, downloads should bypass the transcode and
   request `Conversion=flac` directly from MC. The proxy should
   detect the FLAC conversion and proxy it without re-encoding.
   Coordination needed on the proxy side; flagged for the proxy repo.

6. **Multiple parallel downloads.** Serial is fine for v1. v2: a
   small worker pool (2–3) with backpressure on disk write rate.

7. **Background downloads.** Out of scope. Documented for v2:
   `flutter_background_service` or platform-specific
   (`WorkManager` / `BGProcessingTask`).

## 14. Phasing

### Phase A — Foundation (no UI)
- Drift v5 migration (`downloaded_tracks`, `download_jobs`).
- `DownloadsRepository` interface + impl (filesystem + Drift).
- `DownloadService` worker (serial; cancel; retry-on-launch for
  `running` jobs left over from a crash).
- Unit tests: repo (in-memory Drift + temp dir), service (mock Dio).

### Phase B — Triggers + progress
- Kebab "Download" / "Cancel" / "Delete" / "Retry" entries in the
  five surfaces (track tile, album tile, track-list scaffold, browse
  group, folder).
- `DownloadProgressIndicator` widget.
- `downloadStatusProvider(fileKey)`.

### Phase C — Downloads tab
- New `DownloadsTabRouterRoute` and three nested screens.
- `LibraryScreen` segmented control gains the fifth tab.
- Derived providers: `downloadedArtistsProvider`,
  `downloadedAlbumsProvider(artist)`, `downloadedAlbumTracksProvider(albumGroupId)`.

### Phase D — Local-player integration
- `LocalPlayerService._createSource()` prefers local file when
  available.
- Reload-on-download listener in `LocalPlayer.build()`.

### Phase E — Offline zone
- Add `isOffline` flag to `Zone` (Freezed); regenerate.
- `ZoneRepositoryImpl` appends the synthetic Offline zone after Local.
- `isOfflineActiveProvider` derived from `activeZoneProvider`.
- Polling notifiers gate on `isLocal || isOffline` instead of just
  `isLocal`.
- Library sub-tab gating + Queue-tab hiding when offline.
- Action-menu adaptation (§10.1).
- Skip silent reconnect on launch when last-active zone was Offline.
- Settings: storage panel + Clear-all action (no offline toggle).

### Phase F — Polish
- Empty states ("No downloads yet"; "Album has 0 tracks downloaded").
- Storage size formatting (MB/GB).
- Confirm dialogs on destructive actions.
- Failure surface: list of failed downloads in Settings with
  per-row Retry / Remove.

## 15. Acceptance Criteria

- [ ] User downloads a single track from the library kebab; it
      appears in the Downloads tab within seconds.
- [ ] User downloads a multi-disc album; each disc is grouped under
      one album entry, with tracks shown under `Disc N of M` headers.
- [ ] After force-quit during a download, the app recovers: the job
      is back in `queued`, the orphan `.part` file is cleaned, and
      the queue resumes.
- [ ] Selecting the **Offline** zone, then airplane-moding the
      device, then playing a downloaded track works end-to-end with
      no network calls (verified via Talker log).
- [ ] Last-selected zone persists across launches; if Offline was
      selected at exit, the next launch boots into offline shell
      without attempting silent reconnect.
- [ ] Switching from Offline to Local (or any remote zone) resumes
      polling and re-enables the disabled library sub-tabs.
- [ ] Attempting to play a non-downloaded track while Offline is
      blocked at the action-menu level (no "Play" entry shown).
- [ ] Deleting a downloaded album removes all its track files and
      its artwork; storage usage updates.
- [ ] Clear-all empties the `downloads/` directory and both Drift
      tables; storage usage shows 0.
- [ ] Downloaded tracks are preferred over the network stream when
      online and online-mode active.
- [ ] All UI surfaces use the existing `PopupMenuButton<String>`
      idiom; no new ad-hoc action menus.
- [ ] `flutter analyze` clean; `dart format .` applied; tests pass.
