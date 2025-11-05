"""
Pydantic models for request/response validation
"""

from pydantic import BaseModel, Field
from typing import Optional, Literal
from datetime import datetime


class EmotionRequest(BaseModel):
    """Request model for emotion detection"""
    text: Optional[str] = None
    audio_url: Optional[str] = None

    class Config:
        json_schema_extra = {
            "example": {
                "text": "I feel nervous and can't sleep tonight"
            }
        }


class EmotionResponse(BaseModel):
    """Response model for emotion detection"""
    emotion: Literal["anxious", "sad", "tired", "calm", "neutral"]
    confidence: float = Field(ge=0.0, le=1.0)

    class Config:
        json_schema_extra = {
            "example": {
                "emotion": "anxious",
                "confidence": 0.85
            }
        }


class MeditationRequest(BaseModel):
    """Request model for meditation generation"""
    emotion: Literal["anxious", "sad", "tired", "calm", "neutral"]
    duration_minutes: int = Field(default=5, ge=1, le=30)
    voice_style: Literal["male", "female"] = "female"

    class Config:
        json_schema_extra = {
            "example": {
                "emotion": "anxious",
                "duration_minutes": 5,
                "voice_style": "female"
            }
        }


class MeditationResponse(BaseModel):
    """Response model for meditation generation"""
    text: str
    audio_url: str
    duration_seconds: int

    class Config:
        json_schema_extra = {
            "example": {
                "text": "It's okay, you're safe now. Let's take a slow breath together...",
                "audio_url": "https://cdn.mindnest.ai/audio/relax1.mp3",
                "duration_seconds": 45
            }
        }


class JournalRequest(BaseModel):
    """Request model for journal entry"""
    emotion_before: Literal["anxious", "sad", "tired", "calm", "neutral"]
    emotion_after: Literal["anxious", "sad", "tired", "calm", "neutral"]
    session_type: Optional[str] = "meditation"

    class Config:
        json_schema_extra = {
            "example": {
                "emotion_before": "anxious",
                "emotion_after": "calm",
                "session_type": "meditation"
            }
        }


class JournalResponse(BaseModel):
    """Response model for journal entry"""
    status: str
    entry_id: int
    message: str

    class Config:
        json_schema_extra = {
            "example": {
                "status": "logged",
                "entry_id": 42,
                "message": "Your progress has been recorded"
            }
        }


class JournalEntry(BaseModel):
    """Model for journal entry"""
    id: int
    emotion_before: str
    emotion_after: str
    session_type: str
    timestamp: str

    class Config:
        json_schema_extra = {
            "example": {
                "id": 1,
                "emotion_before": "anxious",
                "emotion_after": "calm",
                "session_type": "meditation",
                "timestamp": "2025-11-05T10:30:00"
            }
        }
