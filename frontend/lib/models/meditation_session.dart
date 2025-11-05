import 'emotion.dart';

/// Meditation session response from API
class MeditationSession {
  final String text;
  final String audioUrl;
  final int durationSeconds;
  final Emotion emotion;

  MeditationSession({
    required this.text,
    required this.audioUrl,
    required this.durationSeconds,
    required this.emotion,
  });

  factory MeditationSession.fromJson(Map<String, dynamic> json, Emotion emotion) {
    return MeditationSession(
      text: json['text'] as String,
      audioUrl: json['audio_url'] as String,
      durationSeconds: json['duration_seconds'] as int,
      emotion: emotion,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'audio_url': audioUrl,
      'duration_seconds': durationSeconds,
      'emotion': emotion.name,
    };
  }
}
