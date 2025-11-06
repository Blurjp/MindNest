@echo off
REM MindNest Setup Script for Windows
REM Automates the setup of backend and frontend

setlocal enabledelayedexpansion

echo.
echo ========================================
echo    MindNest Setup Script (Windows)
echo ========================================
echo.

REM Check Python
echo [INFO] Checking prerequisites...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python not found. Please install Python 3.9 or higher.
    echo Download from: https://www.python.org/downloads/
    pause
    exit /b 1
)

for /f "tokens=*" %%i in ('python --version') do set PYTHON_VERSION=%%i
echo [SUCCESS] Python found: %PYTHON_VERSION%

REM Check pip
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] pip not found. Please install pip.
    pause
    exit /b 1
)
echo [SUCCESS] pip found

REM Check Flutter
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Flutter not found. Frontend setup will be skipped.
    echo Install Flutter from: https://flutter.dev/docs/get-started/install
    set SKIP_FLUTTER=1
) else (
    for /f "tokens=*" %%i in ('flutter --version ^| findstr /C:"Flutter"') do set FLUTTER_VERSION=%%i
    echo [SUCCESS] Flutter found: !FLUTTER_VERSION!
    set SKIP_FLUTTER=0
)

echo.
echo ========================================
echo    Setting up Backend (FastAPI)
echo ========================================
echo.

cd backend

echo [INFO] Creating Python virtual environment...
python -m venv venv
if %errorlevel% neq 0 (
    echo [ERROR] Failed to create virtual environment
    pause
    exit /b 1
)
echo [SUCCESS] Virtual environment created

echo [INFO] Activating virtual environment...
call venv\Scripts\activate.bat

echo [INFO] Installing Python dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Backend dependencies installed

echo [INFO] Creating .env file from template...
if not exist .env (
    copy .env.example .env
    echo [SUCCESS] .env file created (please update with your API keys)
) else (
    echo [WARNING] .env file already exists, skipping
)

cd ..

if %SKIP_FLUTTER% equ 0 (
    echo.
    echo ========================================
    echo    Setting up Frontend (Flutter)
    echo ========================================
    echo.

    cd frontend

    echo [INFO] Running Flutter pub get...
    flutter pub get
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install Flutter dependencies
        cd ..
        pause
        exit /b 1
    )
    echo [SUCCESS] Flutter dependencies installed

    echo [INFO] Checking Flutter setup...
    flutter doctor

    cd ..
)

echo.
echo ========================================
echo         Setup Complete!
echo ========================================
echo.
echo Next steps:
echo.
echo 1. Start the Backend:
echo    cd backend
echo    venv\Scripts\activate.bat
echo    python app\main.py
echo.
echo 2. Test the API (in another terminal):
echo    cd backend
echo    venv\Scripts\activate.bat
echo    python test_api.py
echo.

if %SKIP_FLUTTER% equ 0 (
    echo 3. Update Frontend API URL:
    echo    Edit frontend\lib\services\api_service.dart
    echo    Update baseUrl to match your backend:
    echo    - iOS Simulator: http://localhost:8000
    echo    - Android Emulator: http://10.0.2.2:8000
    echo    - Physical Device: http://YOUR_COMPUTER_IP:8000
    echo.
    echo 4. Start the Flutter app:
    echo    cd frontend
    echo    flutter run
    echo.
)

echo Documentation:
echo    - Main README: README.md
echo    - Backend docs: backend\README.md
echo    - Frontend docs: frontend\README.md
echo    - API docs (after starting): http://localhost:8000/docs
echo.
echo Happy meditating! 🧘💜
echo.
pause
