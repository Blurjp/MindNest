@echo off
REM Quick script to run the MindNest backend

echo ========================================
echo    Starting MindNest Backend API
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "backend\venv" (
    echo Virtual environment not found. Please run setup.bat first.
    pause
    exit /b 1
)

REM Navigate to backend
cd backend

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

echo.
echo Starting FastAPI server...
echo.
echo API will be available at:
echo   - http://localhost:8000
echo   - http://localhost:8000/docs (Swagger UI)
echo.
echo Press Ctrl+C to stop the server
echo.

REM Run the server
python app\main.py
