# Script to build JBR Minpo Mobile APK
# Run this from the project root

$PROJECT_ROOT = "Minpo_mobile"

Write-Host "🚀 Starting Flutter Build APK..." -ForegroundColor Cyan

cd $PROJECT_ROOT

# Clean build
flutter clean

# Upgrade packages if needed
flutter pub get

# Build APK (Splitted per ABI for smaller size)
flutter build apk --split-per-abi

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Build Success!" -ForegroundColor Green
    Write-Host "📂 APK location: $PROJECT_ROOT\build\app\outputs\flutter-apk\" -ForegroundColor Yellow
} else {
    Write-Host "❌ Build Failed!" -ForegroundColor Red
}

pause
