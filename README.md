# SAT-PlantScan

**SAT-PlantScan** is an open-source mobile platform by [SolAgriTech (SAT)](https://github.com/SolAgriTech-IT) for intelligent diagnosis of tropical plant diseases. Version 1 focuses on **cassava**, with an architecture designed to scale to hundreds of crops.

## Features

- Bilingual UI (French / English)
- Interactive **pre-diagnosis questionnaire** (dichotomous key)
- Guided **photo capture** (leaf, leaflet, stem, root)
- On-device **TensorFlow Lite** vision model
- **Fused diagnosis** (questionnaire + AI)
- Structured **disease sheets** with prevention and control recommendations
- **Offline** operation after installation
- Local diagnosis **history**

## Repository structure

```
SAT-PlantScan/
├── app/                  # Flutter mobile application (Android + iOS)
├── knowledge_base/       # Normalized crop/disease JSON knowledge
├── ml/                   # Dataset prep, training, TFLite export
├── releases/             # Pre-built Android APK for direct install
├── Ouvrages/             # Scientific reference documents
├── docs/                 # Technical documentation
├── Logo.jpg              # Official SolAgriTech logo
└── scripts/              # Setup utilities
```

> **Training images:** the `Cultures/` tree stays **local only** (gitignored). Clone the repo for app + knowledge base; keep `Cultures/` on your machine for ML training (`ml/scripts/prepare_dataset.py`).

## Install on your Android phone

### Option A — Download from GitHub (recommended)

1. On your phone or PC, open this repository on GitHub.
2. Go to **`releases/SAT-PlantScan-android-release.apk`** (or download the latest APK from the `releases/` folder).
3. Transfer the file to the phone if you downloaded it on PC (USB, cloud, email).
4. On the phone, open the APK file.
5. If Android asks, allow **Install unknown apps** for your browser or file manager (Settings → Security / Apps).
6. Confirm installation, then open **SAT-PlantScan**.

### Option B — USB (`adb`)

With [Android platform tools](https://developer.android.com/tools/releases/platform-tools) and USB debugging enabled:

```powershell
adb install -r releases\SAT-PlantScan-android-release.apk
```

### Option C — Build yourself

See [docs/BUILD_APK.md](docs/BUILD_APK.md) and run `.\scripts\build_apk.ps1`. Output: `app/build/app/outputs/flutter-apk/app-release.apk`.

**Requirements:** Android 7.0+ (API 24+ recommended). Camera and storage permissions are requested when you capture photos for diagnosis.

## Quick start — mobile app

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.19+
- Android Studio (for APK)
- Xcode (optional, for iOS on macOS)

### Setup

```powershell
# From repository root
.\scripts\setup_app.ps1
```

Or manually:

```powershell
cd app
flutter pub get
flutter run
```

### Build APK (Android)

See the full guide: **[docs/BUILD_APK.md](docs/BUILD_APK.md)**

```powershell
.\scripts\build_apk.ps1
```

**APK location after build:**

`app/build/app/outputs/flutter-apk/app-release.apk`

A copy for end users is kept at **`releases/SAT-PlantScan-android-release.apk`** (see [Install on your Android phone](#install-on-your-android-phone)).

Open **`app/`** as the project root in Android Studio. Set `android/local.properties`:

```properties
flutter.sdk=C:\\path\\to\\flutter
sdk.dir=C:\\Users\\YOU\\AppData\\Local\\Android\\Sdk
```

## Quick start — ML training

```powershell
cd ml
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt

python scripts/prepare_dataset.py
python scripts/train.py
python scripts/export_tflite.py
```

This exports `sat_plantscan_cassava.tflite` into `app/assets/models/`.

> **Note:** With ~230 images, data augmentation is enabled automatically. Generative synthetic images are **not** used by default to avoid bias.

## Diagnosis workflow

1. Select crop (Cassava)
2. Answer biotic/abiotic questionnaire → pre-diagnosis scores
3. Capture photo guided by suspected organs
4. TFLite model classifies image
5. Scores merged: `P = 1 - (1 - P_pre)(1 - P_vision)`
6. Recommendations displayed from knowledge base

## Adding a new crop

1. Add local training images under `Cultures/<Crop>/` (not committed to Git)
2. Add JSON under `knowledge_base/crops/<crop_id>/`
3. Register in `knowledge_base/crops/registry.json`
4. Sync assets to `app/assets/knowledge/crops/<crop_id>/`
5. Train and export a TFLite model

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Scientific references

- `/Ouvrages` (FAO, IPM guides, cassava field manuals)
- [FAO Cassava diseases](https://www.fao.org/agriculture/crops/thematic-sitemap/theme/pests/cassava-diseases/en/)

## Contributing

1. Fork the repository
2. Create a branch: `feature/my-feature`
3. Commit with clear messages
4. Open a Pull Request to `develop`

## License

MIT — see [LICENSE](LICENSE).

## SolAgriTech

SAT-PlantScan is part of the SAT digital ecosystem for smart, sustainable agriculture.
