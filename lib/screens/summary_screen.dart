import 'package:flutter/material.dart';
import '../services/supabase_client_manager.dart';
import '../models/reflection.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  List<Reflection> _reflections = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReflections();
  }

  Future<void> _loadReflections() async {
    try {
      final user = SupabaseClientManager.auth.currentUser;
      if (user == null) {
        setState(() {
          _error = 'You must be logged in to view reflections';
          _isLoading = false;
        });
        return;
      }

      final response = await SupabaseClientManager.client
          .from('reflections')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(10);

      setState(() {
        _reflections = (response as List)
            .map((item) => Reflection.fromMap(item as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load reflections: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Past Reflections'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Reflections',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Display reflections or loading/error state
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(fontSize: 18, color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : _reflections.isEmpty
                          ? const Center(
                              child: Text(
                                'No reflections yet.\nStart your first daily check-in!',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                            )
                          : ListView.builder(
                              itemCount: _reflections.length,
                              itemBuilder: (context, index) {
                                final reflection = _reflections[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Date
                                        Text(
                                          _formatDate(reflection.createdAt),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        // Question
                                        Text(
                                          'Q: ${reflection.questionText}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        // Answer
                                        Text(
                                          'A: ${reflection.content}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        // Mood (if available)
                                        if (reflection.mood != null) ...[
                                          const SizedBox(height: 8),
                                          Text(
                                            'Mood: ${reflection.mood}',
                                            style: const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final reflectionDate = DateTime(date.year, date.month, date.day);

    if (reflectionDate == today) {
      return 'Today at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (reflectionDate == yesterday) {
      return 'Yesterday at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.month}/${date.day}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
