# JRR — JRiver Remote

Language-agnostic specification for a remote control application
for JRiver Media Center via MCWS (Media Center Web Service).

**Version:** 0.1.0
**Status:** Draft

---

## 1. Overview

JRR is a remote control application for JRiver Media Center.
It communicates with MCWS v1 over HTTP on a local network.

### 1.1 Goals

- Control audio playback across multiple zones
- Display now-playing information with artwork
- Manage the Playing Now queue
- Work consistently across mobile and desktop platforms

### 1.2 Scope

| Area                        | Status   |
|-----------------------------|----------|
| Playback control            | v1       |
| Now Playing info & artwork  | v1       |
| Zone management             | v1       |
| Playing Now queue           | v1       |
| Library browse & search     | v2       |
| Playlist management         | Later    |
| File metadata editing       | Later    |
| DSP & audio configuration   | Later    |
| Video streaming             | Skip     |
| Television & recording      | Skip     |

### 1.3 Non-Goals

- Video playback or transcoding
- Television tuner control
- MCC command passthrough
- Keyboard simulation
- License or skin management

---

## 2. Connection & Authentication

### 2.1 Server Address

The user manually provides the server address as `host:port`.
Default MCWS port is `52199`. No automatic discovery.

### 2.2 Authentication Flow

1. Client calls `GET /MCWS/v1/Authenticate` with HTTP Basic auth
   (`Authorization: Basic base64(username:password)`).
2. Server responds with a token:
   ```xml
   <Response Status="OK">
     <Item Name="Token">token_value</Item>
     <Item Name="ReadOnly">0</Item>
   </Response>
   ```
3. Client stores the token for the session.
4. All subsequent requests append `Token=token_value` as a query
   parameter. No further Basic auth headers required.

### 2.3 Connection Validation

On startup, client calls `GET /MCWS/v1/Alive` to verify the server
is reachable and to retrieve server metadata.

Response fields:
- `RuntimeGUID` — unique server instance ID
- `ProgramVersion` — MC version string
- `FriendlyName` — user-assigned server name
- `Platform` — `Windows`, `Mac`, or `Linux`

The `FriendlyName` should be displayed to the user to confirm
they connected to the intended server.

### 2.4 Error Handling

MCWS returns `<Response Status="Failure">` for errors.
The client must handle:
- Connection refused — server unreachable
- HTTP 401 — invalid credentials
- `Status="Failure"` — command rejected by server

---

## 3. Domain Model

All implementations must use these types. Field names are
normative. Types may be extended with platform-specific
concerns (e.g., serialization annotations) but the core
fields must be present.

### 3.1 ServerInfo

Represents the connected MCWS server.

| Field           | Type   | Source                |
|-----------------|--------|-----------------------|
| id              | string | Alive → RuntimeGUID   |
| name            | string | Alive → FriendlyName  |
| version         | string | Alive → ProgramVersion|
| platform        | string | Alive → Platform      |
| address         | string | user-provided host:port|

### 3.2 Zone

Represents a playback zone.

| Field    | Type   | Source                   |
|----------|--------|--------------------------|
| id       | string | Playback/Zones → ZoneID  |
| name     | string | Playback/Zones → ZoneName|
| guid     | string | Playback/Zones → ZoneGUID|
| isDLNA   | bool   | Playback/Zones → ZoneDLNA|

### 3.3 PlaybackState (enum)

| Value   | MCWS State value |
|---------|------------------|
| stopped | 0                |
| paused  | 1                |
| playing | 2                |

### 3.4 ShuffleMode (enum)

| Value     | MCWS Mode string |
|-----------|------------------|
| off       | Off              |
| on        | On               |
| automatic | Automatic        |

### 3.5 RepeatMode (enum)

| Value    | MCWS Mode string |
|----------|------------------|
| off      | Off              |
| playlist | Playlist         |
| track    | Track            |

### 3.6 PlayerStatus

Snapshot of the current playback state for a zone.

