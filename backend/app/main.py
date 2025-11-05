"""
MindNest API - Main FastAPI Application
AI-powered emotional meditation app backend
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime
import os

from app.services.emotion_service import EmotionService
from app.services.meditation_service import MeditationService
from app.models.schemas import (
    EmotionRequest,
    EmotionResponse,
    MeditationRequest,
    MeditationResponse,
    JournalRequest,
    JournalResponse,
    JournalEntry
)

app = FastAPI(
    title="MindNest API",
    description="AI-powered emotional meditation and sleep assistance",
    version="1.0.0"
)

# CORS configuration for mobile app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize services
emotion_service = EmotionService()
meditation_service = MeditationService()

# In-memory storage for MVP (replace with database later)
journal_storage: List[dict] = []


@app.get("/")
async def root():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "service": "MindNest API",
        "version": "1.0.0"
    }


@app.post("/api/emotion", response_model=EmotionResponse)
async def detect_emotion(request: EmotionRequest):
    """
    Detect emotion from text or audio input

    Emotions: anxious, sad, tired, calm, neutral
    """
    try:
        emotion = await emotion_service.detect_emotion(
            text=request.text,
            audio_url=request.audio_url
        )

        return EmotionResponse(
            emotion=emotion,
            confidence=0.85  # Mock confidence for MVP
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/meditate", response_model=MeditationResponse)
async def generate_meditation(request: MeditationRequest):
    """
    Generate personalized meditation script and audio

    Returns both text and audio URL for TTS output
    """
    try:
        result = await meditation_service.generate_meditation(
            emotion=request.emotion,
            duration_minutes=request.duration_minutes,
            voice_style=request.voice_style
        )

        return MeditationResponse(
            text=result["text"],
            audio_url=result["audio_url"],
            duration_seconds=result["duration_seconds"]
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/journal", response_model=JournalResponse)
async def log_mood(request: JournalRequest):
    """
    Log user mood before and after meditation session
    """
    try:
        entry = {
            "id": len(journal_storage) + 1,
            "emotion_before": request.emotion_before,
            "emotion_after": request.emotion_after,
            "session_type": request.session_type,
            "timestamp": datetime.utcnow().isoformat()
        }

        journal_storage.append(entry)

        return JournalResponse(
            status="logged",
            entry_id=entry["id"],
            message="Your progress has been recorded"
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/journal", response_model=List[JournalEntry])
async def get_journal_entries(limit: int = 30):
    """
    Retrieve recent journal entries for progress tracking
    """
    try:
        # Return most recent entries
        entries = journal_storage[-limit:] if len(journal_storage) > limit else journal_storage
        return [JournalEntry(**entry) for entry in reversed(entries)]
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/routines")
async def get_sleep_routines():
    """
    Get predefined guided meditation routines
    """
    return {
        "routines": [
            {
                "id": "sleep_drift",
                "name": "Sleep Drift",
                "emoji": "🌙",
                "duration_min": 10,
                "description": "Gentle transition into deep restful sleep",
                "steps": [
                    "Deep breathing exercise",
                    "Progressive muscle relaxation",
                    "Guided visualization with ambient rain sounds"
                ]
            },
            {
                "id": "calm_waves",
                "name": "Calm Waves",
                "emoji": "🌊",
                "duration_min": 5,
                "description": "Quick stress relief and centering",
                "steps": [
                    "Box breathing technique",
                    "Ocean wave visualization",
                    "Peaceful affirmations"
                ]
            },
            {
                "id": "anxiety_release",
                "name": "Anxiety Release",
                "emoji": "☁️",
                "duration_min": 7,
                "description": "Release tension and worry",
                "steps": [
                    "Body scan meditation",
                    "Worry cloud visualization",
                    "Grounding exercise with forest sounds"
                ]
            }
        ]
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
