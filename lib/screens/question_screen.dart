import 'package:flutter/material.dart';
import '../services/supabase_client_manager.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final _reflectionController = TextEditingController();
  bool _isLoading = false;
  String? _selectedMood;
  String _currentQuestionText = 'How are you feeling today?';

  // Mood options with emoji and label
  final List<Map<String, String>> _moodOptions = [
    {'emoji': '😄', 'label': 'Happy'},
    {'emoji': '😐', 'label': 'Neutral'},
    {'emoji': '😢', 'label': 'Sad'},
    {'emoji': '😠', 'label': 'Angry'},
    {'emoji': '😴', 'label': 'Tired'},
  ];

  // Pool of static questions for seniors
  final List<String> _questionPool = [
    'How are you feeling today?',
    'What made you smile today?',
    'What are you grateful for right now?',
    'Tell me about something that brought you joy recently.',
    'What\'s on your mind today?',
    'How did you spend your time today?',
    'What would make today a good day for you?',
    'Is there anything you\'d like to share?',
  ];

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  /// Generate a new question from the static pool
  void _generateNewQuestion() {
    setState(() {
      // Get a random question different from the current one
      final availableQuestions = _questionPool
          .where((q) => q != _currentQuestionText)
          .toList();

      if (availableQuestions.isNotEmpty) {
        availableQuestions.shuffle();
        _currentQuestionText = availableQuestions.first;
      }
    });
  }

  /// Skip the current question and return to home
  void _skipQuestion() {
    Navigator.pop(context);
  }

  Future<void> _submitReflection() async {
    final content = _reflectionController.text.trim();

    if (content.isEmpty) {
      _showError('Please write something before submitting');
      return;
    }

    // Get current user
    final user = SupabaseClientManager.auth.currentUser;
    if (user == null) {
      _showError('You must be logged in to submit a reflection');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Insert reflection into Supabase reflections table
      // NOTE: Requires the following table schema in Supabase:
      //
      // CREATE TABLE reflections (
      //   id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      //   user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
      //   content TEXT NOT NULL,
      //   question_text TEXT NOT NULL,
      //   mood TEXT,
      //   created_at TIMESTAMPTZ DEFAULT NOW()
      // );
      //
      // -- Enable Row Level Security
      // ALTER TABLE reflections ENABLE ROW LEVEL SECURITY;
      //
      // -- Policy: Users can insert their own reflections
      // CREATE POLICY "Users can insert own reflections"
      //   ON reflections FOR INSERT
      //   WITH CHECK (auth.uid() = user_id);
      //
      // -- Policy: Users can select their own reflections
      // CREATE POLICY "Users can select own reflections"
      //   ON reflections FOR SELECT
      //   USING (auth.uid() = user_id);
      //
      await SupabaseClientManager.client.from('reflections').insert({
        'user_id': user.id,
        'content': content,
        'question_text': _currentQuestionText, // Store the question shown
        'mood': _selectedMood, // Store selected emoji mood
      });

      if (mounted) {
        // Success! Navigate back to home
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reflection saved successfully!', style: TextStyle(fontSize: 16)),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError('Failed to save reflection: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 16)),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label) {
    final isSelected = _selectedMood == emoji;

    return Expanded(
      child: GestureDetector(
        onTap: _isLoading
            ? null
            : () {
                setState(() {
                  _selectedMood = emoji;
                });
              },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: isSelected ? 3 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.blue : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
      ),
      // Prevent keyboard from resizing the screen - keeps UI stable
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // 1. Question Text (dynamic)
              Text(
                _currentQuestionText,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // New Question button
              TextButton.icon(
                onPressed: _isLoading ? null : _generateNewQuestion,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('New Question', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 24),
              // 2. Multiline TextFormField
              TextField(
                controller: _reflectionController,
                decoration: const InputDecoration(
                  hintText: 'Share your thoughts...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                style: const TextStyle(fontSize: 18),
                enabled: !_isLoading,
                // Automatically scroll to show cursor when keyboard appears
                scrollPadding: const EdgeInsets.only(bottom: 200),
              ),
              const SizedBox(height: 24),
              // 3. Row of emoji mood buttons
              // TODO: Mood Picker adjusted position by Claude v2
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _moodOptions.map((mood) {
                  return _buildMoodButton(mood['emoji']!, mood['label']!);
                }).toList()
                  ..insert(1, const SizedBox(width: 8))
                  ..insert(3, const SizedBox(width: 8))
                  ..insert(5, const SizedBox(width: 8))
                  ..insert(7, const SizedBox(width: 8)),
              ),
              const SizedBox(height: 32),
              // 4. Skip and Submit buttons
              Row(
                children: [
                  // Skip button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _skipQuestion,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Skip', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Submit button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submitReflection,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Submit', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
              // Extra padding at bottom to ensure buttons are visible above keyboard
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
