@echo off
REM Quick script to run the MindNest Flutter app

echo ========================================
echo    Starting MindNest Flutter App
echo ========================================
echo.

REM Check if Flutter is installed
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Flutter not found. Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

REM Navigate to frontend
cd frontend

REM Check for dependencies
if not exist ".dart_tool" (
    echo Dependencies not found. Running flutter pub get...
    flutter pub get
    echo.
)

echo Starting Flutter app...
echo.
echo Available devices:
flutter devices
echo.
echo The app will launch on your selected device.
echo.
echo IMPORTANT: Make sure the backend is running at http://localhost:8000
echo Run in another terminal: run-backend.bat
echo.

REM Run the app
flutter run