| Field                     | Type          | Source                              |
|---------------------------|---------------|-------------------------------------|
| zoneId                    | string        | Playback/Info → ZoneID              |
| zoneName                  | string        | Playback/Info → ZoneName            |
| state                     | PlaybackState | Playback/Info → State               |
| trackInfo                 | TrackInfo?    | see below (null when queue empty)   |
| positionMs                | int           | Playback/Info → PositionMS          |
| durationMs                | int           | Playback/Info → DurationMS          |
| positionDisplay           | string        | Playback/Info → PositionDisplay     |
| volume                    | float         | Playback/Info → Volume (0.0–1.0)    |
| volumeDisplay             | string        | Playback/Info → VolumeDisplay       |
| isMuted                   | bool          | derived (see §4.5)                  |
| shuffleMode               | ShuffleMode   | Playback/Shuffle                    |
| repeatMode                | RepeatMode    | Playback/Repeat                     |
| playingNowPosition        | int           | Playback/Info → PlayingNowPosition  |
| playingNowTracks          | int           | Playback/Info → PlayingNowTracks    |
| playingNowPositionDisplay | string        | Playback/Info → PlayingNowPositionDisplay |
| playingNowChangeCounter   | int           | Playback/Info → PlayingNowChangeCounter   |

### 3.7 TrackInfo

Metadata for the currently playing track.

| Field      | Type   | Source                       |
|------------|--------|------------------------------|
| fileKey    | string | Playback/Info → FileKey      |
| name       | string | Playback/Info → Name         |
| artist     | string | Playback/Info → Artist       |
| album      | string | Playback/Info → Album        |
| imageUrl   | string | Playback/Info → ImageURL (resolve to full URL) |
| bitrate    | int    | Playback/Info → Bitrate (kbps)    |
| bitDepth   | int    | Playback/Info → Bitdepth          |
| sampleRate | int    | Playback/Info → SampleRate (Hz)   |
| channels   | int    | Playback/Info → Channels          |

### 3.8 PlayingNowItem

An entry in the Playing Now queue.

| Field   | Type   | Source                              |
|---------|--------|-------------------------------------|
| index   | int    | position in the list (0-based)      |
| fileKey | string | from MPL/JSON response              |
| name    | string | Name field                          |
| artist  | string | Artist field                        |
| album   | string | Album field                         |

---

## 4. Operations

All operations are HTTP GET requests to the MCWS endpoint.
Parameters are passed as query string values.
The auth token is appended as `Token=<token>` to every request.

Base URL: `http://<host>:<port>/MCWS/v1`

### 4.1 Transport

| Operation   | Endpoint                      | Key Parameters       |
|-------------|-------------------------------|----------------------|
| play        | Playback/Play                 | Zone, ZoneType       |
| playPause   | Playback/PlayPause            | Zone, ZoneType       |
| pause       | Playback/Pause                | State (0, 1, or -1)  |
| stop        | Playback/Stop                 | Zone, ZoneType       |
| stopAll     | Playback/StopAll              | —                    |
| next        | Playback/Next                 | Zone, ZoneType       |
| previous    | Playback/Previous             | Zone, ZoneType       |

**Zone targeting:** Every transport command accepts `Zone` and
`ZoneType` parameters. The client should always pass
`Zone=<id>&ZoneType=ID` to target a specific zone.

### 4.2 Seek

**Endpoint:** `Playback/Position`

| Parameter | Type   | Description                           |
|-----------|--------|---------------------------------------|
| Position  | int    | Target position in ms or %            |
| Relative  | int    | 1 = forward, -1 = backward, omit = absolute |
| Mode      | string | `ms` (default) or `%`                 |
| Zone      | string | Zone ID                               |
| ZoneType  | string | `ID`                                  |

**Usage patterns:**
- Get current position: omit `Position`
- Seek to absolute time: `Position=30000&Mode=ms`
- Jump forward 10s: `Position=10000&Relative=1`
- Jump backward 10s: `Position=10000&Relative=-1`
- Seek to 50%: `Position=50&Mode=%`

