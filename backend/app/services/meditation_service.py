"""
Meditation Generation Service

Generates personalized meditation scripts using AI (GPT-5 or Claude)
Converts to speech using TTS (ElevenLabs or OpenAI TTS)
"""

import os
from typing import Literal, Dict
import hashlib


class MeditationService:
    """Service for generating AI-powered meditation scripts and audio"""

    # AI System prompts for different emotional states
    MEDITATION_PROMPTS = {
        "anxious": """You are MindNest, a gentle AI meditation guide.
The user feels anxious. Your goal is to calm their nervous system.

Speak in calm, short, rhythmic sentences.
Guide them through:
1. Slow, deep breathing (4-4-4 box breathing)
2. Reassurance that they are safe
3. Grounding in the present moment

Use gentle, warm language. Keep sentences under 10 words.
Focus on physical sensations and safety.
Speak as if you're a caring friend, not a clinical therapist.

Duration: {duration} minutes of spoken content.""",

        "sad": """You are MindNest, a gentle AI meditation guide.
The user feels sad. Your goal is to offer compassionate presence.

Speak in soft, empathetic, comforting sentences.
Acknowledge their feelings without trying to fix them.
Guide them through:
1. Gentle breathing
2. Self-compassion exercise
3. Reminder that feelings pass like clouds

Use warm, accepting language. Keep sentences under 10 words.
Be a loving presence, not a motivational speaker.

Duration: {duration} minutes of spoken content.""",

        "tired": """You are MindNest, a gentle AI meditation guide.
The user feels tired and wants to sleep. Your goal is to guide them into rest.

Speak in slow, drowsy, soothing sentences.
Use sleep-inducing language and imagery.
Guide them through:
1. Progressive muscle relaxation
2. Sleepy visualization (floating on clouds, gentle waves)
3. Soft countdown to sleep

Use repetitive, hypnotic patterns. Speak slowly.
Fade into softer and softer words.

Duration: {duration} minutes of spoken content.""",

        "calm": """You are MindNest, a gentle AI meditation guide.
The user feels calm. Your goal is to deepen their peace.

Speak in serene, flowing, peaceful sentences.
Guide them through:
1. Mindful breathing
2. Appreciation meditation
3. Settling into stillness

Use nature imagery (ocean, forest, sky).
Keep sentences under 10 words.

Duration: {duration} minutes of spoken content.""",

        "neutral": """You are MindNest, a gentle AI meditation guide.
The user has a neutral mood. Your goal is to center and ground them.

Speak in balanced, clear, grounding sentences.
Guide them through:
1. Body awareness meditation
2. Present moment focus
3. Gentle energizing breath

Use simple, direct language. Keep sentences under 10 words.

Duration: {duration} minutes of spoken content."""
    }

    # Sample meditation scripts for MVP (when AI not available)
    SAMPLE_MEDITATIONS = {
        "anxious": """It's okay. You're safe right now. Let's breathe together.

Breathe in slowly. Count to four. One. Two. Three. Four.

Hold gently. Two. Three. Four.

Breathe out slowly. Two. Three. Four.

Feel your feet on the ground. You are here. You are safe.

Your breath is your anchor. Come back to it.

In. Two. Three. Four. Out. Two. Three. Four.

Notice your body softening. Your shoulders dropping.

You're doing beautifully. Just breathe.

This feeling will pass. You are strong. You are safe.""",

        "sad": """I see you. Your feelings matter.

Take a gentle breath. Let yourself feel.

It's okay to be sad. You don't have to fix anything.

Place your hand on your heart. Feel its warmth.

You are not alone. I'm here with you.

Breathe in compassion. Breathe out pain.

Your heart is healing. Give it time.

Like clouds, this will pass. Not now. But it will.

You are loved. You are enough. Just as you are.""",

        "tired": """Let yourself rest now. You've done enough.

Close your eyes. Let them be heavy.

Feel your body sinking. Into softness. Into peace.

Breathe in calm. Breathe out tension.

Your forehead relaxes. Your jaw softens.

Your shoulders melt. Your arms feel heavy.

Imagine floating. On gentle waves. Or soft clouds.

You're safe. You can let go now.

Sleep is coming. Like a warm blanket.

Ten. Nine. Drifting deeper. Eight. Seven. So peaceful.

Six. Five. Let go. Four. Three. Resting.

Two. One. Sleep now. Sleep.""",

        "calm": """You are here. In this peaceful moment.

Breathe naturally. Notice the quiet.

Feel the stillness inside you. Like a calm lake.

Each breath deepens your peace.

Notice sounds around you. Without judging.

Notice sensations. Without changing them.

You are centered. You are whole.

This peace is always here. Inside you.

Breathe in gratitude. Breathe out love.

Carry this calm with you. Into your day.""",

        "neutral": """Welcome. Let's take this moment together.

Sit comfortably. Feel your body supported.

Bring attention to your breath. Natural rhythm.

Notice the air. Cool in. Warm out.

Scan your body gently. Head to toe.

Where do you feel alive? Where do you feel numb?

No judgment. Just noticing. Just being.

You are present. You are aware.

This is enough. You are enough.

Breathe. Be. Rest in this moment."""
    }

    def __init__(self):
        """Initialize meditation service with API keys"""
        # For production, load from environment
        self.openai_api_key = os.getenv("OPENAI_API_KEY")
        self.elevenlabs_api_key = os.getenv("ELEVENLABS_API_KEY")
        self.anthropic_api_key = os.getenv("ANTHROPIC_API_KEY")

    async def generate_meditation(
        self,
        emotion: Literal["anxious", "sad", "tired", "calm", "neutral"],
        duration_minutes: int = 5,
        voice_style: Literal["male", "female"] = "female"
    ) -> Dict[str, any]:
        """
        Generate personalized meditation script and audio

        For MVP: Returns sample meditation text
        For Production: Call GPT-5/Claude API + TTS API

        Args:
            emotion: User's emotional state
            duration_minutes: Length of meditation
            voice_style: Voice preference for TTS

        Returns:
            Dictionary with text, audio_url, and duration_seconds
        """

        # For MVP, use sample meditations
        meditation_text = self.SAMPLE_MEDITATIONS.get(emotion, self.SAMPLE_MEDITATIONS["neutral"])

        # Generate a mock audio URL (in production, this would be real TTS)
        audio_filename = self._generate_audio_filename(emotion, duration_minutes, voice_style)
        audio_url = f"https://cdn.mindnest.ai/audio/{audio_filename}"

        # Estimate duration (roughly 2 words per second for calm speech)
        word_count = len(meditation_text.split())
        duration_seconds = int(word_count / 2)

        return {
            "text": meditation_text,
            "audio_url": audio_url,
            "duration_seconds": duration_seconds
        }

    async def generate_with_ai(
        self,
        emotion: Literal["anxious", "sad", "tired", "calm", "neutral"],
        duration_minutes: int
    ) -> str:
        """
        Generate meditation script using GPT-5 or Claude API

        TODO: Implement for production
        - Call OpenAI API with system prompt
        - Or use Anthropic Claude API
        - Return generated meditation text
        """
        # Placeholder for production implementation
        prompt = self.MEDITATION_PROMPTS[emotion].format(duration=duration_minutes)

        # Example pseudo-code for production:
        # response = openai.ChatCompletion.create(
        #     model="gpt-4",
        #     messages=[
        #         {"role": "system", "content": prompt},
        #         {"role": "user", "content": f"Create a {duration_minutes} minute meditation"}
        #     ]
        # )
        # return response.choices[0].message.content

        raise NotImplementedError("AI generation not implemented in MVP")

    async def generate_audio(self, text: str, voice_style: str) -> str:
        """
        Generate audio from text using TTS API

        TODO: Implement for production
        - Use ElevenLabs API (recommended for quality)
        - Or use OpenAI TTS API
        - Upload to CDN
        - Return audio URL
        """
        # Placeholder for production implementation

        # Example pseudo-code for ElevenLabs:
        # response = elevenlabs.generate(
        #     text=text,
        #     voice="Bella",  # or male voice
        #     model="eleven_monolingual_v1"
        # )
        # audio_file = response.audio
        # cdn_url = upload_to_cdn(audio_file)
        # return cdn_url

        raise NotImplementedError("TTS generation not implemented in MVP")

    def _generate_audio_filename(self, emotion: str, duration: int, voice: str) -> str:
        """Generate unique filename for audio cache"""
        content = f"{emotion}_{duration}_{voice}"
        hash_value = hashlib.md5(content.encode()).hexdigest()[:8]
        return f"{emotion}_{hash_value}.mp3"

    def get_system_prompt(self, emotion: str, duration_minutes: int) -> str:
        """Get AI system prompt for specific emotion"""
        return self.MEDITATION_PROMPTS.get(emotion, self.MEDITATION_PROMPTS["neutral"]).format(
            duration=duration_minutes
        )
