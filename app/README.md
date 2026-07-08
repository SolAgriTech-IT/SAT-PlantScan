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

## Assets

Knowledge base and logo are synced from repository root via `scripts/setup_app.ps1`.

## Vision model

Train the TFLite model from `/ml` then copy or export to `assets/models/sat_plantscan_cassava.tflite`.

Without the model file, the app runs with a color-heuristic fallback for development.
