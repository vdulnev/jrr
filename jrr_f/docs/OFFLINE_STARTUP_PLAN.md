# Offline Startup Plan — Implementation Plan

This plan describes how to allow the `jrr_f` application to start and function in **Offline Mode** without requiring a login to an MCWS server.

## 1. Goals
- Allow users to enter "Offline Mode" directly from the login screen.
- Support starting the app in "Offline Mode" if it was the last active state, even if no server is configured.
- Restricted access: only the "Offline" zone and downloaded tracks are available.
- No network I/O should be attempted when in this state.

## 2. Architecture Changes

### 2.1 Session Management (`session_provider.dart`)
- Update `_attemptSilentReconnect` to check for `offline-zone-guid` even if no saved server is found.
- Add `enterOfflineMode()` method to the `Session` notifier.
- This method will:
    1. Set the session state to `SessionState.authenticated` with a synthetic `ServerInfo.offline`.
    2. Ensure the active zone is set to the Offline zone.
- **Note**: Since the `Player` provider already branches to `localPlayerProvider` for the Offline zone, no changes are needed to the playback logic.

### 2.2 Server Info (`server_info.dart`)
- Define a constant `ServerInfo.offline` to represent the offline session.
```dart
static const offline = ServerInfo(
  id: 'offline',
  name: 'Offline Mode',
  version: 'none',
  platform: 'none',
  address: '',
);
```

### 2.3 Repositories & Dependency Injection
- **No MockMcwsClient needed**: Instead of providing a dummy client, we will update the repositories and providers to respect the offline state.
- **`ZoneRepositoryImpl`**: 
    - Update it to check if the current session is `ServerInfo.offline`. If so, it should return ONLY the "Offline" zone without attempting ANY network call.
    - This avoids the need for a `McwsClient` to be present in `get_it` during pure offline mode.
- **`ZoneList` Provider**: Update it to allow building the zone list if the session is `ServerInfo.offline`.

### 2.4 UI Changes
- **`ServerSetupScreen`**:
    - Add a "Continue Offline" button (styled as a secondary action or text button).
    - Tapping it calls `ref.read(sessionProvider.notifier).enterOfflineMode()`.
- **`MiniPlayer` / `NowPlaying`**:
    - Ensure they function correctly with the synthetic `ServerInfo`.

## 3. Implementation Steps

### Phase 1: Session & Persistence
1.  Add `enterOfflineMode` to `Session` provider.
2.  Modify `Session._attemptSilentReconnect` to support server-less offline startup.
3.  Ensure `active_zone_guid` is set to `offline-zone-guid` when entering this mode.

### Phase 2: Repository & Provider Guarding
1.  Update `ZoneRepositoryImpl.getZones()` to skip network calls if session is offline.
2.  Update `ZoneList` provider to build successfully in offline mode.
3.  Ensure `Library` providers handle the offline state gracefully (already mostly done by `isOfflineActive` checks).

### Phase 3: UI Integration
1.  Update `ServerSetupScreen` with the "Continue Offline" button.
2.  Update `LibraryScreen` to ensure only the "Downloads" tab is active/visible if we are in this "pure" offline mode. (Currently, the app might show empty tabs for Artists/Browse if there's no server).

## 4. Acceptance Criteria
- [ ] Fresh install: User sees "Continue Offline" on the login screen.
- [ ] Tapping "Continue Offline" enters the app; the "Offline" zone is active.
- [ ] Only the "Downloads" tab in Library shows content.
- [ ] Force-quitting and restarting the app stays in "Offline Mode" without showing the login screen.
- [ ] User can "Logout" from the Settings tab to return to the login screen.
- [ ] Switching to a remote zone from the Zones tab (if possible/visible) should prompt for login if no server is configured.
