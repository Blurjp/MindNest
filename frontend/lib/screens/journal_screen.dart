import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';

/// Journal screen - Mood tracking and progress
class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final DatabaseService _db = DatabaseService.instance;
  List<JournalEntry> _entries = [];
  double _weeklyImprovement = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final entries = await _db.getAllJournalEntries(limit: 30);
      final improvement = await _db.getWeeklyImprovement();

      setState(() {
        _entries = entries;
        _weeklyImprovement = improvement;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading journal data: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667EEA),
              Color(0xFF764BA2),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'My Journal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Weekly improvement card
        _buildImprovementCard(),

        const SizedBox(height: 24),

        // Weekly chart
        _buildWeeklyChart(),

        const SizedBox(height: 24),

        // Recent entries
        _buildRecentEntries(),
      ],
    );
  }

  Widget _buildImprovementCard() {
    final isPositive = _weeklyImprovement >= 50;
    final color = isPositive ? Colors.green : Colors.orange;
    final icon = isPositive ? Icons.trending_up : Icons.trending_flat;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            'Weekly Progress',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(width: 8),
              Text(
                '${_weeklyImprovement.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _entries.isEmpty
                ? 'Start your first session!'
                : 'You\'re making great progress!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    if (_entries.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Complete sessions to see your chart',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // Get last 7 days of entries
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final weeklyEntries = _entries
        .where((e) => e.timestamp.isAfter(weekAgo))
        .toList()
        .reversed
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mood Trend (7 Days)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= weeklyEntries.length) {
                          return const Text('');
                        }
                        final entry = weeklyEntries[value.toInt()];
                        return Text(
                          DateFormat('E').format(entry.timestamp),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  // Before line
                  LineChartBarData(
                    spots: weeklyEntries.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        _emotionToScore(entry.value.emotionBefore),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.red.withOpacity(0.7),
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                  // After line
                  LineChartBarData(
                    spots: weeklyEntries.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        _emotionToScore(entry.value.emotionAfter),
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.green.withOpacity(0.7),
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(Colors.red.withOpacity(0.7), 'Before'),
              const SizedBox(width: 24),
              _buildLegend(Colors.green.withOpacity(0.7), 'After'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 3,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  double _emotionToScore(emotion) {
    const scores = {
      'anxious': 1.0,
      'sad': 2.0,
      'neutral': 3.0,
      'tired': 3.0,
      'calm': 5.0,
    };
    return scores[emotion.name] ?? 3.0;
  }

  Widget _buildRecentEntries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Sessions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (_entries.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No entries yet. Complete a meditation to start tracking!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ..._entries.take(10).map((entry) => _buildEntryCard(entry)),
      ],
    );
  }

  Widget _buildEntryCard(JournalEntry entry) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMM d').format(entry.timestamp),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(entry.timestamp),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Emotions
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(entry.emotionBefore.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(entry.emotionAfter.emoji, style: const TextStyle(fontSize: 24)),
              ],
            ),
          ),

          // Improvement indicator
          if (entry.improvementScore > 0)
            const Icon(Icons.trending_up, color: Colors.green, size: 20)
          else if (entry.improvementScore < 0)
            const Icon(Icons.trending_down, color: Colors.orange, size: 20)
          else
            const Icon(Icons.trending_flat, color: Colors.white70, size: 20),
        ],
      ),
    );
  }
}
