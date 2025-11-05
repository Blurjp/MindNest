# 🧘 MindNest - AI Emotional Meditation App

> **Transform anxiety into calm. Turn sleepless nights into peaceful rest.**

MindNest is an AI-powered meditation app designed specifically for **sleep and anxiety relief**. Using emotion detection and personalized AI-generated meditation scripts, MindNest creates a deeply calming, minimal, and emotionally warm experience.

![Version](https://img.shields.io/badge/version-1.0.0--MVP-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter)
![Python](https://img.shields.io/badge/Python-3.9+-3776AB?logo=python)
![License](https://img.shields.io/badge/license-MIT-green)

---

## ✨ Features

### 🎯 Core MVP Features

1. **Emotion Detection**
   - Voice or text input
   - Detects: anxious, sad, tired, calm, neutral
   - Simple keyword matching (production: Whisper + Hume AI)

2. **AI-Powered Meditation**
   - Personalized scripts based on your emotional state
   - Calm, rhythmic language (under 10 words per sentence)
   - 30-60 second guided sessions
   - Production-ready prompts for GPT-5/Claude

3. **Sleep Routines**
   - 🌙 **Sleep Drift** (10 min)
   - 🌊 **Calm Waves** (5 min)
   - ☁️ **Anxiety Release** (7 min)
   - Each with breathing exercises and ambient sounds

4. **Mood Journaling**
   - Track emotions before & after sessions
   - Weekly progress charts
   - Improvement percentage calculation
   - Local SQLite storage

5. **Beautiful UI**
   - Soft blue/lavender gradients
   - Breathing circle animations
   - Minimal, calming design
   - Dark mode support

---

## 🏗️ Architecture

```
MindNest/
├── backend/              # FastAPI REST API
│   ├── app/
│   │   ├── main.py       # API endpoints
│   │   ├── models/       # Pydantic schemas
│   │   └── services/     # Business logic
│   │       ├── emotion_service.py
│   │       └── meditation_service.py
│   └── requirements.txt
│
├── frontend/             # Flutter mobile app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/       # Data models
│   │   ├── screens/      # UI screens
│   │   │   ├── home_screen.dart
│   │   │   ├── session_screen.dart
│   │   │   ├── journal_screen.dart
│   │   │   ├── settings_screen.dart
│   │   │   └── routines_screen.dart
│   │   └── services/     # API & DB services
│   └── pubspec.yaml
│
└── README.md
```

---

## 🚀 Quick Start

### Prerequisites

- **Backend**: Python 3.9+
- **Frontend**: Flutter 3.0+, Dart 3.0+
- **Optional**: OpenAI API key, ElevenLabs API key (for production)

### 1. Start Backend

```bash
# Navigate to backend
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run server
python app/main.py
# API runs at http://localhost:8000
```

Visit http://localhost:8000/docs for Swagger UI.

### 2. Start Frontend

```bash
# Navigate to frontend
cd frontend

# Install dependencies
flutter pub get

# Update API URL in lib/services/api_service.dart
# iOS: http://localhost:8000
# Android: http://10.0.2.2:8000

# Run app
flutter run
```

---

## 📱 Screens

### 1. Home Screen
- **Greeting**: "Hi, how are you feeling today?"
- **Input Options**:
  - Text field: "Tell me how you feel..."
  - 4 emotion buttons: 😔 Anxious | 😴 Tired | 🙂 Calm | 😢 Sad
- **Navigation**: Journal, Routines

### 2. Session Screen
- **Breathing Animation**: Pulsing circle (4-second cycle)
- **Subtitle Text**: Auto-scrolling meditation script
- **Controls**: Play/Pause, Progress indicator
- **Completion Survey**: "How do you feel now?"

### 3. Journal Screen
- **Weekly Progress**: Improvement percentage card
- **Mood Chart**: 7-day trend (before vs after)
- **Recent Entries**: List with emoji transitions

### 4. Settings Screen
- **Voice Style**: Male / Female
- **Dark Mode**: Toggle
- **Notifications**: Daily reminders
- **Data**: Clear all

### 5. Routines Screen
- **3 Pre-defined Programs**:
  - Sleep Drift, Calm Waves, Anxiety Release
- **Details**: Duration, steps, description

---

## 🔌 API Endpoints

### `GET /`
Health check

### `POST /api/emotion`
Detect emotion from text
```json
{
  "text": "I feel nervous tonight"
}
→ Response:
{
  "emotion": "anxious",
  "confidence": 0.85
}
```

### `POST /api/meditate`
Generate personalized meditation
```json
{
  "emotion": "anxious",
  "duration_minutes": 5,
  "voice_style": "female"
}
→ Response:
{
  "text": "It's okay, you're safe now...",
  "audio_url": "https://cdn.mindnest.ai/audio/relax1.mp3",
  "duration_seconds": 45
}
```

### `POST /api/journal`
Log mood entry
```json
{
  "emotion_before": "anxious",
  "emotion_after": "calm",
  "session_type": "meditation"
}
```

### `GET /api/journal?limit=30`
Retrieve journal entries

### `GET /api/routines`
Get sleep routines list

---

## 🎨 Design Guidelines

### Color Palette
- **Primary Gradient**: `#667EEA` → `#764BA2`
- **Session Gradient**: `#4A5B8C` → `#2D3561`
- **Emotions**:
  - Anxious: `#FF6B6B`
  - Sad: `#4ECDC4`
  - Tired: `#95A5F5`
  - Calm: `#6BCF7F`

### Typography
- **Font**: Poppins (or system default)
- **Titles**: 36px bold, white
- **Body**: 16-18px regular, white/70% opacity
- **Keep sentences under 10 words for meditations**

### Animations
- **Breathing Circle**: 4-second cycle, inhale/exhale
- **Smooth Transitions**: 300ms ease-in-out
- **No jarring movements**: Maintain calm atmosphere

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter, Dart |
| **Backend** | FastAPI, Python |
| **AI Text** | GPT-5 / Claude 3.5 (production) |
| **TTS** | ElevenLabs / OpenAI TTS (production) |
| **STT** | Whisper (production) |
| **Emotion** | Hume API (production) / Keyword matching (MVP) |
| **Database** | SQLite (local) / PostgreSQL (production) |
| **Hosting** | Render, Vercel, Firebase |

---

## 📊 MVP vs Production

### MVP (Current Implementation)
✅ Keyword-based emotion detection
✅ Sample meditation scripts
✅ Mock audio URLs
✅ Local SQLite storage
✅ In-memory API storage

### Production Ready

**To enable full production features:**

1. **Add API Keys** to `backend/.env`:
   ```bash
   OPENAI_API_KEY=sk-...
   ANTHROPIC_API_KEY=sk-ant-...
   ELEVENLABS_API_KEY=...
   ```

2. **Install AI Dependencies**:
   ```bash
   pip install openai anthropic elevenlabs transformers
   ```

3. **Implement AI Services**:
   - Update `meditation_service.py` → Call GPT/Claude
   - Update `emotion_service.py` → Use Whisper
   - Implement real TTS generation

4. **Add Database**:
   - Replace in-memory storage with PostgreSQL
   - Add user authentication
   - Implement cloud sync

---

## 🧪 Testing

### Backend Tests
```bash
cd backend
pytest
```

### Frontend Tests
```bash
cd frontend
flutter test
```

### Manual Testing Flow
1. Open app → Select emotion (e.g., "Anxious")
2. Wait for meditation generation
3. Watch breathing animation
4. Complete session
5. Select "Calm" on completion
6. Check journal → See entry logged
7. View weekly progress chart

---

## 🚢 Deployment

### Backend (Render / Railway)
```bash
# Render: Auto-deploy from GitHub
# Add environment variables
# Set start command: uvicorn app.main:app --host 0.0.0.0 --port $PORT
```

### Frontend (App Stores)
```bash
# iOS
flutter build ios --release
# Open Xcode and archive

# Android
flutter build appbundle --release
# Upload to Google Play Console
```

---

## 💡 AI Meditation Prompts

### Example System Prompt (Anxious)
```
You are MindNest, a gentle AI meditation guide.
The user feels anxious. Your goal is to calm their nervous system.

Speak in calm, short, rhythmic sentences.
Guide them through:
1. Slow, deep breathing (4-4-4 box breathing)
2. Reassurance that they are safe
3. Grounding in the present moment

Use gentle, warm language. Keep sentences under 10 words.
Focus on physical sensations and safety.
Speak as if you're a caring friend, not a clinical therapist.
```

See `backend/app/services/meditation_service.py` for all emotion-specific prompts.

---

## 🎯 Success Metrics (Target)

- ✅ ≥70% of users finish first session
- ✅ ≥50% record mood twice within a week
- ✅ Average satisfaction ≥4.0/5
- ✅ 15-20% weekly improvement average

---

## 💰 Monetization (Future)

**Free Tier:**
- 1 daily AI session
- Basic journal
- Standard voice

**Pro ($4.99/month):**
- Unlimited AI sessions
- Custom voice tones
- 7-day sleep plan
- Advanced analytics
- Priority support

---

## 🗺️ Roadmap

### Phase 1 (MVP) ✅
- [x] Emotion detection (text)
- [x] Sample meditations
- [x] Mood journaling
- [x] Sleep routines
- [x] Local storage

### Phase 2 (Production)
- [ ] Real AI text generation (GPT/Claude)
- [ ] Real TTS audio (ElevenLabs)
- [ ] Voice recording (Whisper)
- [ ] User authentication
- [ ] Cloud sync

### Phase 3 (Enhanced)
- [ ] Push notifications
- [ ] Social sharing
- [ ] Apple Health integration
- [ ] Offline mode
- [ ] Background audio
- [ ] Custom routine builder

### Phase 4 (Premium)
- [ ] Subscription system
- [ ] Multiple voice styles
- [ ] Personalized sleep plans
- [ ] Advanced analytics
- [ ] Group meditations

---

## 🤝 Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Follow the design guidelines
4. Test thoroughly
5. Submit a pull request

---

## 📄 License

MIT License - See LICENSE file for details

---

## 🙏 Acknowledgments

- **Design Inspiration**: Calm, Headspace, Insight Timer
- **AI**: OpenAI (GPT), Anthropic (Claude)
- **TTS**: ElevenLabs for natural voice quality
- **Emotion Detection**: Hume AI

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/mindnest/issues)
- **Email**: support@mindnest.ai
- **Docs**: See `/backend/README.md` and `/frontend/README.md`

---

**Built with 💜 by the MindNest Team**

*Sleep better. Stress less. Find your calm.*
