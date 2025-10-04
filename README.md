# Space2Soil

A cross-## Overview
**Space2Soil** is a Flutter-based game project. The repo is set up for multi-platform targets, so you can iterate quickly on one codebase and run it on Android, iOS, desktop, and the web.

> If you're evaluating the codebase, start in `lib/` (e.g., `main.dart`) to see the entry point and high-level app wiring.

## Downloads & Documentation

📱 **[Download APK](https://drive.google.com/drive/folders/1QdZeHxuGBeU1e4xIKe4kf62864Ytgbqs?usp=drive_link)** - Get the latest Android version

📚 **[Detailed Documentation](https://drive.google.com/drive/folders/14n7YMRyei5zy6ofnttroO1gog66ptImf?usp=drive_link)** - Complete project documentation and resources

## Featuresrm Flutter game project (mobile, desktop, and web).

> This repo contains the Flutter app sources plus platform scaffolding for Android, iOS, Web, Linux, macOS, and Windows. The code lives primarily under `lib/`, with game assets in `assets/`.

## Table of contents
- [Overview](#overview)  
- [Features](#features)  
- [Project structure](#project-structure)  
- [Getting started](#getting-started)  
- [Running the game](#running-the-game)  
- [Configuration](#configuration)  
- [Assets](#assets)  
- [Testing](#testing)  
- [Build & release](#build--release)  
- [Troubleshooting](#troubleshooting)  
- [Roadmap](#roadmap)  
- [Contributing](#contributing)  
- [Acknowledgements](#acknowledgements)  
- [License](#license)

## Overview
**Space2Soil** is a Flutter-based game project. The repo is set up for multi-platform targets, so you can iterate quickly on one codebase and run it on Android, iOS, desktop, and the web.

> If you’re evaluating the codebase, start in `lib/` (e.g., `main.dart`) to see the entry point and high-level app wiring.

## Features
- Single codebase with Flutter/Dart
- Multi-platform targets out of the box (Android, iOS, Web, Windows, macOS, Linux)
- Organized `assets/` directory for art, audio, and data
- Unit test scaffolding under `test/`

*(Add gameplay-specific bullets here: e.g., “resource collection”, “levels”, “leaderboard,” etc.)*

## Project structure
```
Space2Soil/
├─ lib/                 # Dart source (entry point, game logic, UI)
├─ assets/              # Images, audio, video, fonts, data
├─ test/                # Dart tests
│
├─ android/             # Android platform wrapper
├─ ios/                 # iOS platform wrapper
├─ web/                 # Web runner + index.html
├─ linux/               # Linux desktop wrapper
├─ macos/               # macOS desktop wrapper
├─ windows/             # Windows desktop wrapper
│
├─ pubspec.yaml         # Flutter/Dart dependencies & asset registration
├─ analysis_options.yaml# Lints
└─ README.md
```

## Getting started

### Prerequisites
- **Flutter SDK** installed and on your PATH (3.x recommended)  
- A working **Dart** toolchain (bundled with Flutter)  
- Platform toolchains as needed:
  - Android Studio + Android SDK (Android)
  - Xcode (iOS/macOS)
  - Desktop build tooling for your OS
  - Any web-capable browser (for web)

Check your environment:
```bash
flutter doctor
```

### Install dependencies
```bash
flutter pub get
```

## Running the game

### Android (device or emulator)
```bash
flutter run -d android
```

### iOS (simulator)
```bash
flutter run -d ios
```
> On first run you may need to open `ios/Runner.xcworkspace` in Xcode and set a signing team.

### Web (Chrome)
```bash
flutter run -d chrome
```

### Windows / macOS / Linux
```bash
# pick your desktop device id from `flutter devices`
flutter run -d windows   # or macos / linux
```

## Configuration

### Dependencies
All package dependencies are declared in `pubspec.yaml`. Update them with:
```bash
flutter pub upgrade
```

### App entry point
- **`lib/main.dart`** is the typical entry point for the Flutter app.
- Additional modules/components (e.g., game engine classes, scenes, services) should be under `lib/`.

*(If you’re using a game engine like Flame, note it here with a short explanation of where the `Game` class lives.)*

## Assets
Register new images/audio/fonts in `pubspec.yaml` under `flutter.assets` (and `fonts` if applicable), then load them from code. Keep large or grouped resources in subfolders:
```
assets/
  images/
  audio/
  video/
  data/
  fonts/
```

## Testing
Run all tests:
```bash
flutter test
```

Add tests under `test/`, mirroring the `lib/` structure.

## Build & release

### Android APK / App Bundle
```bash
# Build debug APK
flutter build apk

# Build release app bundle
flutter build appbundle
```

### iOS
```bash
flutter build ipa
```
> You’ll need a valid signing profile/certificates and to configure targets in Xcode.

### Web
```bash
flutter build web
# Outputs to build/web/
```

### Desktop
```bash
flutter build windows   # or macos / linux
```

## Troubleshooting
- **Toolchain issues**: Run `flutter doctor` and resolve any red items.
- **Missing assets**: Ensure they’re listed under `assets:` in `pubspec.yaml`, then run `flutter pub get`.
- **iOS signing**: Open the Xcode workspace in `ios/` and set a team + bundle id.
- **Web CORS / cache**: Hard refresh or run with `--web-renderer canvaskit` if you see rendering issues.

## Roadmap
- [ ] Define core gameplay loop & document it in README
- [ ] Add screenshots / GIFs
- [ ] Wire up CI (Flutter analyze/test on PR)
- [ ] Configure code coverage
- [ ] Publish playable web demo (GitHub Pages or Firebase Hosting)

## Contributing
1. Fork the repo
2. Create a feature branch: `git checkout -b feature/your-thing`
3. Commit changes: `git commit -m "feat: describe your change"`
4. Push: `git push origin feature/your-thing`
5. Open a Pull Request

Run checks before pushing:
```bash
flutter analyze
flutter test
```

## Acknowledgements
- Built with [Flutter](https://flutter.dev/) and Dart

## License
Add a license file (e.g., MIT) at the repository root, then reference it here.
