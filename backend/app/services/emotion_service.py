"""
Emotion Detection Service

Uses keyword matching for MVP. Can be replaced with:
- Whisper API for speech-to-text
- Hume AI or HuggingFace emotion classifier
"""

import re
from typing import Optional, Literal


class EmotionService:
    """Service for detecting emotional state from text or audio"""

    # Emotion keyword mappings
    EMOTION_KEYWORDS = {
        "anxious": [
            "anxious", "worried", "nervous", "stressed", "panic", "overwhelmed",
            "fear", "tense", "uneasy", "restless", "anxiet"
        ],
        "sad": [
            "sad", "depressed", "down", "lonely", "hopeless", "miserable",
            "unhappy", "blue", "heartbroken", "grief", "sorrow"
        ],
        "tired": [
            "tired", "exhausted", "sleepy", "fatigue", "drained", "weary",
            "worn out", "can't sleep", "insomnia", "restless night"
        ],
        "calm": [
            "calm", "peaceful", "relaxed", "content", "serene", "tranquil",
            "centered", "balanced", "at ease", "good"
        ]
    }

    async def detect_emotion(
        self,
        text: Optional[str] = None,
        audio_url: Optional[str] = None
    ) -> Literal["anxious", "sad", "tired", "calm", "neutral"]:
        """
        Detect emotion from text or audio input

        For MVP, uses simple keyword matching.
        Production version would use:
        1. Whisper for audio_url -> text transcription
        2. Hume AI or emotion classifier model

        Args:
            text: User's text input
            audio_url: URL to audio file (not implemented in MVP)

        Returns:
            Detected emotion: anxious, sad, tired, calm, or neutral
        """

        # For MVP, only handle text input
        if not text:
            return "neutral"

        # Convert to lowercase for matching
        text_lower = text.lower()

        # Score each emotion based on keyword matches
        emotion_scores = {}

        for emotion, keywords in self.EMOTION_KEYWORDS.items():
            score = 0
            for keyword in keywords:
                # Use regex for partial matches
                if re.search(r'\b' + keyword, text_lower):
                    score += 1
            if score > 0:
                emotion_scores[emotion] = score

        # Return emotion with highest score, or neutral if none
        if emotion_scores:
            detected_emotion = max(emotion_scores, key=emotion_scores.get)
            return detected_emotion

        return "neutral"

    async def transcribe_audio(self, audio_url: str) -> str:
        """
        Transcribe audio to text using Whisper API

        TODO: Implement for production
        - Use OpenAI Whisper API
        - Or local Whisper model
        """
        # Placeholder for MVP
        raise NotImplementedError("Audio transcription not implemented in MVP")
