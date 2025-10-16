import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulse - Home'),
        // TODO: Add settings navigation button
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add welcome message with user's name
            const Text(
              'Welcome to Pulse',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // TODO: Add daily reflection status/history view
            const Text('Daily reflection status goes here'),
            const SizedBox(height: 40),
            // TODO: Add large button to start daily check-in
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to question screen
                Navigator.pushNamed(context, '/question');
              },
              child: const Text('Start Daily Check-in'),
            ),
          ],
        ),
      ),
    );
  }
}
