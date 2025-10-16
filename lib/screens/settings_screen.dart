import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // TODO: Add user profile section (name, age)
            const ListTile(
              title: Text('Profile', style: TextStyle(fontSize: 20)),
              subtitle: Text('Edit your profile information'),
            ),
            const Divider(),
            // TODO: Add family email settings
            const ListTile(
              title: Text('Family Email', style: TextStyle(fontSize: 20)),
              subtitle: Text('Manage weekly email recipients'),
            ),
            const Divider(),
            // TODO: Add notification settings
            const ListTile(
              title: Text('Notifications', style: TextStyle(fontSize: 20)),
              subtitle: Text('Configure daily check-in reminders'),
            ),
            const Divider(),
            // TODO: Add logout button
            ListTile(
              title: const Text('Logout', style: TextStyle(fontSize: 20, color: Colors.red)),
              onTap: () {
                // TODO: Handle logout and navigate to login screen
              },
            ),
          ],
        ),
      ),
    );
  }
}