**Response:** `<Item Name="Position">` — position in ms after change.

### 4.3 Volume

**Endpoint:** `Playback/Volume`

| Parameter | Type  | Description                            |
|-----------|-------|----------------------------------------|
| Level     | float | 0.0 to 1.0 (omit to query only)       |
| Relative  | int   | 1 = add Level to current              |
| Zone      | string| Zone ID                                |
| ZoneType  | string| `ID`                                   |

**Usage patterns:**
- Get current volume: omit `Level`
- Set to 75%: `Level=0.75`
- Increase by 10%: `Level=0.1&Relative=1`
- Decrease by 10%: `Level=-0.1&Relative=1`

**Response:**
- `<Item Name="Level">` — volume as 0.0–1.0
- `<Item Name="Display">` — volume as display string

### 4.4 Mute

**Endpoint:** `Playback/Mute`

| Parameter | Type | Description          |
|-----------|------|----------------------|
| Set       | int  | 1 = mute, 0 = unmute |
| Zone      | string | Zone ID            |
| ZoneType  | string | `ID`               |

**Response:** `<Item Name="State">` — mute state after change.

### 4.5 Shuffle & Repeat

**Shuffle endpoint:** `Playback/Shuffle`

| Parameter | Type   | Values                              |
|-----------|--------|-------------------------------------|
| Mode      | string | Off, On, Automatic, Toggle, Reshuffle |
| Zone      | string | Zone ID                             |

- Omit `Mode` to query current state.
- Response: `<Item Name="Mode">` — current mode after change.

**Repeat endpoint:** `Playback/Repeat`

| Parameter | Type   | Values                              |
|-----------|--------|-------------------------------------|
| Mode      | string | Off, Playlist, Track, Stop, Toggle  |
| Zone      | string | Zone ID                             |

- Omit `Mode` to query current state.
- Response: `<Item Name="Mode">` — current mode after change.

### 4.6 Now Playing Info

**Endpoint:** `Playback/Info`

| Parameter | Type   | Description                        |
|-----------|--------|------------------------------------|
| Zone      | string | Zone ID                            |
| ZoneType  | string | `ID`                               |

Returns all fields listed in `PlayerStatus` (§3.6) and
`TrackInfo` (§3.7). This is the primary polling endpoint.

### 4.7 Artwork

**Endpoint:** `File/GetImage`

| Parameter     | Type   | Description                       |
|---------------|--------|-----------------------------------|
| File          | string | File key from TrackInfo.fileKey   |
| Type          | string | `Thumbnail` (default) or `Full`   |
| Width         | int    | Desired width in pixels           |
| Height        | int    | Desired height in pixels          |
| Format        | string | `jpg` (default) or `png`          |
| Square        | int    | 1 = crop to square                |
| FillTransparency | string | Hex color for transparency fill |

Returns the image as binary data (not XML).

The `ImageURL` field from `Playback/Info` provides a relative
URL (e.g., `MCWS/v1/File/GetImage?File=12345`). The client
must prepend the base URL to form the full image URL.

### 4.8 Zone Management

**List zones:** `Playback/Zones`

Returns `NumberZones` and indexed fields: `ZoneName#`, `ZoneID#`,
`ZoneGUID#`, `ZoneDLNA#`. Parse into a list of `Zone` objects.

**Set active zone:** `Playback/SetZone`

| Parameter | Type   |
|-----------|--------|
| Zone      | string |
| ZoneType  | string |

**Link zones:** `Playback/LinkZones`

| Parameter  | Type   |
|------------|--------|
| Zone1      | string |
| ZoneType1  | string |
| Zone2      | string |
| ZoneType2  | string |

**Unlink zone:** `Playback/UnlinkZones`

| Parameter | Type   |
|-----------|--------|
| Zone      | string |
| ZoneType  | string |

### 4.9 Playing Now Queue

**Get queue:** `Playback/Playlist`

