/// Predefined guided meditation routine
class SleepRoutine {
  final String id;
  final String name;
  final String emoji;
  final int durationMin;
  final String description;
  final List<String> steps;

  SleepRoutine({
    required this.id,
    required this.name,
    required this.emoji,
    required this.durationMin,
    required this.description,
    required this.steps,
  });

  factory SleepRoutine.fromJson(Map<String, dynamic> json) {
    return SleepRoutine(
      id: json['id'] as String,
      name: json['name'] as String,
      emoji: json['emoji'] as String,
      durationMin: json['duration_min'] as int,
      description: json['description'] as String,
      steps: (json['steps'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'emoji': emoji,
      'duration_min': durationMin,
      'description': description,
      'steps': steps,
    };
  }
}
