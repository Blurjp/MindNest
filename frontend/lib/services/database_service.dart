import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/journal_entry.dart';
import '../models/emotion.dart';

/// Local database service for offline storage
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mindnest.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emotion_before TEXT NOT NULL,
        emotion_after TEXT NOT NULL,
        session_type TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Insert journal entry
  Future<int> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    return await db.insert('journal_entries', {
      'emotion_before': entry.emotionBefore.name,
      'emotion_after': entry.emotionAfter.name,
      'session_type': entry.sessionType,
      'timestamp': entry.timestamp.toIso8601String(),
    });
  }

  /// Get all journal entries
  Future<List<JournalEntry>> getAllJournalEntries({int limit = 100}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'journal_entries',
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) {
      return JournalEntry(
        id: map['id'] as int,
        emotionBefore: Emotion.fromString(map['emotion_before'] as String),
        emotionAfter: Emotion.fromString(map['emotion_after'] as String),
        sessionType: map['session_type'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
    }).toList();
  }

  /// Get journal entries for date range
  Future<List<JournalEntry>> getJournalEntriesInRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'journal_entries',
      where: 'timestamp BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'timestamp DESC',
    );

    return maps.map((map) {
      return JournalEntry(
        id: map['id'] as int,
        emotionBefore: Emotion.fromString(map['emotion_before'] as String),
        emotionAfter: Emotion.fromString(map['emotion_after'] as String),
        sessionType: map['session_type'] as String,
        timestamp: DateTime.parse(map['timestamp'] as String),
      );
    }).toList();
  }

  /// Get weekly journal entries
  Future<List<JournalEntry>> getWeeklyEntries() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return getJournalEntriesInRange(weekAgo, now);
  }

  /// Calculate weekly improvement percentage
  Future<double> getWeeklyImprovement() async {
    final entries = await getWeeklyEntries();
    if (entries.isEmpty) return 0.0;

    final avgImprovement = entries
        .map((e) => e.improvementScore)
        .reduce((a, b) => a + b) / entries.length;

    // Convert to percentage (0-100)
    return ((avgImprovement + 1) / 2) * 100;
  }

  /// Save user setting
  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get user setting
  Future<String?> getSetting(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_settings',
      where: 'key = ?',
      whereArgs: [key],
    );

    if (maps.isEmpty) return null;
    return maps.first['value'] as String;
  }

  /// Clear all data (for testing)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('journal_entries');
    await db.delete('user_settings');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
