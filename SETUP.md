# 🚀 MindNest Quick Setup Guide

Get MindNest running in **under 5 minutes**!

---

## 📋 Prerequisites

Before you start, make sure you have:

- **Python 3.9+** → [Download](https://www.python.org/downloads/)
- **Flutter 3.0+** → [Install Guide](https://flutter.dev/docs/get-started/install)
- **Git** → [Download](https://git-scm.com/)

---

## ⚡ Quick Setup (Automated)

### Option 1: Using Setup Script (Recommended)

**Linux/Mac:**
```bash
# Clone the repository
git clone <your-repo-url>
cd MindNest

# Make script executable
chmod +x setup.sh

# Run setup
./setup.sh
```

**Windows:**
```cmd
REM Clone the repository
git clone <your-repo-url>
cd MindNest

REM Run setup
setup.bat
```

The script will:
- ✅ Check prerequisites
- ✅ Create Python virtual environment
- ✅ Install backend dependencies
- ✅ Install Flutter dependencies
- ✅ Create .env file
- ✅ Show next steps

---

## 🔧 Manual Setup (Step by Step)

If you prefer manual setup:

### Step 1: Backend Setup

```bash
# Navigate to backend
cd backend

# Create virtual environment
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate  # Linux/Mac
# OR
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt

# Create environment file
cp .env.example .env
```

### Step 2: Frontend Setup

```bash
# Navigate to frontend
cd frontend

# Install Flutter dependencies
flutter pub get

# Check Flutter setup
flutter doctor
```

---

## 🎬 Running the App

### 1. Start Backend API

```bash
cd backend
source venv/bin/activate  # Windows: venv\Scripts\activate
python app/main.py
```

✅ Backend running at: **http://localhost:8000**
📚 API docs at: **http://localhost:8000/docs**

### 2. Test API (Optional)

In a new terminal:

```bash
cd backend
source venv/bin/activate  # Windows: venv\Scripts\activate
python test_api.py
```

### 3. Configure Frontend API URL

Edit `frontend/lib/services/api_service.dart`:

```dart
// Change this line based on your setup:
static const String baseUrl = 'http://localhost:8000';
```

**URL Guide:**
- iOS Simulator: `http://localhost:8000`
- Android Emulator: `http://10.0.2.2:8000`
- Physical Device: `http://YOUR_COMPUTER_IP:8000`

**Finding your computer IP:**
```bash
# Mac/Linux
ifconfig | grep "inet " | grep -v 127.0.0.1

# Windows
ipconfig | findstr IPv4
```

### 4. Run Flutter App

```bash
cd frontend
flutter run
```

Select your target device (iOS simulator, Android emulator, or physical device).

---

## 🧪 Verify Installation

### Backend Test

Visit http://localhost:8000/docs and try the `/api/emotion` endpoint:

```json
POST /api/emotion
{
  "text": "I feel anxious and worried"
}

Expected Response:
{
  "emotion": "anxious",
  "confidence": 0.85
}
```

### Frontend Test

1. Open app on device/simulator
2. Tap "😔 Anxious" button
3. Wait for meditation to generate
4. See breathing animation
5. Complete session
6. Check journal for entry

---

## 🐛 Troubleshooting

### Backend Issues

**"ModuleNotFoundError"**
```bash
# Make sure virtual environment is activated
source venv/bin/activate  # or venv\Scripts\activate on Windows

# Reinstall dependencies
pip install -r requirements.txt
```

**"Address already in use (port 8000)"**
```bash
# Change port in app/main.py or kill process using port 8000
# Linux/Mac
lsof -ti:8000 | xargs kill -9

# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Frontend Issues

**"Cannot connect to backend"**
- Ensure backend is running
- Check API URL in `api_service.dart`
- For physical device, use computer's IP address
- Check firewall settings

**"Flutter dependencies failed"**
```bash
# Clean and reinstall
flutter clean
flutter pub get
```

**"No devices found"**
```bash
# Check connected devices
flutter devices

# For iOS simulator
open -a Simulator

# For Android emulator
flutter emulators
flutter emulators --launch <emulator_id>
```

---

## 📱 Platform-Specific Setup

### iOS

1. Install Xcode from App Store
2. Install CocoaPods:
   ```bash
   sudo gem install cocoapods
   ```
3. Open iOS Simulator:
   ```bash
   open -a Simulator
   ```

### Android

1. Install Android Studio
2. Install Android SDK
3. Create AVD (Android Virtual Device):
   ```bash
   flutter emulators --create
   ```
4. Start emulator:
   ```bash
   flutter emulators --launch <emulator_id>
   ```

---

## 🎯 Next Steps

Once everything is running:

1. **Explore the API**
   Visit http://localhost:8000/docs

2. **Try different emotions**
   Test with: anxious, sad, tired, calm, neutral

3. **Check mood journal**
   Complete sessions and view progress

4. **Customize**
   Edit meditation scripts in `backend/app/services/meditation_service.py`

5. **Read documentation**
   - `README.md` - Full project overview
   - `backend/README.md` - Backend details
   - `frontend/README.md` - Frontend guide

---

## 🔐 Production Setup (Optional)

For production deployment:

### 1. Add API Keys

Edit `backend/.env`:

```bash
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
ELEVENLABS_API_KEY=...
```

### 2. Install AI Libraries

```bash
cd backend
source venv/bin/activate
pip install openai anthropic elevenlabs transformers
```

### 3. Enable Real AI Features

Update `backend/app/services/meditation_service.py` to call real APIs instead of using sample scripts.

---

## 📞 Need Help?

- **Documentation**: Check `README.md` files
- **API Issues**: Run `python test_api.py`
- **Flutter Issues**: Run `flutter doctor -v`
- **GitHub Issues**: [Create an issue](https://github.com/yourusername/mindnest/issues)

---

## ✅ Quick Checklist

- [ ] Python 3.9+ installed
- [ ] Flutter 3.0+ installed
- [ ] Backend virtual environment created
- [ ] Backend dependencies installed
- [ ] Frontend dependencies installed (`flutter pub get`)
- [ ] Backend running on port 8000
- [ ] API test passed
- [ ] Frontend API URL configured
- [ ] Flutter app running on device/simulator
- [ ] First meditation session completed

---

**Estimated Setup Time:** 3-5 minutes
**Difficulty:** Beginner-friendly

Happy meditating! 🧘💜
