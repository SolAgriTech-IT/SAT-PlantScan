#!/usr/bin/env pwsh
# SAT-PlantScan app bootstrap script

$Root = Split-Path -Parent $PSScriptRoot
$App = Join-Path $Root "app"

Write-Host "Syncing assets..."
New-Item -ItemType Directory -Force -Path "$App\assets\logo", "$App\assets\knowledge\crops\cassava" | Out-Null
Copy-Item "$Root\Logo.jpg" "$App\assets\logo\logo.jpg" -Force
Copy-Item "$Root\knowledge_base\crops\cassava\*" "$App\assets\knowledge\crops\cassava\" -Force

$FlutterCandidates = @(
    (Join-Path (Split-Path $Root -Parent) "tools\flutter\bin\flutter.bat"),
    "$env:LOCALAPPDATA\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat"
)
$Flutter = $FlutterCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if ($Flutter) {
    Push-Location $App
    & $Flutter pub get
    if (-not (Test-Path "android\gradle\wrapper\gradle-wrapper.jar")) {
        Write-Host "Generating platform folders with flutter create..."
        & $Flutter create . --project-name sat_plantscan --org com.solagritech --platforms=android,ios
    }
    Pop-Location
    Write-Host "Done. Flutter: $Flutter"
    Write-Host "Build APK: .\scripts\build_apk.ps1"
} else {
    Write-Host "Flutter SDK not found in PATH."
    Write-Host "Install Flutter, then run: cd app && flutter pub get && flutter run"
}
