# JRiver Remote — Flutter Design Analysis

_April 2026_

---

## Overview

The Flutter codebase has a solid foundation: well-defined design tokens (`AppColors`, `AppTextStyles`), clean Riverpod state management, and a consistent dark theme. The issues below are UX/visual polish gaps — none are architectural. Priority order is given at the end.

---

## Issues by Screen

### 1. `ServerSetupScreen` — No Visual Branding

**File:** `lib/features/connection/widgets/server_setup_screen.dart`

The form uses a stock `AppBar` with "Connect to JRiver" as a plain text title, and standard Material `TextFormField` inputs on an unstyled scaffold. Nothing communicates that this is an audiophile app — first launch feels generic.

**What the prototype does:** Centered logo mark, app name, tagline ("Connect to your media server"), dark branded background.

**Improvements:**
- Replace `AppBar` with a custom header: the app icon (vinyl/concentric-circle mark), "JRiver Remote" title, and a subtitle.
- Remove the `AppBar` entirely and use `SafeArea` + `Padding`.
- **Bug:** `username` validator is `(v) => v.trim().isEmpty ? 'Required' : null` — but the spec (`§2.1`) says username and password are optional. Remove the required validator.

---

### 2. `ConnectingScreen` — Too Bare

**File:** `lib/features/connection/widgets/connecting_screen.dart`

Currently just `LoadingView(message: message)` — a centered spinner and a string. 20 lines total including imports.

**Improvements:**
- Show the server address in `IBMPlexMono` style.
- Animate the spinner with an accent-colored ring (matching `AppColors.accent`), not the default `CircularProgressIndicator` color.
- Optionally: a subtle success checkmark transition when auth completes (matches the prototype's animated step-through).

---

### 3. `NowPlayingScreen` — Subtitle Truncation & Missing Queue Position

**File:** `lib/features/player/widgets/now_playing_screen.dart`

**Problem A — one-line truncation:**
```dart
Text(
  [status.artist, [status.album, track?.dateReadable].join(' - ')].join(' - '),
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
)
```
On shorter devices the album disappears completely. Artist + album + date in one truncated line is too dense.

**Fix:** Split into two `Text` widgets:
- Line 1: `status.artist` — `nowPlayingArtist` style
- Line 2: `[status.album, track?.dateReadable].join(' · ')` — `monoLabel` style, dimmer

**Problem B — no queue position:**
`playingNowPosition` and `playingNowTracks` are both present in `PlayerStatus` but nothing in the UI surfaces them.

**Fix:** Add `3 / 12` (position / total) to the header row next to "NOW PLAYING", using `monoLabel` style. Low cost, high value.

---

### 4. `QueueScreen` — Subtitle Too Dense

**File:** `lib/features/queue/widgets/queue_screen.dart`

Current subtitle:
```dart
[[track.dateReadable, track.album].join(' - '), track.artist].join(' · ')
```
Three fields in one truncated line. The queue is the one context where users already know what album they're in.

**Fix:** Show only `track.artist · track.album`. Drop `dateReadable` from the queue row — it adds noise without value here.

---

### 5. `AlbumRowTile` — No Track Count in Subtitle

**File:** `lib/features/library/widgets/album_row_tile.dart`

Title shows `year - name` (correct). Subtitle shows `artist` (correct). But `album.tracks` (track count) is available and never shown.

**Fix:** Change subtitle to `'${album.artist}  ·  ${album.tracks} tracks'` using `monoLabel` for the count portion. Lets users know what they're tapping without opening it.

---

### 6. `LibraryItemTile` — Long-Press Is Undiscoverable

**File:** `lib/features/library/widgets/library_item_tile.dart`

File path is accessible only via long-press, which most users won't discover. The expand-on-tap already reveals `folderPath` and `filePath` — but both render in the same `monoLabel` style, making them visually identical.

**Fixes:**
- Style `folderPath` with `AppColors.accent` (it's the navigable parent, more important).
- Style `filePath` smaller and dimmer (it's the full path, secondary).
- Consider removing the long-press sheet entirely since expand-on-tap already shows the path — duplication adds confusion.

---

### 7. `ZoneListScreen` — No Playback State Per Zone

**File:** `lib/features/zones/widgets/zone_list_screen.dart`

Zone tiles show name + optional DLNA badge. Nothing indicates whether a zone is currently playing, paused, or idle — users have to switch zones to find out.

**Fix:** Add a small playback state badge to each zone tile. `PlayerStatus.state` (playing/paused/stopped) is already polled for the active zone. For non-active zones, a simple "idle" vs "playing" indicator derived from `Playback/Info` per zone would suffice. At minimum, show the active zone's state (playing/paused icon) next to the active dot.

---

### 8. `BrowseTreeView` / `BrowseItemTile` — No Way to Favorite Items

**Files:** `lib/features/library/widgets/browse_screen.dart`, `browse_item_tile.dart`

The Favorites tab exists and renders a `_FavoritesList`, but there is no heart/bookmark action anywhere in the Browse tree to add items to Favorites. The feature exists but has no entry point.

**Fix:** Add a trailing heart `IconButton` to `BrowseItemTile`. When tapped, call `favoritesProvider.notifier.toggle(item)`. This makes the Favorites tab actually useful.

---

### 9. Action Inconsistency — Text Symbols vs Material Icons

**Files:** `lib/shared/widgets/track_row.dart` vs `lib/features/library/widgets/album_row_tile.dart`

`TrackRow` uses Unicode text labels:
```dart
ActionChipButton(label: '▶ Play', ...)
ActionChipButton(label: '+ Add to Playing Now', ...)
```

`AlbumRowTile` uses a `PopupMenuButton` with `Icons.play_arrow_outlined`, `Icons.add_circle_outline`, etc.

Two different UI patterns for the same three actions, in the same screen.

**Fix:** Standardise on one approach. The popup menu (`PopupMenuButton`) is the more scalable pattern — it's already used in `AlbumRowTile` and matches Material conventions. Migrate `TrackRow`'s chip-based actions to the same popup, or introduce a shared `TrackActionsMenu` widget used by both.

---

## Priority Order

| # | Issue | Impact | Effort |
|---|---|---|---|
| 1 | `ServerSetupScreen` branding + fix optional credentials validator | High | Low |
| 2 | `NowPlayingScreen` 2-line subtitle + queue position counter | High | Low |
| 3 | `AlbumRowTile` track count in subtitle | Medium | Low |
| 4 | `QueueScreen` simplified subtitle | Medium | Low |
| 5 | Action pattern unification (`TrackRow` vs `AlbumRowTile`) | Medium | Medium |
| 6 | `ZoneListScreen` playback state badge | Medium | Medium |
| 7 | `LibraryItemTile` path styling differentiation | Low | Low |
| 8 | `BrowseItemTile` favorite action | Low | Medium |
| 9 | `ConnectingScreen` visual polish | Low | Low |
