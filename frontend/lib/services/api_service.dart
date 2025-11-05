import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/emotion.dart';
import '../models/meditation_session.dart';
import '../models/journal_entry.dart';
import '../models/sleep_routine.dart';

/// API service for communicating with MindNest backend
class ApiService {
  // Change this to your backend URL
  static const String baseUrl = 'http://localhost:8000';

  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Detect emotion from text
  Future<Emotion> detectEmotion(String text) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/emotion'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Emotion.fromString(data['emotion']);
      } else {
        throw Exception('Failed to detect emotion: ${response.statusCode}');
      }
    } catch (e) {
      print('Error detecting emotion: $e');
      // Fallback to neutral on error
      return Emotion.neutral;
    }
  }

  /// Generate personalized meditation
  Future<MeditationSession> generateMeditation({
    required Emotion emotion,
    int durationMinutes = 5,
    String voiceStyle = 'female',
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/meditate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emotion': emotion.name,
          'duration_minutes': durationMinutes,
          'voice_style': voiceStyle,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return MeditationSession.fromJson(data, emotion);
      } else {
        throw Exception('Failed to generate meditation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error generating meditation: $e');
      rethrow;
    }
  }

  /// Log mood journal entry
  Future<void> logJournal({
    required Emotion emotionBefore,
    required Emotion emotionAfter,
    String sessionType = 'meditation',
  }) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/journal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'emotion_before': emotionBefore.name,
          'emotion_after': emotionAfter.name,
          'session_type': sessionType,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to log journal: ${response.statusCode}');
      }
    } catch (e) {
      print('Error logging journal: $e');
      rethrow;
    }
  }

  /// Get journal entries
  Future<List<JournalEntry>> getJournalEntries({int limit = 30}) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/journal?limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => JournalEntry.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get journal entries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting journal entries: $e');
      return [];
    }
  }

  /// Get sleep routines
  Future<List<SleepRoutine>> getSleepRoutines() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/routines'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> routines = data['routines'];
        return routines.map((json) => SleepRoutine.fromJson(json)).toList();
      } else {
        throw Exception('Failed to get routines: ${response.statusCode}');
      }
    } catch (e) {
      print('Error getting routines: $e');
      return [];
    }
  }

  void dispose() {
    _client.close();
  }
}
