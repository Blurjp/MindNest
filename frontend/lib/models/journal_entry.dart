import 'emotion.dart';

/// Journal entry for mood tracking
class JournalEntry {
  final int? id;
  final Emotion emotionBefore;
  final Emotion emotionAfter;
  final String sessionType;
  final DateTime timestamp;

  JournalEntry({
    this.id,
    required this.emotionBefore,
    required this.emotionAfter,
    required this.sessionType,
    required this.timestamp,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as int?,
      emotionBefore: Emotion.fromString(json['emotion_before'] as String),
      emotionAfter: Emotion.fromString(json['emotion_after'] as String),
      sessionType: json['session_type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'emotion_before': emotionBefore.name,
      'emotion_after': emotionAfter.name,
      'session_type': sessionType,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Calculate improvement score (-1 to 1)
  double get improvementScore {
    const emotionScores = {
      Emotion.anxious: 1,
      Emotion.sad: 2,
      Emotion.neutral: 3,
      Emotion.tired: 3,
      Emotion.calm: 5,
    };

    final beforeScore = emotionScores[emotionBefore] ?? 3;
    final afterScore = emotionScores[emotionAfter] ?? 3;

    return (afterScore - beforeScore) / 4.0; // Normalize to -1 to 1
  }
}