| Parameter         | Type   | Description                    |
|-------------------|--------|--------------------------------|
| Action            | string | `JSON` for JSON array          |
| Zone              | string | Zone ID                        |
| ZoneType          | string | `ID`                           |
| Fields            | string | semi-colon delimited field list|
| NoLocalFilenames  | int    | 1 (filenames meaningless to remote client) |

Use `Action=JSON` and `Fields=Name;Artist;Album` for efficient
retrieval. Response is a JSON array of file objects.

**Play by index:** `Playback/PlayByIndex`

| Parameter | Type | Description                |
|-----------|------|----------------------------|
| Index     | int  | 0-based index in queue     |
| Zone      | string | Zone ID                  |

**Play by key:** `Playback/PlayByKey`

| Parameter | Type   | Description                           |
|-----------|--------|---------------------------------------|
| Key       | string | File key (comma-separated for multiple)|
| Location  | string | `End`, `Next`, or numeric index       |
| Zone      | string | Zone ID                               |

**Edit queue:** `Playback/EditPlaylist`

| Parameter | Type   | Description                |
|-----------|--------|----------------------------|
| Action    | string | `Move` or `Remove`         |
| Source    | int    | Source index (0-based)     |
| Target    | int    | Target index (for Move)    |
| Zone      | string | Zone ID                    |

**Clear queue:** `Playback/ClearPlaylist`

| Parameter | Type   |
|-----------|--------|
| Zone      | string |
| ZoneType  | string |

---

## 5. Polling Strategy

MCWS has no push notification mechanism. Clients must poll
for state changes.

### 5.1 Intervals

| Condition                  | Endpoint        | Interval |
|----------------------------|-----------------|----------|
| Playback state = playing   | Playback/Info   | 1 second |
| Playback state = paused    | Playback/Info   | 5 seconds|
| Playback state = stopped   | Playback/Info   | 5 seconds|
| Zone list                  | Playback/Zones  | 30 seconds|

### 5.2 Change Detection

The `PlayingNowChangeCounter` field (from `Playback/Info`)
increments whenever the Playing Now queue is modified. The
client should:

1. Store the last known counter value.
2. On each poll, compare with the new value.
3. If changed, re-fetch the queue via `Playback/Playlist`.

This avoids polling the full playlist on every tick.

### 5.3 Lifecycle

- **Start polling** when the connection is established and
  authenticated.
- **Pause polling** when the app is backgrounded or loses
  focus (mobile: on pause; desktop: on minimize/hide).
- **Resume polling** when the app returns to foreground.
  Immediately fetch `Playback/Info` on resume to sync state.
- **Stop polling** on disconnect or app termination.

---

## 6. MCWS Response Parsing

### 6.1 XML Format

Most endpoints return:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>
<Response Status="OK">
  <Item Name="FieldName">value</Item>
  ...
</Response>
```

Parse into a `Map<string, string>` keyed by the `Name` attribute.
All values are strings — cast to appropriate types per the domain
model.

### 6.2 JSON Format

File queries with `Action=JSON` return a JSON array:

```json
[
  {
    "Key": 123,
    "Name": "Track Name",
    "Artist": "Artist Name",
    ...
  }
]
```

### 6.3 Binary Responses

`File/GetImage` and `File/GetFile` return binary data directly.
Content-Type header indicates the format.

### 6.4 Error Responses

```xml
<Response Status="Failure" />
```

May include additional information in `Item` elements. Treat
any `Status` value other than `"OK"` as an error.

---

## 7. Architecture Guidelines

### 7.1 Layer Structure

Implementations should follow this layering:

```
┌─────────────────────────┐
│         UI Layer         │  Platform-specific widgets/views
├─────────────────────────┤
│      State Layer         │  PlayerStatus, zone list, queue
├─────────────────────────┤
│     Service Layer        │  Polling orchestration, commands
├─────────────────────────┤
│     API Client Layer     │  HTTP calls, XML/JSON parsing
└─────────────────────────┘
```

**API Client** — handles HTTP, auth token injection, response
parsing. Returns domain model types. One method per operation.

**Service** — orchestrates polling, batches state updates,
exposes commands (play, pause, etc.) as simple method calls.
Owns the polling timer and change detection logic.

**State** — holds current `PlayerStatus`, zone list, and queue.
Notifies the UI of changes. Implementation varies by platform
(BLoC, ViewModel, Redux, etc.).

**UI** — renders state, dispatches user actions to the service.

### 7.2 API Client Interface

The API client must expose these methods (pseudocode):

```
interface McwsClient {
  // Connection
  alive() → ServerInfo
  authenticate(username, password) → Token

