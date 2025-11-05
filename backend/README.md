# MindNest Backend API

AI-powered emotional meditation and sleep assistance backend service.

## Features

- **Emotion Detection**: Analyze text input to detect emotional states (anxious, sad, tired, calm, neutral)
- **AI Meditation Generation**: Create personalized meditation scripts based on emotions
- **Mood Journaling**: Track emotional progress before and after sessions
- **Guided Routines**: Pre-defined sleep and anxiety relief programs

## Tech Stack

- **Framework**: FastAPI
- **AI Services**: OpenAI GPT-5 / Anthropic Claude (for production)
- **TTS**: ElevenLabs / OpenAI TTS (for production)
- **Speech-to-Text**: OpenAI Whisper (for production)

## Setup

### 1. Install Dependencies

```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### 2. Configure Environment

```bash
cp .env.example .env
# Edit .env with your API keys
```

### 3. Run Development Server

```bash
# From backend directory
python -m uvicorn app.main:app --reload --port 8000
```

Or:

```bash
python app/main.py
```

The API will be available at: http://localhost:8000

## API Documentation

Once running, visit:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## API Endpoints

### Health Check
```
GET /
```

### Emotion Detection
```
POST /api/emotion
Content-Type: application/json

{
  "text": "I feel nervous and can't sleep tonight"
}

Response:
{
  "emotion": "anxious",
  "confidence": 0.85
}
```

### Generate Meditation
```
POST /api/meditate
Content-Type: application/json

{
  "emotion": "anxious",
  "duration_minutes": 5,
  "voice_style": "female"
}

Response:
{
  "text": "It's okay, you're safe now...",
  "audio_url": "https://cdn.mindnest.ai/audio/relax1.mp3",
  "duration_seconds": 45
}
```

### Log Mood Journal
```
POST /api/journal
Content-Type: application/json

{
  "emotion_before": "anxious",
  "emotion_after": "calm",
  "session_type": "meditation"
}

Response:
{
  "status": "logged",
  "entry_id": 42,
  "message": "Your progress has been recorded"
}
```

### Get Journal Entries
```
GET /api/journal?limit=30

Response:
[
  {
    "id": 1,
    "emotion_before": "anxious",
    "emotion_after": "calm",
    "session_type": "meditation",
    "timestamp": "2025-11-05T10:30:00"
  }
]
```

### Get Sleep Routines
```
GET /api/routines

Response:
{
  "routines": [
    {
      "id": "sleep_drift",
      "name": "Sleep Drift",
      "emoji": "🌙",
      "duration_min": 10,
      "description": "Gentle transition into deep restful sleep"
    }
  ]
}
```

## MVP vs Production

### MVP (Current)
- Simple keyword-based emotion detection
- Sample meditation scripts (no AI generation)
- Mock audio URLs
- In-memory storage

### Production Ready
To enable full production features:

1. **Uncomment AI dependencies** in `requirements.txt`:
   ```bash
   pip install openai anthropic elevenlabs
   ```

2. **Add API keys** to `.env`:
   ```
   OPENAI_API_KEY=sk-...
   ANTHROPIC_API_KEY=sk-ant-...
   ELEVENLABS_API_KEY=...
   ```

3. **Implement AI services**:
   - Update `meditation_service.py` to call GPT/Claude APIs
   - Update `emotion_service.py` to use Whisper for audio transcription
   - Implement TTS generation with ElevenLabs

4. **Add database**:
   - Uncomment SQLAlchemy in requirements
   - Create database models
   - Replace in-memory storage

## Testing

```bash
pytest
```

## Deployment

Deploy to any Python hosting service:
- **Render**: Add as Web Service
- **Railway**: Connect GitHub repo
- **Heroku**: Add Procfile
- **AWS Lambda**: Use Mangum adapter

## Architecture

```
backend/
├── app/
│   ├── main.py              # FastAPI application
│   ├── models/
│   │   └── schemas.py       # Pydantic models
│   ├── services/
│   │   ├── emotion_service.py   # Emotion detection
│   │   └── meditation_service.py # AI meditation generation
│   └── api/                 # Additional API routes
├── requirements.txt
├── .env.example
└── README.md
```

## License

MIT
