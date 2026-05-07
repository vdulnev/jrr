# JRiver Remote (jrr_f)

A Flutter client for controlling [JRiver Media Center](https://www.jriver.com/) over its MCWS HTTP API. Supports Android, iOS, iPadOS, macOS, Windows, Linux, and web.

This guide covers building and installing on **iOS / iPadOS / macOS** from source with Xcode, since the app is not currently distributed through the App Store.

---

## Prerequisites

You need a Mac running macOS with the following installed:

| Tool | Version | How to install |
|------|---------|----------------|
| **Xcode** | 15 or newer | [Mac App Store](https://apps.apple.com/app/xcode/id497799835) |
| **Xcode Command Line Tools** | matches Xcode | `xcode-select --install` |
| **Flutter SDK** | 3.11.4 or newer | [flutter.dev/install](https://docs.flutter.dev/get-started/install/macos) |
| **CocoaPods** | 1.13+ | `sudo gem install cocoapods` |
| **Git** | any recent | preinstalled with Xcode CLT |
| **Apple ID** | any (free works) | [appleid.apple.com](https://appleid.apple.com) |

After installing Xcode, accept the license and run a first launch so it installs additional components:

```bash
sudo xcodebuild -license accept
sudo xcodebuild -runFirstLaunch
```

Verify the Flutter toolchain is healthy:

```bash
flutter doctor
```

Resolve any red ❌ items it reports for the **iOS** and **macOS** rows before continuing.

> **Why Flutter is required (Xcode alone is not enough).** The app's source is Dart, which Xcode cannot compile. The Flutter SDK compiles Dart to native code, generates the `Generated.xcconfig` and `Flutter/ephemeral/` files that the Xcode project includes, resolves Dart packages and plugin pods, and runs the code generators this project depends on (Riverpod, auto_route, Retrofit, freezed). Pressing ▶ in Xcode internally invokes Flutter's `xcode_backend.sh`, so the build fails immediately if `flutter` isn't on `PATH`.

---

## 1. Clone the repository

```bash
git clone https://github.com/vdulnev/jrr.git
cd jrr/jrr_f
```

The Flutter app lives in the `jrr_f/` subdirectory of the repo. All commands below assume you are inside `jrr_f/`.

## 2. Fetch dependencies

```bash
flutter pub get
```

This downloads Dart packages and runs the build_runner steps wired into the project.

## 3. Configure code signing

The repo's project files reference an Apple Developer team (`6742UG6L9C`) and a bundle identifier (`com.jrr.jrrf`) that belong to the original author. **You must replace them with your own** before Xcode will sign a build.

You can either edit the project in Xcode (recommended, see below) or do a one-shot find/replace:

```bash
# Pick a unique reverse-DNS bundle id you own, e.g. com.example.jrr
NEW_BUNDLE_ID="com.example.jrr"
find ios macos -name project.pbxproj -exec \
  sed -i '' "s/com\.jrr\.jrrf/${NEW_BUNDLE_ID}/g" {} +
```

You still need to set your own **Team** in Xcode — that step is interactive.

---

## 4. Build for iOS / iPadOS

### 4.1 Open the workspace

```bash
open ios/Runner.xcworkspace
```

> **Important:** open the `.xcworkspace`, **not** the `.xcodeproj`. Flutter's CocoaPods integration only works through the workspace.

### 4.2 Sign the app with your Apple ID

1. In Xcode, add your Apple ID under **Xcode → Settings → Accounts → +** if you haven't already. A free personal account is sufficient.
2. In the Project Navigator (left sidebar), select **Runner** → **Runner** target → **Signing & Capabilities**.
3. Tick **Automatically manage signing**.
4. Set **Team** to your personal team (it appears as *"Your Name (Personal Team)"* for free accounts).
5. Change **Bundle Identifier** to something globally unique, e.g. `com.<your-name>.jrr`. Free Apple IDs cannot reuse identifiers already registered by someone else.
6. Repeat steps 2–5 for the **RunnerTests** target if you plan to run tests (you can skip otherwise).

### 4.3 Connect your device

1. Plug your iPhone/iPad into the Mac with a USB cable.
2. On the device, tap **Trust this computer** when prompted.
3. Enable **Developer Mode** on iOS 16+: **Settings → Privacy & Security → Developer Mode → On**, then reboot.
4. In Xcode's top toolbar, pick your device from the run-destination dropdown.

### 4.4 Run

Press **▶ Run** in Xcode (or `Cmd+R`). Alternatively from the terminal:

```bash
flutter run -d <device-id>          # debug build
flutter build ipa --release         # release archive at build/ios/ipa/
```

The first run may take several minutes while CocoaPods resolves and Xcode compiles the native side.

### 4.5 Trust the developer certificate

After the first install, iOS refuses to launch the app until you trust its certificate:

**Settings → General → VPN & Device Management → Developer App → [your Apple ID] → Trust**.

### 4.6 Free-account caveats

- Apps signed with a **free Apple ID expire after 7 days**. Reinstall from Xcode to refresh.
- A free account can have at most **3 sideloaded apps** on a device at once.
- A paid [Apple Developer Program](https://developer.apple.com/programs/) membership ($99/yr) removes both limits and lets you distribute `.ipa` files to other devices.

---

## 5. Build for macOS

### 5.1 Open the workspace

```bash
open macos/Runner.xcworkspace
```

### 5.2 Configure signing

In Xcode, select the **Runner** target → **Signing & Capabilities** and choose one of:

- **Sign to Run Locally** — easiest. The app runs only on this Mac, no Apple ID needed. Good for a personal install.
- **Development team** — use your Apple ID team for a personal team-signed build that runs on machines logged into the same Apple ID.
- **Developer ID Application** *(paid Apple Developer Program required)* — for distribution to other Macs without Gatekeeper warnings; requires notarization.

If you want a hardened, redistributable build, follow Apple's [notarization guide](https://developer.apple.com/documentation/security/notarizing-macos-software-before-distribution) after building.

### 5.3 Build & run

From Xcode press **▶ Run**, or from the terminal:

```bash
flutter run -d macos                # debug
flutter build macos --release       # release at build/macos/Build/Products/Release/jrr_f.app
```

### 5.4 Install the release build

Copy the produced `.app` bundle to `/Applications`:

```bash
cp -R build/macos/Build/Products/Release/jrr_f.app /Applications/
```

If macOS Gatekeeper blocks the unsigned/locally-signed app on first launch:

1. Right-click the app → **Open** → **Open** in the dialog, **or**
2. **System Settings → Privacy & Security**, scroll down, click **Open Anyway** next to the blocked entry.

This is only required once per build.

---

## 6. First-run configuration

The app needs to reach a JRiver Media Center instance over the local network.

- On **iOS 14+ / iPadOS**, the system asks for **Local Network** access on first launch — tap **Allow**. If you missed the prompt, re-enable it under **Settings → Privacy & Security → Local Network → JRiver Remote**.
- On **macOS 15+**, the same Local Network prompt appears. Allow it under **System Settings → Privacy & Security → Local Network** if you need to revisit.
- Configure your MCWS server URL (default port `52199`) and credentials inside the app's Settings screen.

---

## 7. Troubleshooting

| Symptom | Fix |
|---------|-----|
| `CocoaPods could not find compatible versions for pod ...` | `cd ios && pod repo update && pod install` (same for `macos/`) |
| `No profiles for 'com.jrr.jrrf' were found` | You forgot step 3/4.2 — change bundle id and pick your own Team |
| `flutter build ios` fails with `arm64` linker errors on simulator | Run on a real device, or `flutter build ios --simulator` |
| App launches then immediately quits on iOS | Free-provisioning profile expired (7 days) — reinstall from Xcode |
| Gatekeeper says *"app is damaged"* on macOS | `xattr -dr com.apple.quarantine /Applications/jrr_f.app` |
| `flutter doctor` reports missing iOS toolchain | `sudo gem install cocoapods` and re-run `flutter doctor` |
| Build runner errors after pulling | `dart run build_runner build --delete-conflicting-outputs` |

---

## 8. Updating

To pull in upstream changes later:

```bash
git pull
flutter pub get
cd ios   && pod install && cd ..
cd macos && pod install && cd ..
```

Then rebuild from Xcode as above.

---

## License & links

- Source: <https://github.com/vdulnev/jrr>
- JRiver Media Center: <https://www.jriver.com/>
- MCWS API reference: <https://wiki.jriver.com/index.php/Web_Service_Interface>
