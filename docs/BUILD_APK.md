# Guide de compilation APK — SAT-PlantScan

Ce guide explique **exactement** où trouver le fichier `.apk` et comment le produire avec **Android Studio** ou la **ligne de commande**.

---

## Prérequis (une seule fois)

1. **Flutter SDK** : https://docs.flutter.dev/get-started/install/windows  
   - Ou utilisez le SDK déjà cloné dans :  
     `D:\New_Start_2024\Candidatures\SOL_AGRI_TECH\tools\flutter`

2. **Android Studio** : https://developer.android.com/studio  
   - Installez le **Android SDK** via le SDK Manager (API 34 recommandée).

3. Vérifiez l'environnement :

```powershell
flutter doctor
flutter doctor --android-licenses
```

---

## Étape 1 — Préparer le projet

Depuis la racine du dépôt :

```powershell
.\scripts\setup_app.ps1
```

Ou manuellement :

```powershell
cd D:\New_Start_2024\Candidatures\SOL_AGRI_TECH\SAT-PlantScan\app
flutter pub get
```

### Fichier `local.properties` (obligatoire pour Android Studio)

Créez `app/android/local.properties` :

```properties
flutter.sdk=D:\\New_Start_2024\\Candidatures\\SOL_AGRI_TECH\\tools\\flutter
sdk.dir=C:\\Users\\VOTRE_USER\\AppData\\Local\\Android\\Sdk
```

Adaptez les chemins à votre machine.

---

## Étape 2 — Compiler l'APK (ligne de commande)

```powershell
cd D:\New_Start_2024\Candidatures\SOL_AGRI_TECH\SAT-PlantScan\app
flutter build apk --release
```

### Emplacement exact de l'APK release

```
D:\New_Start_2024\Candidatures\SOL_AGRI_TECH\SAT-PlantScan\app\build\app\outputs\flutter-apk\app-release.apk
```

### APK debug (tests rapides)

```powershell
flutter build apk --debug
```

Fichier :

```
app\build\app\outputs\flutter-apk\app-debug.apk
```

---

## Étape 3 — Compiler avec Android Studio

1. Ouvrez **Android Studio**.
2. **File → Open** → sélectionnez le dossier **`app`** (pas la racine du repo).
3. Attendez l'indexation Gradle / Flutter.
4. Branchez un smartphone Android (mode développeur + débogage USB) **ou** lancez un émulateur.
5. Pour tester directement : bouton **Run ▶** (triangle vert).
6. Pour générer l'APK :
   - Ouvrez le terminal intégré et exécutez :  
     `flutter build apk --release`
   - **Ou** menu **Build → Flutter → Build APK** (selon version du plugin Flutter).

L'APK sera au même emplacement :

`app/build/app/outputs/flutter-apk/app-release.apk`

---

## Étape 4 — Installer sur smartphone

### Option A — USB

```powershell
adb install app\build\app\outputs\flutter-apk\app-release.apk
```

### Option B — Copie manuelle

1. Copiez `app-release.apk` sur le téléphone (USB, email, Drive…).
2. Ouvrez le fichier sur le téléphone.
3. Autorisez **Sources inconnues** si Android le demande.

---

## Étape 5 — Tester le parcours complet

1. Splash SolAgriTech → Tableau de bord  
2. Démarrer un diagnostic → Manioc  
3. Questionnaire biotique / abiotique  
4. Capture photo (feuille / tige / racine selon suspicion)  
5. Résultat fusionné (pré-diagnostic + vision)  
6. Recommandations + fiche maladie  
7. Historique local  

---

## Modèle IA (optionnel mais recommandé)

Sans modèle TFLite, l'app fonctionne avec un **fallback heuristique** (paramètres → statut du modèle).

Pour la vision complète :

```powershell
cd ml
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
python scripts/prepare_dataset.py
python scripts/train.py
python scripts/export_tflite.py
cd ..\app
flutter build apk --release
```

Le modèle est copié dans `app/assets/models/sat_plantscan_cassava.tflite`.

---

## Dépannage

| Problème | Solution |
|----------|----------|
| `flutter.sdk not set` | Créer `android/local.properties` |
| `No Android SDK` | Installer Android Studio + SDK |
| APK non signé pour Play Store | Utiliser une clé release (`key.properties`) — hors scope v1 test |
| Build lent | Première compilation : 5–15 min normal |

---

## Script automatique

```powershell
.\scripts\build_apk.ps1
```

Affiche le chemin complet de l'APK à la fin.
