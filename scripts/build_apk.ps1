#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $PSScriptRoot
$App = Join-Path $Root "app"
$FlutterCandidates = @(
    "D:\New_Start_2024\Candidatures\SOL_AGRI_TECH\tools\flutter\bin\flutter.bat",
    "$env:LOCALAPPDATA\flutter\bin\flutter.bat",
    "C:\flutter\bin\flutter.bat"
)

$Flutter = $null
foreach ($candidate in $FlutterCandidates) {
    if (Test-Path $candidate) { $Flutter = $candidate; break }
}
if (-not $Flutter) {
    $cmd = Get-Command flutter -ErrorAction SilentlyContinue
    if ($cmd) { $Flutter = $cmd.Source }
}

if (-not $Flutter) {
    Write-Error "Flutter introuvable. Installez Flutter ou clonez-le dans tools/flutter."
}

Write-Host "Using Flutter: $Flutter"
& $PSScriptRoot\setup_app.ps1

Push-Location $App
& $Flutter pub get
& $Flutter build apk --release
Pop-Location

$Apk = Join-Path $App "build\app\outputs\flutter-apk\app-release.apk"
if (Test-Path $Apk) {
    Write-Host ""
    Write-Host "APK READY:" -ForegroundColor Green
    Write-Host $Apk
    Write-Host ""
    Write-Host "Installez avec: adb install `"$Apk`""
} else {
    Write-Error "APK not found. Vérifiez flutter doctor."
}
