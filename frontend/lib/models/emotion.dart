/// Emotion types supported by MindNest
enum Emotion {
  anxious,
  sad,
  tired,
  calm,
  neutral;

  /// Get emoji representation
  String get emoji {
    switch (this) {
      case Emotion.anxious:
        return '😔';
      case Emotion.sad:
        return '😢';
      case Emotion.tired:
        return '😴';
      case Emotion.calm:
        return '🙂';
      case Emotion.neutral:
        return '😐';
    }
  }

  /// Get display label
  String get label {
    switch (this) {
      case Emotion.anxious:
        return 'Anxious';
      case Emotion.sad:
        return 'Sad';
      case Emotion.tired:
        return 'Tired';
      case Emotion.calm:
        return 'Calm';
      case Emotion.neutral:
        return 'Neutral';
    }
  }

  /// Get color representation
  String get colorHex {
    switch (this) {
      case Emotion.anxious:
        return '#FF6B6B'; // Soft red
      case Emotion.sad:
        return '#4ECDC4'; // Soft teal
      case Emotion.tired:
        return '#95A5F5'; // Soft purple
      case Emotion.calm:
        return '#6BCF7F'; // Soft green
      case Emotion.neutral:
        return '#B8C5D6'; // Soft gray
    }
  }

  /// Parse from string
  static Emotion fromString(String value) {
    return Emotion.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => Emotion.neutral,
    );
  }
}
