# SAT-PlantScan Flutter App

Open this folder (`app/`) in Android Studio or VS Code.

## Commands

```bash
flutter pub get
flutter run
flutter test
flutter build apk --release
```

## First-time Android setup

1. Copy `android/local.properties.example` → `android/local.properties`
2. Set `flutter.sdk` and `sdk.dir`
3. Run `flutter pub get`

## Run in Android Studio (not Windows desktop)

This project targets **Android** (and iOS). There is **no** `windows/` folder, so `flutter run -d windows` fails with *No Windows desktop project configured*.

1. Open the **`app/`** folder as the Flutter project root.
2. Start an **Android Virtual Device** (Device Manager → Play on an emulator).
3. In the toolbar **device dropdown**, choose the emulator (e.g. `sdk gphone64 x86 64`), **not** “Windows (desktop)”.
4. Run **main.dart**.

From a terminal (in `app/`):

```bash
flutter run -d emulator-5554
```

Use `flutter devices` to see the exact device id.

## Assets

Knowledge base and logo are synced from repository root via `scripts/setup_app.ps1`.

## Vision model

Train the TFLite model from `/ml` then copy or export to `assets/models/sat_plantscan_cassava.tflite`.

Without the model file, the app runs with a color-heuristic fallback for development.
