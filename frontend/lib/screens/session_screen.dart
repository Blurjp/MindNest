import 'package:flutter/material.dart';
import 'dart:async';
import '../models/meditation_session.dart';
import '../models/emotion.dart';
import '../models/journal_entry.dart';
import '../services/database_service.dart';

/// Session screen - Meditation playback with animations
class SessionScreen extends StatefulWidget {
  final MeditationSession session;
  final Emotion emotionBefore;

  const SessionScreen({
    Key? key,
    required this.session,
    required this.emotionBefore,
  }) : super(key: key);

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _breatheController;
  bool _isPlaying = true;
  int _currentWordIndex = 0;
  Timer? _wordTimer;
  List<String> _words = [];
  bool _showCompletionDialog = false;

  @override
  void initState() {
    super.initState();

    // Initialize breathing animation
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Split text into words for subtitle animation
    _words = widget.session.text.split(' ');

    // Start auto-playing words
    _startWordAnimation();
  }

  void _startWordAnimation() {
    // Calculate words per second (roughly 2 words per second for calm speech)
    final millisecondsPerWord = (widget.session.durationSeconds * 1000) ~/ _words.length;

    _wordTimer = Timer.periodic(Duration(milliseconds: millisecondsPerWord), (timer) {
      if (_currentWordIndex < _words.length - 1) {
        setState(() => _currentWordIndex++);
      } else {
        timer.cancel();
        _onSessionComplete();
      }
    });
  }

  void _onSessionComplete() {
    setState(() {
      _isPlaying = false;
      _showCompletionDialog = true;
    });
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        _breatheController.repeat(reverse: true);
        _startWordAnimation();
      } else {
        _breatheController.stop();
        _wordTimer?.cancel();
      }
    });
  }

  Future<void> _handleEmotionAfter(Emotion emotionAfter) async {
    // Save to local database
    final entry = JournalEntry(
      emotionBefore: widget.emotionBefore,
      emotionAfter: emotionAfter,
      sessionType: 'meditation',
      timestamp: DateTime.now(),
    );

    await DatabaseService.instance.insertJournalEntry(entry);

    if (mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Great work! Your progress has been saved.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _breatheController.dispose();
    _wordTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A5B8C), // Deep blue
              Color(0xFF2D3561), // Darker blue
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Spacer(),
                        Text(
                          '${_currentWordIndex * 100 ~/ _words.length}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Breathing animation
                  AnimatedBuilder(
                    animation: _breatheController,
                    builder: (context, child) {
                      final scale = 1.0 + (_breatheController.value * 0.3);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.6),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Breathing instruction
                  Text(
                    _breatheController.value < 0.5 ? 'Breathe in' : 'Breathe out',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Subtitle text with animation
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: Text(
                          _getCurrentSubtitle(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Play/Pause button
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                        size: 64,
                        color: Colors.white,
                      ),
                      onPressed: _togglePlayPause,
                    ),
                  ),
                ],
              ),

              // Completion dialog
              if (_showCompletionDialog) _buildCompletionDialog(),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentSubtitle() {
    // Show 5 words at a time
    final start = _currentWordIndex > 2 ? _currentWordIndex - 2 : 0;
    final end = (_currentWordIndex + 3).clamp(0, _words.length);
    return _words.sublist(start, end).join(' ');
  }

  Widget _buildCompletionDialog() {
    return Container(
      color: Colors.black.withOpacity(0.7),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF2D3561),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How do you feel now?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  _buildEmotionChip(Emotion.calm),
                  _buildEmotionChip(Emotion.neutral),
                  _buildEmotionChip(Emotion.tired),
                  _buildEmotionChip(Emotion.anxious),
                  _buildEmotionChip(Emotion.sad),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionChip(Emotion emotion) {
    return GestureDetector(
      onTap: () => _handleEmotionAfter(emotion),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emotion.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text(
              emotion.label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
