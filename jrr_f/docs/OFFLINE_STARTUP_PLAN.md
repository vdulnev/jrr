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
    1. Set the session state to `SessionState.authenticated` with a synthetic `ServerInfo` (e.g., `id: 'offline'`).
    2. Set the active zone to the Offline zone.

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
- **`ZoneRepositoryImpl`**: 
    - Already handles returning local zones when MCWS fails. 
    - It should be updated to not even attempt the MCWS call if the current session is the "offline" one.
    - **New**: If in "pure" offline mode (no server), it should only return the "Offline" zone, hiding the "Local" zone to avoid confusion (since "Local" might still attempt streaming).

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

### Phase 2: Dependency Handling
1.  Create a `MockMcwsClient` or ensure `McwsClient` can be initialized with an empty URL for offline mode.
2.  Alternatively, use a separate `get_it` scope for offline mode that doesn't provide a real `McwsClient`, and update repositories to use `getIt.getSafe<McwsClient>()` (if we add such an extension) or check session state.
    - *Decision*: Registering a dummy `McwsClient` that throws `AppException.offline()` on any call is the safest and least intrusive way.

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