  // Transport
  play(zoneId)
  playPause(zoneId)
  pause(zoneId, state?)
  stop(zoneId)
  stopAll()
  next(zoneId)
  previous(zoneId)

  // Seek & Volume
  getPosition(zoneId) → int
  setPosition(zoneId, positionMs, relative?)
  getVolume(zoneId) → (float, string)
  setVolume(zoneId, level, relative?)
  mute(zoneId, set)

  // Modes
  getShuffle(zoneId) → ShuffleMode
  setShuffle(zoneId, mode)
  getRepeat(zoneId) → RepeatMode
  setRepeat(zoneId, mode)

  // Info
  getPlaybackInfo(zoneId?) → PlayerStatus
  getImage(fileKey, width?, height?, square?) → bytes

  // Zones
  getZones() → List<Zone>
  setActiveZone(zoneId)
  linkZones(zoneId1, zoneId2)
  unlinkZone(zoneId)

  // Playing Now
  getPlayingNow(zoneId, fields?) → List<PlayingNowItem>
  playByIndex(zoneId, index)
  playByKey(zoneId, key, location?)
  editQueue(zoneId, action, source, target?)
  clearQueue(zoneId)
}
```

### 7.3 URL Construction

All requests follow the pattern:

```
http://{host}:{port}/MCWS/v1/{endpoint}?{params}&Token={token}
```

The API client must:
- URL-encode parameter values
- Always include `ZoneType=ID` when passing a zone ID
- Resolve relative image URLs against the base URL

---

## 8. Versioning

This spec follows semantic versioning.

- **v1.0** — playback, zones, playing now (this document)
- **v2.0** — library browse & search, playlist management
- **v3.0** — file metadata, DSP, audio configuration

---

## Appendix A: MCWS Endpoint Reference (v1 Scope)

| Endpoint                  | Method | Description                    |
|---------------------------|--------|--------------------------------|
| Alive                     | GET    | Server health & version        |
| Authenticate              | GET    | Get auth token                 |
| Playback/Play             | GET    | Start playback                 |
| Playback/PlayPause        | GET    | Toggle play/pause              |
| Playback/Pause            | GET    | Set pause state                |
| Playback/Stop             | GET    | Stop playback                  |
| Playback/StopAll          | GET    | Stop all zones                 |
| Playback/Next             | GET    | Next track                     |
| Playback/Previous         | GET    | Previous track                 |
| Playback/Position         | GET    | Get/set position               |
| Playback/Volume           | GET    | Get/set volume                 |
| Playback/Mute             | GET    | Set mute state                 |
| Playback/Shuffle          | GET    | Get/set shuffle mode           |
| Playback/Repeat           | GET    | Get/set repeat mode            |
| Playback/Info             | GET    | Get playback info              |
| Playback/Zones            | GET    | List zones                     |
| Playback/SetZone          | GET    | Set active zone                |
| Playback/LinkZones        | GET    | Link two zones                 |
| Playback/UnlinkZones      | GET    | Unlink a zone                  |
| Playback/Playlist         | GET    | Get playing now queue          |
| Playback/PlayByIndex      | GET    | Play queue item by index       |
| Playback/PlayByKey        | GET    | Play file(s) by key            |
| Playback/EditPlaylist     | GET    | Move/remove queue items        |
| Playback/ClearPlaylist    | GET    | Clear the queue                |
| File/GetImage             | GET    | Get file artwork               |
