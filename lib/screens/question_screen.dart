import 'package:flutter/material.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Check-in'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Add daily prompt/question with large text
            const Text(
              'How are you feeling today?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // TODO: Add text input field for reflection (large, senior-friendly)
            const TextField(
              decoration: InputDecoration(
                hintText: 'Share your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            // TODO: Add submit button to save reflection
            ElevatedButton(
              onPressed: () {
                // TODO: Save reflection to Supabase
                // TODO: Navigate to home or summary screen
              },
              child: const Text('Submit', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
